# Incidente de Segurança

## Primeira Resposta

```text
1. Preservar evidências.
2. Identificar ambiente afetado: dev, stg ou prd.
3. Revogar tokens/secrets suspeitos.
4. Isolar exposição externa, se aplicável.
5. Registrar linha do tempo.
6. Avaliar impacto LGPD.
```

## Dados Que Não Devem Ser Publicados

```text
- .env reais
- tokens
- chaves privadas
- dumps
- anexos
- dados pessoais
- endereços internos sensíveis
```

## Pós-Incidente

```text
[ ] causa raiz registrada
[ ] secrets rotacionados
[ ] patch aplicado
[ ] logs preservados
[ ] comunicação institucional definida
[ ] runbook atualizado
```
