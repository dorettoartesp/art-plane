# Rollback

Este arquivo resume a estratégia de rollback do monorepo Plane ARTESP.

## DEV

O ambiente local é descartável:

```bash
make dev-down
make dev-up
make smoke
```

Para apagar dados locais:

```bash
cd plane
docker compose --project-name art-plane-dev --env-file .env -f docker-compose.yml down -v
```

## STG/PRD

Será detalhado quando as VMs forem provisionadas. Antes de qualquer deploy produtivo,
registrar:

```text
- versão atual
- versão alvo
- imagem/artefato anterior
- backup pré-deploy
- migrations envolvidas
- procedimento de retorno
- smoke test pós-rollback
```
