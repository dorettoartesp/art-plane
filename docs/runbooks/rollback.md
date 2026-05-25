# Rollback

Rollback local e rollback de produção são operações diferentes.

## DEV

Para voltar o código:

```bash
git switch main
git pull
make dev-down
make dev-up
make smoke
```

Para descartar dados locais:

```bash
cd plane
docker compose --project-name art-plane-dev --env-file .env -f docker-compose.yml down -v
```

## STG/PRD

Exigir antes do deploy:

```text
- versão anterior conhecida
- imagem anterior disponível
- backup pré-deploy
- plano para migrations incompatíveis
- smoke test pós-rollback
```
