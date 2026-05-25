# Plane ARTESP

Monorepo institucional para manter o fork do Plane CE usado pela ARTESP.

Este repositório reúne:

- código-fonte do Plane CE em `plane/`;
- ambiente `dev` local reproduzível;
- documentação, runbooks e scripts operacionais;
- governança AGPL v3;
- preparação para `stg` e `prd` em VMs quando forem provisionadas.

O Plane deve ser tratado como ferramenta de gestão de trabalho, backlog, tarefas,
acompanhamento e documentação operacional. Exposição pública, concessionárias ou órgãos
externos devem usar uma camada externa controlada, não o Plane diretamente.

## Estrutura

```text
plane/                 Código-fonte do Plane CE incorporado ao monorepo
docs/runbooks/         Procedimentos operacionais
scripts/               Wrappers locais e scripts de operação
.agents/skills/        Skill institucional para agentes
VERSION.md             Versão upstream validada e estratégia de sync
COMPLIANCE.md          Conformidade AGPL v3
CHANGELOG.md           Alterações institucionais
ROLLBACK.md            Estratégia de rollback
```

## Requisitos Locais

- Git
- Make
- Docker Engine
- Docker Compose v2 (`docker compose`)
- curl

Recomendado: pelo menos 8 GB de RAM livres para os containers do Plane.

## Dev Local

Prepare os arquivos `.env` locais:

```bash
make dev-setup
```

Suba o Plane usando as imagens CE publicadas pelo upstream:

```bash
make dev-up
```

O fluxo padrão não compila o código-fonte do Plane. Ele usa
`plane/deployments/cli/community/docker-compose.yml` com imagens `makeplane/plane-*`,
para que uma máquina nova consiga subir o ambiente sem build longo.

Para validar customização local de código-fonte, escolha o menor alvo que cobre a mudança:

```bash
make plane-install        # primeira vez, instala deps locais do Plane via pnpm/Corepack
make check-web            # typecheck do app web
make build-web            # build local do app web, sem Docker
make check-admin
make build-admin
make check-space
make build-space
```

Use Docker apenas quando precisar validar a imagem/container gerado:

```bash
make dev-build-source-web      # mudanças no app web
make dev-build-source-admin    # mudanças no admin
make dev-build-source-space    # mudanças no space
make dev-build-source-ui       # mudanças nos três frontends
```

O primeiro build source via Docker pode ser demorado porque instala dependências dentro da
imagem. Para desenvolvimento diário, prefira `make check-*` e `make build-*`.

Use o build completo apenas como gate mais pesado, antes de PRs grandes, release ou mudança
em backend/infra:

```bash
make dev-build-source
```

Não é necessário rodar `make dev-build-source` a cada alteração. O fluxo diário deve ser:
`make dev-up`, editar, rodar `make check-*`/`make build-*` do app alterado e finalizar
com `make smoke`. O build Docker completo é gate de integração, não loop de edição.

Acesse:

```text
http://localhost:8080
```

No primeiro acesso, a tela `Setup your Plane Instance` cria o administrador local.
Use uma senha forte; o Plane valida a senha no backend e pode voltar para a mesma tela
quando a senha for fraca. Um exemplo valido para ambiente local seria:

```text
StrongPass123!
```

Rode smoke test:

```bash
make smoke
```

Veja logs:

```bash
make dev-logs
```

Pare o ambiente:

```bash
make dev-down
```

Para descartar completamente os dados locais de desenvolvimento e refazer o primeiro
setup:

```bash
make dev-reset
```

Esse comando remove volumes Docker do projeto `art-plane-dev`, incluindo banco local,
arquivos enviados, filas, cache e usuário admin criado no setup. Em execução não
interativa, confirme explicitamente:

```bash
ART_PLANE_RESET_CONFIRM=delete-dev-data make dev-reset
```

Fluxo manual recomendado para validar uma máquina nova:

```text
git clone
make dev-setup
make dev-up
abrir http://localhost:8080
fazer setup inicial com senha forte
login
criar workspace, projeto e tarefa
make smoke
```

## Arquivos `.env`

```text
.env.example              Template do wrapper local do monorepo
.env                      Configuração local do wrapper, ignorada pelo Git
plane/.env.example        Template upstream do Plane para compose/proxy
plane/.env                Configuração local para build source, ignorada pelo Git
plane/apps/api/.env       Configuração local da API, ignorada pelo Git
```

Nunca versionar `.env` reais, secrets, dumps, anexos, certificados privados ou dados
pessoais.

## Sincronização Upstream

O código do Plane é uma pasta normal em `plane/`, não submodule.

Use o remoto `upstream-plane` para buscar novas versões:

```bash
git fetch upstream-plane --tags
git subtree pull --prefix=plane upstream-plane vX.Y.Z --squash
```

Após cada atualização, revisar conflitos, migrations, variáveis de ambiente, build, smoke
test, `VERSION.md`, `CHANGELOG.md` e rollback.

## STG e PRD

`stg` e `prd` serão ambientes self-hosted em VMs. Enquanto essas VMs não forem
provisionadas, scripts de deploy, backup e restore devem permanecer parametrizados e sem
hosts, DNS, SSH keys ou secrets reais.
