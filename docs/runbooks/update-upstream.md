# Atualização Upstream

Use este runbook para sincronizar o código em `plane/` com uma nova tag do upstream
`makeplane/plane`.

## Pré-condições

- Working tree limpo.
- Backup ou tag interna da versão atual, se houver ambiente compartilhado.
- Leitura das release notes do Plane.
- Revisão de migrations, Dockerfiles, compose, variáveis de ambiente e segurança.

## Remoto

Configurar uma vez:

```bash
git remote add upstream-plane https://github.com/makeplane/plane.git
git remote set-url --push upstream-plane DISABLED
```

Atualizar refs:

```bash
git fetch upstream-plane --tags
```

## Sync

Criar branch:

```bash
git switch -c upstream-sync/vX.Y.Z
```

Aplicar upstream:

```bash
git subtree pull --prefix=plane upstream-plane vX.Y.Z --squash
```

Resolver conflitos preservando customizações ARTESP mínimas.

## Checklist

```text
[ ] Release notes revisadas
[ ] Migrations identificadas
[ ] Variáveis novas/removidas refletidas nos templates locais
[ ] Docker Compose local validado
[ ] Smoke test passou
[ ] VERSION.md atualizado
[ ] CHANGELOG.md atualizado
[ ] ROLLBACK.md revisado
[ ] COMPLIANCE.md continua válido
```

## Validação

```bash
make dev-setup
make dev-up
make smoke
```

## Merge

Abrir PR com resumo de:

```text
- tag anterior
- tag nova
- conflitos resolvidos
- migrations
- mudanças operacionais
- resultado dos testes
- plano de rollback
```
