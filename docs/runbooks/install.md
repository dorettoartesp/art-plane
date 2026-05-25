# Instalação Local

Este runbook instala o ambiente `dev` em uma máquina nova. Ele não usa VM institucional.

## Pré-requisitos

Instalar:

```text
Git
Make
Docker Engine
Docker Compose v2
curl
```

Confirmar:

```bash
docker --version
docker compose version
make --version
```

## Clone

```bash
git clone <URL_DO_REPOSITORIO> art-plane
cd art-plane
```

Este repositório é monorepo. O código do Plane já vem em `plane/`; não há submodule.

## Configuração

```bash
make dev-setup
```

O comando cria:

```text
.env
plane/.env
plane/apps/api/.env
```

Esses arquivos são locais e não devem ser commitados.

## Subir

```bash
make dev-up
```

O fluxo padrão usa as imagens CE publicadas `makeplane/plane-*` e não compila o código
do Plane. Isso é intencional para permitir instalação local rápida em uma máquina nova.

Para validar mudanças no código em `plane/`, escolha o menor alvo que cobre a alteração:

```bash
make plane-install
make check-web
make build-web
make check-admin
make build-admin
make check-space
make build-space
```

Use Docker apenas quando precisar validar a imagem/container gerado:

```bash
make dev-build-source-web
make dev-build-source-admin
make dev-build-source-space
make dev-build-source-ui
```

Os builds locais de código-fonte via Docker (`make dev-build-source-*`) são totalmente otimizados por meio de cache de camadas e cache persistente do BuildKit:

* **Primeiro Build (sem cache)**: Leva de 8 a 15 minutos, pois precisa compilar o Turborepo e baixar todas as dependências NPM exigidas especificamente para o escopo da imagem.
* **Builds Subsequentes (após alteração de arquivos de código)**: Leva de 1 a 3 minutos. Toda a instalação do `pnpm install` é recuperada de forma instantânea em 0.0 segundos do cache do Docker (`CACHED`), compilando apenas o delta dos arquivos alterados no container.
* **Mudanças em dependências (`package.json`)**: Leva de 2 a 4 minutos. O BuildKit utiliza o cache persistente local de pnpm (`/pnpm/store`), buscando apenas as novas dependências em vez de baixar todas do zero.

Este caminho de build via Docker é excelente como gate de integração; o loop de desenvolvimento diário e rápido ainda pode usar `make check-*` e `make build-*` diretamente no host.

Use o build completo apenas antes de PRs maiores, release ou alterações que afetem backend,
workers, proxy ou compose:

```bash
make dev-build-source
```

## Validar

```bash
make smoke
```

O smoke test valida containers, health interno da API, web, admin, space e o endpoint
`/api/instances/`. Se `is_setup_done=false`, o ambiente está saudável, mas o primeiro
setup ainda precisa ser concluído no navegador.

## Acesso

```text
http://localhost:8080
```

No primeiro acesso, preencha `Setup your Plane Instance` para criar o administrador
local. Use uma senha forte; se a senha for fraca, o Plane pode voltar para a mesma tela.
Exemplo de senha forte para dev local:

```text
StrongPass123!
```

Depois do setup, faça login e crie pelo menos um workspace, um projeto e uma tarefa
para validar o fluxo funcional básico.

## Logs

```bash
make dev-logs
```

## Parar

```bash
make dev-down
```

## Reset de dados locais

Para remover containers e volumes do ambiente local e refazer o setup inicial:

```bash
make dev-reset
```

Esse comando apaga banco local, arquivos enviados, filas, cache e usuário admin do
ambiente `dev`. Ele pede confirmação textual. Em execução não interativa:

```bash
ART_PLANE_RESET_CONFIRM=delete-dev-data make dev-reset
```

Use somente quando os dados locais puderem ser descartados. Nunca use esse fluxo para
`stg` ou `prd`.

## Validação completa de máquina nova

```text
git clone <URL_DO_REPOSITORIO> art-plane
cd art-plane
make dev-setup
make dev-up
abrir http://localhost:8080
fazer setup inicial com senha forte
login
criar workspace, projeto e tarefa
make smoke
```

* **Status de Homologação**: Este fluxo foi integralmente testado, validado e homologado com sucesso em 25/05/2026. A stack limpa inicializa corretamente em estado virgem (`is_setup_done=false`), processa o cadastro do administrador local de forma segura, realiza a rotação de segurança dos tokens de sessão/CSRF e permite a criação imediata de workspaces, projetos e tarefas sem gargalos.

