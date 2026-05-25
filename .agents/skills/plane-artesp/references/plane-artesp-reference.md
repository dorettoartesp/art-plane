# Skill — Plane CE ARTESP: desenvolvimento, self-hosting, fork AGPL e operação em VMs

---

## 1. Finalidade da skill

Esta skill orienta a avaliação, implantação, customização mínima, operação e evolução de um
fork institucional do **Plane CE** para uso na ARTESP, em ambiente **self-hosted** hospedado
em VMs próprias ou sob governança da ARTESP.

**CE** significa *Community Edition*, a edição comunitária do Plane.
**VM** significa *Virtual Machine*, máquina virtual.
**AGPL v3** significa *GNU Affero General Public License versão 3*, licença livre copyleft
que exige disponibilização do código-fonte correspondente quando uma versão modificada do
software é usada por terceiros via rede.

A skill deve ser usada para:

- instalar e operar o Plane CE em ambiente institucional;
- decidir quando criar fork e quando manter instalação pura;
- manter conformidade com a AGPL v3;
- evitar customizações frágeis contra o upstream;
- estruturar CI/CD, backup, observabilidade e segurança;
- orientar a criação de portal externo separado, quando houver exposição a concessionárias,
  órgãos externos ou público.

Esta skill **não** deve ser usada para transformar o Plane em sistema regulatório completo,
sistema oficial de protocolo, sistema de documentos administrativos, sistema de aprovação
formal ou portal público principal da ARTESP.

---

## 2. Princípio central

O Plane deve ser tratado como **ferramenta de gestão de trabalho, backlog, tarefas,
acompanhamento e documentação operacional**, e não como sistema-mãe institucional.

A regra arquitetural é:

```text
Plane interno ou restrito
  → API controlada
  → camada externa de publicação, integração ou consulta
  → concessionárias, órgãos externos ou público
```

Nunca presumir que o Plane, por si só, possui modelo adequado para exposição pública irrestrita.

---

## 3. Premissas institucionais

1. A ARTESP poderá utilizar o Plane CE em ambiente self-hosted.
2. Caso haja modificação do código do Plane, o fork modificado deverá permanecer sob AGPL v3.
3. Se usuários acessarem a versão modificada via rede, deverá haver oferta clara do
   código-fonte correspondente.
4. Segredos, chaves, tokens, variáveis de ambiente, dumps de banco, anexos, dados pessoais e
   configurações internas sensíveis não devem ser publicados.
5. O fork deve ser mínimo, rastreável e tecnicamente justificável.
6. O ambiente `dev` deve rodar localmente em qualquer PC que clone este repositório, usando
   Docker Compose e o submodule `src`.
7. Os ambientes `stg` e `prd` devem rodar em VMs self-hosted quando forem provisionadas.
8. Kubernetes só deve ser adotado depois de validação operacional, equipe capacitada e
   necessidade real de alta disponibilidade.
9. O Plane não deve ser exposto diretamente ao público geral.
10. Concessionárias e usuários externos devem acessar, preferencialmente, portal ou camada
   de integração separada.
11. Backups, restauração testada, observabilidade e segurança são requisitos de produção,
    não melhorias opcionais.

---

## 4. Glossário

| Termo | Significado | Uso nesta skill |
|---|---|---|
| Plane CE | Plane Community Edition | Edição comunitária e self-hosted do Plane. |
| AGPL v3 | GNU Affero General Public License versão 3 | Licença que rege o Plane CE. |
| Fork | Cópia derivada de um repositório original | Repositório ARTESP com modificações próprias. |
| Upstream | Repositório original do projeto | Repositório oficial `makeplane/plane`. |
| Downstream | Repositório derivado | Fork `artesp/plane-artesp`. |
| Self-hosted | Hospedado pela própria organização | Execução em VMs sob controle da ARTESP. |
| DEV | Development | Ambiente local reproduzível em qualquer PC que clone este repositório. |
| SSO | Single Sign-On | Login único por provedor de identidade. |
| OIDC | OpenID Connect | Protocolo de autenticação baseado em OAuth 2.0. |
| IdP | Identity Provider | Provedor de identidade, como Keycloak. |
| CI/CD | Continuous Integration / Continuous Delivery | Esteira de integração, teste, build e entrega. |
| STG | Staging | Ambiente de homologação. |
| PRD | Production | Ambiente de produção. |
| TLS | Transport Layer Security | Criptografia de tráfego HTTPS. |
| DNS | Domain Name System | Sistema de nomes de domínio. |
| SMTP | Simple Mail Transfer Protocol | Protocolo para envio de e-mails. |
| RBAC | Role-Based Access Control | Controle de acesso baseado em papéis. |
| PITR | Point-in-Time Recovery | Recuperação do banco até um ponto específico no tempo. |
| RPO | Recovery Point Objective | Perda máxima aceitável de dados. |
| RTO | Recovery Time Objective | Tempo máximo aceitável de recuperação. |
| WAL | Write-Ahead Log | Registro de transações do PostgreSQL para recuperação. |
| SSRF | Server-Side Request Forgery | Ataque em que o servidor é induzido a acessar endereços indevidos. |
| IDOR | Insecure Direct Object Reference | Falha de autorização por referência direta indevida a objetos. |
| GHSA | GitHub Security Advisory | Aviso de segurança publicado no GitHub. |
| LGPD | Lei Geral de Proteção de Dados Pessoais | Lei Federal nº 13.709/2018. |
| Runbook | Roteiro operacional passo a passo | Documento para execução repetível de tarefas técnicas. |
| Break-glass | Conta administrativa de emergência | Usada apenas quando o IdP está indisponível. |
| Smoke test | Teste rápido de funcionamento essencial | Confirma que a aplicação subiu e executa funções básicas. |

---

## 5. Fontes oficiais — sempre consultar antes de decidir

```text
https://github.com/makeplane/plane
https://github.com/makeplane/plane/releases
https://plane.so/open-source
https://developers.plane.so/self-hosting/self-hosting-101
https://developers.plane.so/self-hosting/methods/docker-compose
https://developers.plane.so/self-hosting/methods/kubernetes
https://developers.plane.so/api-reference
https://www.gnu.org/licenses/agpl-3.0.html
https://deepwiki.com/makeplane/plane
```

Regra: **não confiar em caminhos, frameworks, nomes de serviços ou comandos de versões
anteriores sem validar contra a versão-alvo do upstream.**

---

## 6. Versão-alvo e congelamento técnico

Antes de iniciar implantação, escolher uma versão-alvo do Plane CE e registrá-la em:

```text
VERSION.md
```

Conteúdo mínimo:

