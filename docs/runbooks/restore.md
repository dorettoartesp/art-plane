# Restore

Restore de STG/PRD será detalhado após provisionamento das VMs e definição do mecanismo
de backup.

## Regra

Nenhum ambiente PRD deve entrar em uso sem restore testado em ambiente isolado.

## DEV

Para reset local:

```bash
cd plane
docker compose --project-name art-plane-dev --env-file .env -f docker-compose.yml down -v
cd ..
make dev-up
```
