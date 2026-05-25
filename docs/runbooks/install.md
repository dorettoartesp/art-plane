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

Use o build completo apenas antes de PRs maiores, release ou alterações que afetem backend,
workers, proxy ou compose:

```bash
make dev-build-source
```

## Validar

```bash
make smoke
```

O smoke test valida containers, health interno da API, web, admin e space via proxy local.

## Acesso

```text
http://localhost:8080
```

## Logs

```bash
make dev-logs
```

## Parar

```bash
make dev-down
```

## Reset de dados locais

Para remover containers e volumes do ambiente local:

```bash
cd plane
docker compose --project-name art-plane-dev --env-file .env -f docker-compose.yml down -v
```

Use `down -v` somente quando os dados locais puderem ser descartados.