```markdown
# Plane ARTESP — versão-alvo

- Upstream: makeplane/plane
- Tag upstream validada: vX.Y.Z
- Data de validação: DD/MM/AAAA
- Responsável técnico: <nome>
- Tipo de implantação: DEV local com Docker Compose; STG/PRD em VMs quando provisionadas
- Customizações ativas: nenhuma / lista
- Última sincronização upstream: DD/MM/AAAA
- Observações de segurança: <resumo>
```

---

## 7. Stack real do Plane CE (v1.3.x)

O Plane roda como **13 containers**. Não confundir com versões anteriores que tinham
estrutura diferente (ex: Next.js, `apiserver/`, `web/`).

```
Serviços de aplicação:
  plane-web      → frontend (React Router + Vite — NÃO é Next.js)
  plane-admin    → painel administrativo (React Router + Vite)
  plane-space    → portal de acesso externo / public boards
  plane-live     → colaboração em tempo real (WebSocket/Node.js)
  plane-api      → Django 4.2 + DRF (backend REST)
  plane-worker   → Celery (tarefas assíncronas)
  plane-beat     → Celery Beat (tarefas agendadas)
  plane-migrator → roda migrations e sai (não fica em pé)

Proxy:
  plane-proxy    → Caddy (roteamento por path para os serviços acima)

Infra:
  PostgreSQL 15
  Valkey 7.2     → compatível com Redis; substitui Redis no CE atual
  RabbitMQ 3.13
  MinIO          → object storage S3-compatible (uploads, anexos)

Requisito mínimo de RAM: 8 GB (13 serviços — não funciona adequadamente com 4 GB)
```

### Estrutura do monorepo (validar contra versão-alvo)

```
apps/
  web/           → frontend principal (React Router + Vite)
  admin/         → painel admin
  space/         → portal externo
  api/           → Django backend
  live/          → servidor de colaboração realtime

packages/        → código compartilhado (design system, types, editor, i18n)

deployments/
  cli/community/ → install.sh, docker-compose.yml oficiais

docker-compose.yml          → compose principal
docker-compose-local.yml    → compose para desenvolvimento local
setup.sh                    → script oficial de configuração do .env
.env.example                → template de variáveis
```

---

## 8. Script de inspeção da estrutura do upstream

Rodar após cada atualização de versão para descobrir a estrutura real:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf "Repository root: %s\n" "$(pwd)"

printf "\nTop-level files and directories:\n"
find . -maxdepth 2 -type f \
  \( -name "Dockerfile" \
  -o -name "docker-compose*.yml" \
  -o -name "package.json" \
  -o -name "pnpm-lock.yaml" \
  -o -name "yarn.lock" \
  -o -name "requirements*.txt" \
  -o -name "pyproject.toml" \
  -o -name "manage.py" \) \
  | sort

printf "\nPython/Django hints:\n"
find . -maxdepth 4 -type f \( -name "manage.py" -o -name "settings.py" \) | sort || true

printf "\nFrontend hints:\n"
find . -maxdepth 4 -type f \( -name "vite.config.*" -o -name "next.config.*" \) | sort || true

printf "\nCompose files:\n"
find . -maxdepth 4 -type f \( -name "docker-compose*.yml" -o -name "compose*.yml" \) \
  | sort || true
```

Salvar como `scripts/inspect_upstream_layout.sh`. Executar e salvar saída:

```bash
bash scripts/inspect_upstream_layout.sh > docs/upstream-layout-$(date +%Y%m%d).txt
```

---

## 9. Estratégia de ambientes e implantação

### 9.1 DEV local: obrigatório e reproduzível

O ambiente `dev` deve ser o primeiro alvo operacional. Ele deve rodar em qualquer PC que
clone este repositório, sem depender de VMs institucionais ainda não provisionadas.

Requisitos de `dev`:

```text
- clonar este repositório com submodules;
- inicializar o submodule src;
- usar Docker Compose local do Plane CE ou compose wrapper do repositório raiz;
- usar .env local derivado de .env.example, sem secrets reais;
- permitir build, subida, smoke test e parada do ambiente;
- documentar comandos em README.md e docs/runbooks/install.md.
```

Comando esperado para novos clones:

```bash
git clone --recurse-submodules <URL_DO_REPOSITORIO> art-plane
cd art-plane
git submodule update --init --recursive
```

Se o clone já foi feito sem submodules:

```bash
git submodule update --init --recursive
```

### 9.2 STG e PRD: Docker Compose em VMs (quando provisionadas)

Topologia mínima recomendada para homologação e produção institucional:

```text
[Usuários internos / Rede ARTESP]
        |
        | HTTPS / TLS
        v
[Reverse proxy externo / TLS / WAF]
        |
        v
[VM App — plane-artesp-app]
  plane-web, plane-admin, plane-space
  plane-live, plane-api
  plane-worker, plane-beat, plane-migrator
  plane-proxy (Caddy interno)
        |
        v
[VM Dados — plane-artesp-data]
  PostgreSQL 15
  Valkey 7.2
  RabbitMQ 3.13
  MinIO
        |
        v
[Backup externo]
  backups PostgreSQL (pg_dump / pgBackRest)
  backups MinIO (rclone)
  cópia criptografada de .env e configurações
