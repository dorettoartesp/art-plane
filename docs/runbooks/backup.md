# Backup

O backup de produção será implementado após provisionamento de STG/PRD.

## DEV

O ambiente local usa volumes Docker descartáveis. Não há política de backup para `dev`.

## STG/PRD

Itens mínimos a proteger:

```text
- PostgreSQL
- MinIO/S3
- arquivos .env e secrets em cofre
- artefatos de deploy
```

Política inicial recomendada:

```text
- backup diário
- retenção mínima de 7 dias em STG
- retenção institucional a definir para PRD
- restore testado antes de go-live
```
