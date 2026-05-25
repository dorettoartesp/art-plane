---
name: plane-artesp
description: Orienta avaliacao, implantacao, operacao e evolucao do Plane CE para ARTESP em self-hosting com Docker Compose ou VMs, incluindo decisao de fork minimo, conformidade AGPL v3, sincronizacao com upstream, CI/CD, backup, restore, observabilidade, seguranca, LGPD, SSO/OIDC, auditoria, workflows e portal externo. Use quando a tarefa envolver Plane CE, fork plane-artesp, instalacao self-hosted, operacao institucional, atualizacoes upstream ou arquitetura de exposicao externa.
metadata:
  source: "Consolidated from .agents/skills/plane-artesp and .agents/skills/plane-artesp-dev"
---

# Plane ARTESP

Use esta skill para orientar trabalho tecnico no Plane CE da ARTESP. Trate o Plane como ferramenta de gestao de trabalho, backlog, tarefas, acompanhamento e documentacao operacional, nao como sistema regulatorio completo, protocolo oficial, sistema documental administrativo, motor formal de aprovacao ou portal publico principal.

## Procedimento

1. Identifique a versao-alvo do Plane CE antes de recomendar comandos, caminhos, servicos ou arquitetura.
2. Consulte fontes oficiais atuais antes de tomar decisoes tecnicas:
   - https://github.com/makeplane/plane
   - https://github.com/makeplane/plane/releases
   - https://plane.so/open-source
   - https://developers.plane.so/self-hosting/self-hosting-101
   - https://developers.plane.so/self-hosting/methods/docker-compose
   - https://developers.plane.so/self-hosting/methods/kubernetes
   - https://developers.plane.so/api-reference
   - https://www.gnu.org/licenses/agpl-3.0.html
3. Valide a estrutura real da versao-alvo. Nao presuma layouts antigos como `apiserver/`, `web/`, Next.js ou Yarn.
4. Comece por instalacao pura do Plane CE em staging. Crie fork apenas quando houver modificacao de codigo indispensavel.
5. Prefira configuracao nativa, composicao externa, API ou webhooks antes de patch no core.
6. Se houver fork modificado acessado por rede, garanta conformidade AGPL v3 e oferta clara do codigo-fonte correspondente.
7. Para publico, concessionarias ou orgaos externos, projete portal ou camada de integracao separada. Nao exponha o Plane diretamente ao publico geral.
8. Antes de producao, exija DNS, TLS, SMTP, backups, restore testado, observabilidade, alertas, secrets fora do Git, rollback documentado e avaliacao LGPD.

## Referencia Completa

Leia `references/plane-artesp-reference.md` quando a tarefa exigir detalhes de:

- stack real do Plane CE e inspecao de upstream;
- fases de implantacao e criterios de go-live;
- AGPL v3, arquivos de conformidade e aviso de codigo-fonte;
- estrategia de fork, branches, PRs e sincronizacao com upstream;
- variaveis de ambiente, secrets e hardening;
- SSO/OIDC, auditoria, workflows e features comerciais;
- portal externo, LGPD, webhooks e protecao contra SSRF;
- backup, restore, observabilidade, CI/CD, Ansible, rollback e runbooks.

## Regras De Decisao

- Use Docker Compose em VMs como caminho inicial recomendado.
- Adote Kubernetes somente com equipe capacitada, cluster maduro, storage persistente confiavel, ingress/TLS, backup, observabilidade e justificativa real de alta disponibilidade.
- Nao versionar `.env` real, secrets, dumps, anexos, dados pessoais, certificados privados ou configuracoes internas sensiveis.
- Registrar a versao-alvo em `VERSION.md`.
- Criar `COMPLIANCE.md` se houver codigo derivado modificado.
- Manter textos visiveis ao usuario em portugues brasileiro formal.
- Manter codigo, identificadores, variaveis, comentarios tecnicos e nomes de arquivos em ingles.

## Saida Esperada

Ao responder tarefas desta skill, produza recomendacoes objetivas com:

- decisao tecnica recomendada;
- pre-condicoes e fontes a validar;
- impacto em fork, AGPL, seguranca, operacao e LGPD;
- passos de implementacao ou operacao;
- verificacoes, smoke tests e rollback quando aplicavel.
