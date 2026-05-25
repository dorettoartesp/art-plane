---
name: plane-artesp
description: Orienta avaliacao, implantacao, operacao e evolucao do Plane CE para ARTESP em monorepo institucional, com codigo do Plane em plane/, ambiente dev local reproduzivel em qualquer PC que clone o repositorio, e ambientes stg/prd self-hosted em VMs quando provisionados. Inclui conformidade AGPL v3, sincronizacao com upstream via subtree/remoto upstream-plane, CI/CD, backup, restore, observabilidade, seguranca, LGPD, SSO/OIDC, auditoria, workflows e portal externo. Use quando a tarefa envolver Plane CE, fork institucional, dev local, instalacao self-hosted, operacao institucional, atualizacoes upstream ou arquitetura de exposicao externa.
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
4. Comece por ambiente `dev` local reproduzivel em qualquer PC que clone este repositorio, usando o codigo do Plane em `plane/` e Docker Compose local.
5. Use `stg` e `prd` como ambientes self-hosted em VMs separadas quando elas forem provisionadas. Nao presuma que essas VMs ja existem.
6. Crie fork apenas quando houver modificacao de codigo indispensavel.
7. Prefira configuracao nativa, composicao externa, API ou webhooks antes de patch no core.
8. Se houver fork modificado acessado por rede, garanta conformidade AGPL v3 e oferta clara do codigo-fonte correspondente.
9. Para publico, concessionarias ou orgaos externos, projete portal ou camada de integracao separada. Nao exponha o Plane diretamente ao publico geral.
10. Antes de producao, exija DNS, TLS, SMTP, backups, restore testado, observabilidade, alertas, secrets fora do Git, rollback documentado e avaliacao LGPD.

## Referencia Completa

Leia `references/plane-artesp-reference.md` quando a tarefa exigir detalhes de:

- stack real do Plane CE e inspecao de upstream;
- ambientes dev/stg/prd, fases de implantacao e criterios de go-live;
- AGPL v3, arquivos de conformidade e aviso de codigo-fonte;
- estrutura de monorepo, branches, PRs e sincronizacao com upstream;
- variaveis de ambiente, secrets e hardening;
- SSO/OIDC, auditoria, workflows e features comerciais;
- portal externo, LGPD, webhooks e protecao contra SSRF;
- backup, restore, observabilidade, CI/CD, Ansible, rollback e runbooks.

## Regras De Decisao

- Use Docker Compose local como caminho obrigatorio para `dev`, para que qualquer pessoa consiga clonar o repositorio e executar a versao de desenvolvimento.
- Use Docker Compose em VMs como caminho recomendado para `stg` e `prd` quando as VMs forem provisionadas.
- Mantenha o codigo do Plane como diretorio normal em `plane/`, versionado no proprio monorepo. Nao use submodule para o Plane.
- Use o remoto `upstream-plane` e `git subtree` para importar ou atualizar o codigo a partir de `makeplane/plane`.
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