```

Em piloto ou prova de conceito, todos os serviços podem rodar em uma VM.
Para produção institucional, separar aplicação, dados e backup.

As VMs de `stg` e `prd` podem ainda não existir. Enquanto não forem provisionadas, não
escrever automações que dependam de hosts, DNS, SSH ou secrets reais. Usar placeholders
documentados e manter deploy de VM como etapa futura.

### 9.3 Fase posterior: Kubernetes

Kubernetes só deve ser adotado quando houver:

- equipe com experiência operacional real;
- cluster com pelo menos 3 nós para produção;
- storage persistente confiável (Longhorn, Ceph ou corporativo);
- ingress controller com TLS automatizado;
- backup de volumes persistentes;
- monitoramento do cluster;
- política de atualização do cluster;
- justificativa de alta disponibilidade.

**Kubernetes não deve ser adotado apenas por sofisticação técnica.**

---

## 10. Escopo por fases

### Fase 0 — DEV local e validação (obrigatória antes de STG/PRD)

Objetivo: verificar se o Plane CE atende minimamente ao uso pretendido sem customização.

Entregas:

- instalação limpa do Plane CE em ambiente `dev` local reproduzível;
- instruções para qualquer pessoa clonar o repositório e subir o ambiente local;
- verificação de features disponíveis no CE da versão escolhida;
- teste de usuários, workspaces, projetos, tarefas, módulos, ciclos, páginas, anexos,
  API e webhooks;
- relatório de limitações e features bloqueadas;
- decisão documentada sobre necessidade real de fork.

Critério de saída:

```text
Plane CE puro validado ou rejeitado com justificativa técnica.
```

### Fase 1 — Self-hosting institucional

Objetivo: tornar a implantação operável em VM da ARTESP.

Entregas: DNS, HTTPS/TLS, SMTP, backup e restore testados, logs centralizados,
monitoramento básico, hardening de variáveis de ambiente, política de atualização,
staging e produção separados.

Pré-condição: VMs de `stg` e/ou `prd` provisionadas. Antes disso, manter esta fase como
planejamento, documentação e scripts parametrizados.

Critério de saída:

```text
Ambiente estável, recuperável, monitorado e documentado.
```

### Fase 2 — Fork mínimo ARTESP

Customizações aceitáveis nesta fase:

- branding leve;
- textos visíveis ao usuário em português;
- link visível para código-fonte AGPL;
- ajustes de configuração institucional;
- scripts de deploy e operação;
- documentação específica ARTESP;
- integrações externas de baixo acoplamento.

Customizações a evitar nesta fase:

- reescrever autenticação;
- alterar modelo central de permissões;
- alterar modelo principal de issues/work items;
- implementar workflows complexos dentro do Plane;
- implementar auditoria regulatória completa dentro do Plane;
- expor Plane diretamente ao público.

### Fase 3 — Integrações controladas

Portal externo, integração com API/webhooks, exportação de relatórios,
integração com GitHub/GitLab/Gitea. Sem alterar o core.

### Fase 4 — Funcionalidades avançadas

SSO/OIDC, auditoria robusta e workflows — cada um como projeto separado com
análise própria de risco, esforço, manutenção e impacto no upstream.

---

## 11. Conformidade AGPL v3

### 11.1 Regra básica

Se a ARTESP modificar o Plane e disponibilizar essa versão via rede, os usuários
devem ter acesso ao código-fonte correspondente.

### 11.2 O que publicar

```text
- código-fonte modificado com histórico de commits;
- Dockerfiles usados para build;
- scripts de build e deploy genéricos;
- patches próprios;
- documentação de instalação;
- licença AGPL v3;
- avisos de copyright preservados;
- CHANGELOG ARTESP;
- instruções para obter a versão correspondente em produção.
```

### 11.3 O que nunca publicar

```text
- .env real;
- secrets, senhas, tokens, chaves privadas, certificados privados;
- dumps de banco;
- anexos de usuários;
- dados pessoais;
- dados operacionais sensíveis;
- endereços internos sensíveis;
- inventários com IPs privados.
```

### 11.4 Aviso visível no sistema

Incluir no rodapé ou tela "Sobre":

```text
Este sistema utiliza uma versão modificada do Plane CE, licenciado sob AGPL v3.
O código-fonte correspondente está disponível em: <URL_DO_REPOSITORIO_PUBLICO>.
```

### 11.5 Criar arquivo COMPLIANCE.md

```markdown
# Conformidade AGPL v3 — Plane ARTESP

## Origem

Este projeto deriva do Plane CE:
https://github.com/makeplane/plane

## Licença

O código derivado permanece sob GNU Affero General Public License v3.

## Código-fonte correspondente

https://github.com/artesp/plane-artesp

## Itens excluídos da publicação

Segredos, variáveis de ambiente reais, dados pessoais, anexos,
dumps de banco, certificados privados, configurações internas sensíveis.

## Alterações ARTESP

Consultar CHANGELOG.md.
```

---

## 12. Estratégia de fork

### 12.1 Critérios para criar fork

Criar fork somente se pelo menos uma condição for verdadeira:

```text
- há modificação de código indispensável;
- branding institucional não pode ser feito por configuração;
- tradução/texto precisa ser alterado no código;
- link AGPL precisa ser inserido na interface;
- integração externa exige pequena adaptação no core;
- correção emergencial ainda não incorporada pelo upstream.
```

Não criar fork apenas para: instalar em VM, configurar domínio/SMTP/banco,
criar backup, criar observabilidade, criar portal externo ou escrever documentação.

### 12.2 Setup do repositório

```bash
git clone https://github.com/makeplane/plane.git plane-artesp --branch vX.Y.Z --depth 1
cd plane-artesp

git remote rename origin upstream
git remote add origin git@github.com:artesp/plane-artesp.git

git fetch upstream --tags
git checkout -b main vX.Y.Z
git push -u origin main

