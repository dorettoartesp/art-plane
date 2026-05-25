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

Para validar customização local de código-fonte, use o alvo separado:

```bash
make dev-build-source
```

Acesse:

```text
http://localhost:8080
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
