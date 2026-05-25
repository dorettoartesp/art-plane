# Deploy STG/PRD

STG e PRD ainda dependem de VMs provisionadas. Até lá, este runbook é um placeholder
operacional e não deve conter hosts, DNS, SSH keys ou secrets reais.

## Pré-condições Futuras

```text
[ ] VM de STG provisionada
[ ] VM de PRD provisionada
[ ] DNS definido
[ ] TLS definido
[ ] estratégia de secrets definida
[ ] backup e restore definidos
[ ] observabilidade mínima definida
[ ] rollback documentado
```

## Regra

Nenhum deploy em PRD deve ocorrer sem:

```text
- smoke test em STG
- backup pré-deploy
- plano de rollback
- janela aprovada, se houver migration ou indisponibilidade
```