echo "vX.Y.Z" > VERSION.md
git add VERSION.md
git commit -m "chore: set upstream base version vX.Y.Z"
```

### 12.3 Branches

```text
main              → produção estável
release/*         → candidata a produção
staging           → estado implantado em homologação
develop           → integração de mudanças aprovadas
feature/*         → feature específica
fix/*             → correção específica
security/*        → correções emergenciais de segurança
upstream-sync/*   → sincronização temporária com upstream
```

### 12.4 Regras

1. Nunca desenvolver diretamente em `main`.
2. Toda mudança deve passar por Pull Request.
3. Customizações devem ser pequenas e isoladas.
4. Evitar alterar arquivos muito ativos no upstream.
5. Preferir configuração, composição ou extensão externa antes de alterar o core.
6. Nunca editar migration já aplicada em ambiente compartilhado.
7. Nunca versionar segredos.

### 12.5 Conventional Commits

```text
feat: add public source link to about page
fix: restrict webhook private network access
chore: update upstream to vX.Y.Z
docs: add AGPL compliance guide
security: harden object storage configuration
```

### 12.6 Template de Pull Request

```markdown
## Objetivo

Descrever a mudança.

## Tipo

- [ ] Correção
- [ ] Feature
- [ ] Segurança
- [ ] Documentação
- [ ] Deploy/infra
- [ ] Sincronização upstream

## Impacto AGPL

- [ ] Não altera código derivado
- [ ] Altera código derivado e exige publicação
- [ ] Atualiza documentação de conformidade

## Impacto operacional

- [ ] Requer migration
- [ ] Requer alteração de variável de ambiente
- [ ] Requer restart
- [ ] Requer janela de manutenção
- [ ] Requer backup prévio

## Testes

- [ ] Testes automatizados
- [ ] Smoke test local
- [ ] Smoke test staging
- [ ] Teste de rollback

## Segurança

- [ ] Sem novo segredo versionado
- [ ] Sem endpoint público indevido
- [ ] Permissões revisadas
- [ ] Upload/anexo revisado, se aplicável
```

---

## 13. Sincronização com upstream

### 13.1 Rotina mensal

```bash
git fetch upstream --tags
git checkout -b upstream-sync/$(date +%Y%m%d)
git log --oneline --decorate --max-count=30 upstream/main
git diff --stat main..upstream/main
```

### 13.2 Checklist antes de merge

```text
- changelog oficial;
- releases com correções de segurança e GHSAs;
- breaking changes;
- mudanças em Docker/Compose/Helm;
- mudanças em migrations;
- mudanças na autenticação;
- mudanças em storage/anexos;
- mudanças em API e webhooks;
- mudanças em permissões e frontend;
- mudanças em variáveis de ambiente;
- features bloqueadas que foram liberadas para o CE (pode eliminar código customizado).
```

### 13.3 Critério de merge para produção

```text
- staging atualizado com sucesso;
- migrations testadas;
- backup pré-migração concluído;
- smoke tests aprovados;
- rollback documentado;
- changelog interno atualizado;
- janela de manutenção aprovada, se necessário.
```

---

## 14. Convenções obrigatórias

- Código, identificadores, variáveis, comentários técnicos e nomes de arquivos: **inglês**.
- Textos visíveis ao usuário: **português brasileiro formal**.
- Logs técnicos: inglês, desde que consistentes.
- Documentação institucional: português.

---

## 15. Política de customização

### 15.1 Ordem de preferência

```text
1. Configuração nativa.
2. Composição externa.
3. Integração via API.
4. Integração via webhook.
5. Extensão isolada.
6. Patch pequeno no fork.
7. Alteração profunda no core — evitar.
```

### 15.2 Regra de manutenção

Toda customização deve responder:

```text
- Qual problema resolve?
- Por que não pode ser configuração?
- Por que não pode ser portal externo?
- Quais arquivos altera?
- O upstream altera esses arquivos com frequência?
- Como será testada?
- Como será removida se o upstream liberar feature equivalente?
- Qual impacto AGPL?
```

---

## 16. Variáveis de ambiente

### 16.1 Regras

1. Manter `.env.example` público e sanitizado.
2. Manter `.env` real fora do Git.
3. Em produção, usar arquivo protegido, Vault ou secret manager institucional.
4. Rotacionar senhas e tokens periodicamente.
5. Não colocar secrets no Ansible inventory em texto claro — usar Ansible Vault.
6. Não imprimir secrets em logs de CI/CD.

### 16.2 .env.example

```bash
# Application
APP_DOMAIN=plane.artesp.sp.gov.br
APP_PROTOCOL=https
DEBUG=0

# Security
SECRET_KEY=<gerar com: openssl rand -hex 50>
ALLOWED_HOSTS=plane.artesp.sp.gov.br

# Database
DATABASE_URL=postgresql://plane:<password>@postgres:5432/plane

# Cache / queue
REDIS_URL=redis://valkey:6379/0
RABBITMQ_URL=amqp://plane:<password>@rabbitmq:5672/

# Object storage
AWS_ACCESS_KEY_ID=<access-key>
AWS_SECRET_ACCESS_KEY=<secret-key>
AWS_S3_ENDPOINT_URL=https://minio.artesp.sp.gov.br
AWS_STORAGE_BUCKET_NAME=plane-artesp

# Email / SMTP
EMAIL_HOST=smtp.artesp.sp.gov.br
EMAIL_PORT=587
EMAIL_HOST_USER=<user>
EMAIL_HOST_PASSWORD=<password>
DEFAULT_FROM_EMAIL=no-reply@artesp.sp.gov.br

# Webhooks
WEBHOOK_ALLOWED_IPS=

# OIDC (fase 4 — não configurar antes)
OIDC_CLIENT_ID=
OIDC_CLIENT_SECRET=
OIDC_OP_AUTHORIZATION_ENDPOINT=
OIDC_OP_TOKEN_ENDPOINT=
OIDC_OP_USER_ENDPOINT=
OIDC_OP_JWKS_ENDPOINT=

# Source code notice
SOURCE_CODE_URL=https://github.com/artesp/plane-artesp
```

A lista real de variáveis deve ser extraída do `.env.example` da versão-alvo.

---

## 17. Features comerciais — avaliação e estratégia

Validar disponibilidade no CE contra a página oficial antes de qualquer desenvolvimento.

| Feature | Ação recomendada | Esforço real | Observação |
|---|---|---|---|
| SSO/OIDC | Projeto separado (Fase 4) | Médio a Alto | Alto impacto de segurança — não tratar como baixo esforço. |
| Audit trails | Projeto próprio | Alto | Signals Django são insuficientes para auditoria regulatória. |
| Workflows/aprovações | Camada externa | Alto | Evitar transformar o Plane em motor de workflow. |
| Epics | Verificar versão/edição | Baixo/Nulo se no CE | Não presumir disponibilidade — testar na instância instalada. |
| Integrações avançadas | API e webhooks | Baixo | Evitar alteração do core. |

---

## 18. Autenticação, SSO e OIDC

### 18.1 Decisão inicial

Não implementar SSO/OIDC no primeiro ciclo, salvo exigência institucional formal.

### 18.2 Por que não é baixo esforço

SSO/OIDC afeta: criação de usuários, vínculo entre identidade local e externa, login e
logout, expiração de sessão, bloqueio de usuário desligado, mapeamento de grupos,
permissões, logs de autenticação, fallback de login local, riscos de tomada de conta
e suporte operacional.

### 18.3 Estratégia segura (quando necessário)

1. Abrir projeto técnico separado.
2. Validar se o CE possui suporte nativo ou parcial na versão instalada.
3. Avaliar fork comunitário `https://github.com/bitbay/plane-oidc` como referência —
   não copiar cegamente; validar compatibilidade com a versão-alvo.
4. Criar prova de conceito isolada.
5. Testar: login, logout, criação de usuário, bloqueio, grupos, falha do IdP.
6. Documentar rollback para login local administrativo.
7. Manter conta break-glass protegida (administrativa de emergência).

### 18.4 Variáveis OIDC (quando implementado)

```bash
# Nunca hardcoded — sempre via .env
OIDC_CLIENT_ID=plane-artesp
OIDC_CLIENT_SECRET=<secret-do-keycloak>
OIDC_OP_AUTHORIZATION_ENDPOINT=https://keycloak.artesp.sp.gov.br/realms/artesp/protocol/openid-connect/auth
OIDC_OP_TOKEN_ENDPOINT=https://keycloak.artesp.sp.gov.br/realms/artesp/protocol/openid-connect/token
OIDC_OP_USER_ENDPOINT=https://keycloak.artesp.sp.gov.br/realms/artesp/protocol/openid-connect/userinfo
OIDC_OP_JWKS_ENDPOINT=https://keycloak.artesp.sp.gov.br/realms/artesp/protocol/openid-connect/certs
```

---

## 19. Audit logs

### 19.1 Decisão

Não considerar `post_save`/`post_delete` do Django como auditoria institucional suficiente.

### 19.2 Limitações de signals

Signals podem não capturar: bulk updates, operações many-to-many, alterações em workers,
alterações por scripts, deleções em cascata, mudanças fora do ORM, permissões,
login/logout, alterações de tokens, chamadas de API externas.

### 19.3 Auditoria mínima operacional (antes da regulatória)

```text
- logs do proxy reverso;
- logs da API;
- logs de autenticação;
- logs de webhooks e workers;
- logs de erros 4xx/5xx;
- correlação por request_id;
- retenção mínima definida;
- exportação para armazenamento centralizado.
```

### 19.4 Modelo para auditoria robusta (Fase 4)

```python
# apps/api/plane/audit/models.py
class AuditLog(models.Model):
    actor        = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    action       = models.CharField(max_length=50)   # CREATE, UPDATE, DELETE, LOGIN, etc.
    entity_type  = models.CharField(max_length=100)  # Issue, Project, Workspace, etc.
    entity_id    = models.UUIDField(null=True)
    old_value    = models.JSONField(null=True)
    new_value    = models.JSONField(null=True)
    ip_address   = models.GenericIPAddressField(null=True)
    user_agent   = models.TextField(null=True)
    endpoint     = models.TextField(null=True)
    http_method  = models.CharField(max_length=10, null=True)
    request_id   = models.UUIDField(null=True)
    source       = models.CharField(max_length=20)   # UI, API, WORKER, SYSTEM
    workspace    = models.ForeignKey(Workspace, on_delete=models.SET_NULL, null=True)
    created_at   = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "audit_logs"
        indexes  = [
            models.Index(fields=["entity_type", "entity_id"]),
            models.Index(fields=["actor", "created_at"]),
            models.Index(fields=["workspace", "created_at"]),
        ]
        # Logs não devem ser deletáveis via admin padrão.
        # Retenção via política externa, não DELETE.
```

Estratégia: middleware Django para operações via API + signals para operações
assíncronas via worker. Nenhuma das duas sozinha é completa.

---

## 20. Workflows e aprovações

### 20.1 Decisão

Não implementar motor de workflow dentro do Plane CE no início.

### 20.2 Alternativas por maturidade

```text
- status, labels e views do próprio Plane;
- convenções operacionais simples;
- automações externas por API ou webhooks com allowlist;
- sistema institucional específico para aprovações formais;
- ferramenta de workflow separada, quando justificável.
```

### 20.3 Regra institucional

Aprovação formal, ato administrativo, ciência oficial, manifestação jurídica, despacho
ou decisão regulatória não devem depender exclusivamente de workflow customizado informal
dentro do Plane.

---

## 21. Portal público ou externo

### 21.1 Regra

Não expor o Plane diretamente a público geral ou concessionárias como interface principal.

O Plane pode conter comentários internos, dados de servidores, discussões estratégicas,
dados pessoais e informações operacionais. Expô-lo diretamente viola o princípio de
mínima exposição.

### 21.2 Arquitetura recomendada

```text
[Plane interno]
    |
    | API REST / Webhook / Exportação controlada
    v
[Camada de integração]
    |
    v
[Portal externo ARTESP]
    com: autenticação própria, cache, rate limiting,
         filtros de exposição, logs de acesso, branding institucional
    |
    v
[Concessionárias / público / outros órgãos]
```

O `plane-space` (container oficial) já oferece portal de boards públicos.
Avaliar se atende antes de construir aplicação separada.

### 21.3 Usuário de serviço para integração

```text
- criar usuário técnico com permissão mínima (read-only nos projetos públicos);
- gerar API token para esse usuário;
- nunca usar token de usuário humano em integração de sistema;
- rotacionar token periodicamente;
- monitorar e auditar chamadas;
- allowlist de IP quando possível.
```

---

## 22. Segurança mínima de produção

### 22.1 Checklist obrigatório

```text
- HTTPS/TLS obrigatório;
- DEBUG=0;
- SECRET_KEY única por ambiente (openssl rand -hex 50);
- ALLOWED_HOSTS restrito ao domínio real;
- CORS restrito;
- CSRF configurado;
- cookies seguros;
- headers de segurança no proxy;
- rate limiting no proxy;
- SMTP autenticado;
- MinIO console não exposto publicamente;
- buckets privados por padrão;
- webhooks com allowlist e proteção contra SSRF;
- upload com restrição de tamanho e tipo;
- logs de acesso com retenção definida;
- backup criptografado;
- contas administrativas revisadas;
- política de offboarding de usuários;
- secrets fora do Git;
- dependências atualizadas;
- plano de resposta a incidente.
```

### 22.2 Headers recomendados no proxy

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
```

### 22.3 Webhooks — proteção contra SSRF

```text
- bloquear IPs privados por padrão;
- liberar apenas destinos necessários via allowlist explícita;
- validar URL no cadastro e no envio;
- registrar falhas;
- evitar mensagens de erro que revelem rede interna.
```

---

## 23. LGPD e dados pessoais

O Plane pode armazenar nomes, e-mails, comentários, anexos, decisões internas e dados
pessoais acidentais.

Requisitos mínimos:

```text
- definir finalidade de uso;
- restringir acesso por necessidade;
- evitar dados pessoais desnecessários em tarefas;
- orientar usuários sobre anexos;
- definir política de retenção;
- documentar operadores e administradores;
- prever exclusão ou anonimização quando cabível;
- registrar incidentes;
- proteger backups;
- revisar exposição externa periodicamente.
```

---

## 24. Backup e restore

### 24.1 Regra

Nenhum ambiente de produção deve entrar em uso sem backup e restore testados.

### 24.2 Itens a proteger

| Componente | Estratégia | Observação |
|---|---|---|
| PostgreSQL | pg_dump diário + WAL/PITR | Banco é o ativo principal. |
| MinIO/S3 | rclone sync para storage externo | Contém anexos e arquivos. |
| `.env` real | Cópia criptografada (gpg/age) | Sem isso o restore pode falhar. |
| Compose/Ansible | Git | Reprodutibilidade. |
| Imagens Docker | Registry versionado (GHCR) | Permite rollback. |
| Logs | Retenção mínima definida | Auditoria e incidente. |

### 24.3 Política mínima

```text
RPO alvo: até 24h no piloto; menor em produção crítica.
RTO alvo: até 4h no piloto; menor em produção crítica.
Retenção: 7 diários, 4 semanais, 3 mensais.
Teste de restore: mensal em ambiente isolado — backup não testado é hipótese.
```

### 24.4 Backup pré-migration (obrigatório)

```bash
docker exec plane-artesp-postgres-1 \
  pg_dump -U plane plane | \
  gzip > /backup/pre-deploy-$(date +%Y%m%d-%H%M).sql.gz
```

---

## 25. Observabilidade

### 25.1 Primeira camada — sem alterar o código

```yaml
# Adicionar ao docker-compose como serviços extras
services:
  node-exporter:
    image: prom/node-exporter:latest
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  postgres-exporter:
    image: prometheuscommunity/postgres-exporter:latest
    environment:
      DATA_SOURCE_NAME: "postgresql://plane:<password>@postgres:5432/plane?sslmode=disable"

  valkey-exporter:
    image: oliver006/redis_exporter:latest
    environment:
      REDIS_ADDR: "valkey:6379"

  prometheus:
    image: prom/prometheus:latest

  grafana:
    image: grafana/grafana:latest

  loki:
    image: grafana/loki:latest

  alloy:
    image: grafana/alloy:latest

  blackbox-exporter:
    image: prom/blackbox-exporter:latest
```

### 25.2 Alertas mínimos obrigatórios

```text
- disco > 80% (PostgreSQL e MinIO);
- disco > 90%;
- CPU/memória da VM > 85% por 5 min;
- container reiniciando repetidamente;
- PostgreSQL / RabbitMQ / Valkey / MinIO indisponível;
- fila RabbitMQ acumulando;
- erro 5xx acima do threshold;
- certificado TLS expirando em < 30 dias;
- backup não executado;
- restore mensal não testado.
```

### 25.3 Segunda camada — instrumentação Django (Fase 2+)

Após estabilização do fork, adicionar `django-prometheus` e OpenTelemetry.
Não instrumentar antes de estabilizar a implantação base.

---

## 26. CI/CD

### 26.1 Ambientes e triggers

| Ambiente | Infra | Trigger | Aprovação |
|---|---|---|---|
| `dev` | Local em qualquer PC com clone do repo (Docker Compose) | Manual / push em qualquer branch | Sem VM |
| `stg` | VM ARTESP, quando provisionada | Push em `develop` | Automático ou manual controlado |
| `prd` | VM ARTESP, quando provisionada | Push em `main` | Manual no GitHub com aprovação |

### 26.2 Estrutura de arquivos

```
.github/
  workflows/
    ci.yml           → lint, testes, build, scan de secrets
    deploy-stg.yml   → deploy automático em stg
    deploy-prd.yml   → deploy manual aprovado em prd

ansible/
  inventory/
    stg.ini
    prd.ini
  group_vars/
    stg.yml
    prd.yml
  templates/
    env.j2
  playbooks/
    deploy.yml
    backup.yml
    restore-test.yml
    rollback.yml

deploy/
  docker-compose.yml
  docker-compose.stg.yml
  docker-compose.prd.yml
  .env.example

scripts/
  inspect_upstream_layout.sh
```

### 26.3 GitHub Secrets necessários

```
STG_SSH_HOST, STG_SSH_USER, STG_SSH_PRIVATE_KEY
PRD_SSH_HOST, PRD_SSH_USER, PRD_SSH_PRIVATE_KEY
GHCR_TOKEN                  → GitHub PAT com escopo packages:write
ANSIBLE_VAULT_PASSWORD
STG_SECRET_KEY, STG_DATABASE_URL, STG_OIDC_CLIENT_SECRET, ...
PRD_SECRET_KEY, PRD_DATABASE_URL, PRD_OIDC_CLIENT_SECRET, ...
```

### 26.4 ci.yml — lint, testes e build

```yaml
name: CI

on:
  push:
    branches: ["**"]
  pull_request:
    branches: [develop, main]

jobs:
  lint-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - name: Install and lint
        working-directory: apps/api    # validar path contra versão-alvo
        run: |
          pip install ruff mypy -r requirements/dev.txt
          ruff check .
          mypy plane/ --ignore-missing-imports

  lint-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
      - name: Install and lint
        # Verificar package manager real da versão-alvo (pnpm ou yarn)
        run: |
          corepack enable
          pnpm install --frozen-lockfile
          pnpm lint

  secret-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  test-backend:
    runs-on: ubuntu-latest
    needs: lint-backend
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: plane_test
          POSTGRES_USER: plane
          POSTGRES_PASSWORD: plane
        options: >-
          --health-cmd pg_isready --health-interval 5s
          --health-timeout 5s --health-retries 5
      valkey:
        image: valkey/valkey:7.2-alpine
        options: >-
          --health-cmd "redis-cli ping" --health-interval 5s
          --health-timeout 5s --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - working-directory: apps/api
        run: pip install -r requirements/dev.txt
      - name: Migrate and test
        working-directory: apps/api
        env:
          DATABASE_URL: postgresql://plane:plane@localhost:5432/plane_test
          REDIS_URL: redis://localhost:6379/0
          SECRET_KEY: ci-only-not-for-production
          DEBUG: "1"
        run: |
          python manage.py migrate --noinput
          python manage.py test --parallel

  build:
    runs-on: ubuntu-latest
    needs: [lint-frontend, test-backend, secret-scan]
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    permissions:
      packages: write
    outputs:
      image_tag: ${{ steps.tag.outputs.tag }}
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GHCR_TOKEN }}
      - name: Set image tag
        id: tag
        run: |
          SHORT_SHA=$(echo ${{ github.sha }} | cut -c1-7)
          BRANCH=$(echo ${{ github.ref_name }} | sed 's/\//-/g')
          echo "tag=${BRANCH}-${SHORT_SHA}" >> $GITHUB_OUTPUT
      # ATENÇÃO: context e dockerfile devem ser validados contra a árvore
      # real da versão-alvo. Paths abaixo são exemplos.
      - uses: docker/build-push-action@v5
        with:
          context: .
          file: ./apps/api/Dockerfile.api
          push: true
          tags: |
            ghcr.io/${{ github.repository }}/plane-api:${{ steps.tag.outputs.tag }}
            ghcr.io/${{ github.repository }}/plane-api:latest-${{ github.ref_name }}
      - uses: docker/build-push-action@v5
        with:
          context: .
          file: ./apps/web/Dockerfile.web
          push: true
          tags: |
            ghcr.io/${{ github.repository }}/plane-web:${{ steps.tag.outputs.tag }}
            ghcr.io/${{ github.repository }}/plane-web:latest-${{ github.ref_name }}
      - run: echo "${{ steps.tag.outputs.tag }}" > image-tag.txt
      - uses: actions/upload-artifact@v4
        with:
          name: image-tag
          path: image-tag.txt
          retention-days: 7
```

### 26.5 deploy-stg.yml — automático após CI em develop

```yaml
name: Deploy STG

on:
  workflow_run:
    workflows: [CI]
    types: [completed]
    branches: [develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with:
          name: image-tag
          run-id: ${{ github.event.workflow_run.id }}
          github-token: ${{ secrets.GHCR_TOKEN }}
      - id: tag
        run: echo "tag=$(cat image-tag.txt)" >> $GITHUB_OUTPUT
      - uses: dawidd6/action-ansible-playbook@v2
        with:
          playbook: ansible/playbooks/deploy.yml
          inventory: ansible/inventory/stg.ini
          key: ${{ secrets.STG_SSH_PRIVATE_KEY }}
          options: |
            --extra-vars "image_tag=${{ steps.tag.outputs.tag }} env=stg"
            --vault-password-file <(echo "${{ secrets.ANSIBLE_VAULT_PASSWORD }}")
        env:
          ANSIBLE_HOST_KEY_CHECKING: "False"
      - name: Smoke test STG
        run: |
          sleep 30
          curl --fail --retry 5 --retry-delay 10 \
            https://stg-plane.artesp.sp.gov.br/api/health/ || exit 1
```

### 26.6 deploy-prd.yml — manual com aprovação

```yaml
name: Deploy PRD

on:
  workflow_dispatch:
    inputs:
      image_tag:
        description: "Image tag to deploy (ex: main-a1b2c3d)"
        required: true
      confirm:
        description: "Type DEPLOY to confirm"
        required: true

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - run: |
          if [ "${{ github.event.inputs.confirm }}" != "DEPLOY" ]; then
            echo "Confirmation failed."; exit 1
          fi

  deploy:
    runs-on: ubuntu-latest
    needs: validate
    environment: production    # bloqueia até aprovação manual no GitHub
    steps:
      - uses: actions/checkout@v4
      - name: Backup pré-deploy
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.PRD_SSH_HOST }}
          username: ${{ secrets.PRD_SSH_USER }}
          key: ${{ secrets.PRD_SSH_PRIVATE_KEY }}
          script: |
            docker exec plane-artesp-postgres-1 \
              pg_dump -U plane plane | \
              gzip > /backup/pre-deploy-$(date +%Y%m%d-%H%M).sql.gz
            echo "Backup concluído."
      - uses: dawidd6/action-ansible-playbook@v2
        with:
          playbook: ansible/playbooks/deploy.yml
          inventory: ansible/inventory/prd.ini
          key: ${{ secrets.PRD_SSH_PRIVATE_KEY }}
          options: |
            --extra-vars "image_tag=${{ github.event.inputs.image_tag }} env=prd"
            --vault-password-file <(echo "${{ secrets.ANSIBLE_VAULT_PASSWORD }}")
        env:
          ANSIBLE_HOST_KEY_CHECKING: "False"
      - name: Smoke test PRD
        run: |
          sleep 30
          curl --fail --retry 5 --retry-delay 10 \
            https://plane.artesp.sp.gov.br/api/health/ || exit 1
```

---

## 27. Ansible — deploy

### 27.1 Princípios

1. Apenas artefatos necessários são copiados.
2. Secrets vêm de Ansible Vault.
3. Deploy deve ser idempotente.
4. Migration é etapa explícita — usar serviço `migrator` oficial.
5. Rollback deve ser possível com tag anterior.
6. Compose project name deve ser controlado.

### 27.2 playbooks/deploy.yml

```yaml
---
- name: Deploy Plane ARTESP
  hosts: plane
  become: true

  vars:
    app_dir: /opt/plane-artesp
    compose_file: "docker-compose.{{ env }}.yml"

  tasks:
    - name: Ensure app directory exists
      file:
        path: "{{ app_dir }}"
        state: directory
        owner: deploy
        mode: "0750"

    - name: Copy docker-compose files
      copy:
        src: "deploy/{{ item }}"
        dest: "{{ app_dir }}/{{ item }}"
      loop:
        - docker-compose.yml
        - "docker-compose.{{ env }}.yml"

    - name: Write .env from vault template
      template:
        src: templates/env.j2
        dest: "{{ app_dir }}/.env"
        mode: "0600"
        owner: deploy

    - name: Log in to GHCR
      community.docker.docker_login:
        registry: ghcr.io
        username: "{{ ghcr_user }}"
        password: "{{ ghcr_token }}"

    - name: Pull new images
      community.docker.docker_compose_v2:
        project_src: "{{ app_dir }}"
        files: [docker-compose.yml, "{{ compose_file }}"]
        pull: always
        env_files: ["{{ app_dir }}/.env"]

    - name: Run migrator service
      # Usar serviço migrator oficial — não executar migrate diretamente
      community.docker.docker_compose_v2:
        project_src: "{{ app_dir }}"
        files: [docker-compose.yml, "{{ compose_file }}"]
        services: [plane-migrator]
        env_files: ["{{ app_dir }}/.env"]
        state: present

    - name: Wait for migrator to finish
      community.docker.docker_container_info:
        name: "plane-artesp-plane-migrator-1"
      register: migrator_info
      until: migrator_info.container.State.Status == 'exited'
      retries: 30
      delay: 10

    - name: Fail if migration failed
      fail:
        msg: "Migrator exited with code {{ migrator_info.container.State.ExitCode }}"
      when: migrator_info.container.State.ExitCode != 0

    - name: Restart application services
      community.docker.docker_compose_v2:
        project_src: "{{ app_dir }}"
        files: [docker-compose.yml, "{{ compose_file }}"]
        state: restarted
        env_files: ["{{ app_dir }}/.env"]

    - name: Register deployed version
      copy:
        content: "{{ image_tag }}"
        dest: "{{ app_dir }}/CURRENT_RELEASE"
        mode: "0644"
```

---

## 28. Rollback

### 28.1 Regra

Todo deploy em produção deve ter rollback documentado antes de começar.

### 28.2 Criar ROLLBACK.md

```markdown
# Rollback — Plane ARTESP

## Última versão estável

- Imagem API: <tag>
- Imagem web/app: <tag>
- Commit: <sha>
- Backup pré-deploy: <identificador e caminho>

## Rollback simples (sem migration incompatível)

1. Atualizar IMAGE_TAG no .env ou compose override.
2. Executar deploy com tag anterior via workflow_dispatch.
3. Rodar smoke tests.

## Rollback com banco (migration incompatível)

1. Interromper aplicação.
2. Restaurar backup PostgreSQL.
3. Restaurar storage MinIO, se necessário.
4. Subir versão anterior.
5. Rodar smoke tests.
6. Registrar incidente.
```

### 28.3 Smoke tests mínimos

```text
- página inicial responde com 200;
- API healthcheck responde;
- login funciona;
- criação de workspace/projeto funciona em STG;
- upload de anexo funciona;
- worker processa fila;
- e-mail de teste é enviado;
- portal externo não expõe dados indevidos.
```

---

## 29. Runbooks obrigatórios

Criar diretório `docs/runbooks/` com pelo menos:

```text
docs/runbooks/install.md
docs/runbooks/deploy.md
docs/runbooks/backup.md
docs/runbooks/restore.md
docs/runbooks/rollback.md
docs/runbooks/update-upstream.md
docs/runbooks/security-incident.md
docs/runbooks/user-offboarding.md
docs/runbooks/storage-recovery.md
docs/runbooks/database-maintenance.md
```

---

## 30. Matriz de riscos

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| Fork divergir do upstream | Alta | Alto | Customização mínima e sync mensal. |
| Exposição indevida de dados | Média | Alto | Portal separado e revisão de permissões. |
| Falha de backup | Média | Crítico | Restore mensal testado. |
| Quebra em atualização | Alta | Alto | STG, smoke test e rollback documentado. |
| SSO mal implementado | Média | Crítico | Projeto separado e testes de segurança. |
| Auditoria insuficiente | Alta | Alto | Não prometer auditoria regulatória sem projeto próprio. |
| Kubernetes prematuro | Média | Alto | Começar com Docker Compose. |
| Violação AGPL | Baixa/Média | Alto | Plano de conformidade e publicação do código. |
| Secrets publicados | Média | Crítico | Secret scanning no CI e revisão de PR. |
| Webhook causando SSRF | Média | Alto | Allowlist e bloqueio de rede privada. |

---

## 31. Checklist de go-live

```text
[ ] Versão-alvo congelada e documentada em VERSION.md
[ ] DEV local reproduzível em qualquer PC que clone o repositório
[ ] Instalação reproduzível via Docker Compose oficial ou wrapper local documentado
[ ] Script de inspeção executado e saída arquivada
[ ] DNS configurado
[ ] TLS configurado (Caddy ou proxy externo)
[ ] SMTP testado
[ ] Banco com backup automático
[ ] Storage com backup automático
[ ] Restore testado em ambiente isolado
[ ] Logs disponíveis e centralizados
[ ] Métricas básicas disponíveis
[ ] Alertas mínimos configurados
[ ] Secrets fora do Git
[ ] DEBUG=0
[ ] Usuários administradores definidos
[ ] Conta break-glass definida e protegida
[ ] Política de acesso definida
[ ] Política de offboarding definida
[ ] COMPLIANCE.md criado
[ ] Link de código-fonte publicado (se houver modificação)
[ ] Staging validado
[ ] Smoke tests aprovados
[ ] Rollback documentado em ROLLBACK.md
[ ] Runbooks mínimos criados
[ ] Avaliação LGPD registrada
[ ] Exposição externa revisada
[ ] Portal externo separado, se houver público/concessionária
[ ] Webhook allowlist configurado
```

---

## 32. Prompt operacional — análise de mudança no fork

```text
Atue como arquiteto de software especialista em Django, frontend moderno,
segurança de aplicações, licenças open source e operação self-hosted em VMs.

Contexto:
Estamos avaliando uma mudança no fork institucional do Plane CE usado pela ARTESP.
O Plane CE é licenciado sob AGPL v3. A implantação é self-hosted com Docker Compose
em VMs. O fork deve ser mínimo, rastreável e fácil de sincronizar com o upstream
makeplane/plane.

Tarefa:
Avalie a mudança proposta abaixo e produza relatório técnico objetivo.

Mudança proposta: <DESCREVER MUDANÇA>
Versão-alvo do Plane: <TAG/COMMIT>
Arquivos alterados: <LISTAR>

O relatório deve conter:
1. Resumo da mudança.
2. Necessidade real da customização.
3. Alternativas sem alteração do core.
4. Risco de conflito com upstream.
5. Impacto AGPL.
6. Impacto de segurança.
7. Impacto em LGPD.
8. Impacto em deploy/migration/rollback.
9. Testes necessários.
10. Recomendação final: aprovar, ajustar ou rejeitar.

Restrições:
- Não presumir estrutura antiga do Plane.
- Não presumir Next.js se a versão-alvo usar outra stack.
- Não recomendar exposição pública direta do Plane.
- Não propor segredos hardcoded.
- Não propor alteração profunda sem justificar manutenção futura.
```

---

## 33. Prompt operacional — sincronização com upstream

```text
Atue como engenheiro responsável pela manutenção de um fork AGPL do Plane CE.

Contexto:
Fork institucional plane-artesp, derivado do upstream makeplane/plane. Objetivo:
sincronizar nova versão sem perder customizações, minimizando conflitos e preservando
conformidade AGPL.

Entrada:
- Versão atual em produção: <TAG_ATUAL>
- Nova versão upstream pretendida: <TAG_NOVA>
- Lista de customizações ARTESP: <LISTA>
- Resultado de git diff/stat: <COLAR>
- Changelog upstream: <COLAR>

Produza:
1. Resumo das mudanças upstream relevantes.
2. Riscos de segurança corrigidos pela nova versão.
3. Arquivos com maior risco de conflito.
4. Migrations envolvidas.
5. Variáveis de ambiente novas ou removidas.
6. Features bloqueadas que foram liberadas para o CE.
7. Plano de merge.
8. Plano de teste em STG.
9. Plano de backup pré-produção.
10. Plano de rollback.
11. Recomendação: atualizar agora, aguardar ou rejeitar.
```

---

## 34. Resumo executivo

O Plane CE é viável para uso self-hosted institucional, desde que a ARTESP trate a
solução como **ferramenta de gestão de trabalho** e não como plataforma regulatória
completa.

O maior risco não é instalar o Plane, mas:

- operar fork divergente e difícil de sincronizar;
- expor dados internos indevidamente;
- subestimar SSO, auditoria e workflows como "pequenas customizações";
- negligenciar backup, restore, segurança e conformidade AGPL.

A estratégia tecnicamente mais defensável:

```text
1. Implantar Plane CE puro em STG — sem fork.
2. Validar funcionalidades reais da versão instalada.
3. Configurar domínio, TLS, SMTP, backups e observabilidade.
4. Piloto interno com poucos usuários.
5. Criar fork somente quando houver necessidade concreta e justificada.
6. Manter fork mínimo — preferir configuração e API sobre alteração do core.
7. Publicar código modificado conforme AGPL.
8. Criar portal externo separado para qualquer exposição pública.
9. Tratar SSO, audit logs e workflows como projetos independentes.
10. Atualizar upstream mensalmente com checklist.
```

---

## Referências

- Repositório upstream: https://github.com/makeplane/plane
- Documentação self-hosting: https://developers.plane.so/self-hosting/self-hosting-101
- Docker Compose oficial: https://developers.plane.so/self-hosting/methods/docker-compose
- Releases e changelog: https://github.com/makeplane/plane/releases
- Fork OIDC comunitário (referência): https://github.com/bitbay/plane-oidc
- API docs: https://developers.plane.so/api-reference
- Licença AGPL v3: https://www.gnu.org/licenses/agpl-3.0.html
- Arquitetura (Deepwiki): https://deepwiki.com/makeplane/plane
