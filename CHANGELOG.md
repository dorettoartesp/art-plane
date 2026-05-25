# ARTESP Changelog

## Base inicial

- Base upstream: makeplane/plane v1.3.1
- Commit upstream: d0a4adc55bb1fa5b8c221c0c680b992d2677e9c5
- Estado inicial: sem customizacoes registradas.

## Decisões iniciais de customização

- Manter o Plane em `plane/` como código versionado no monorepo.
- Priorizar ambiente `dev` local reproduzível antes de STG/PRD.
- Primeiras customizações candidatas: branding ARTESP, textos em português brasileiro,
  aviso/link AGPL e ajustes de configuração institucional.
- SSO/OIDC, auditoria robusta e workflows formais continuam fora do primeiro ciclo até
  haver análise própria de risco e esforço.

## Customização institucional mínima

- Decisão registrada em `docs/decisions/0001-minimal-institutional-customization.md`.
- Branding textual ARTESP aplicado em metadados e manifestos:
  - `plane/apps/web/app/root.tsx`
  - `plane/apps/admin/app/root.tsx`
  - `plane/apps/space/app/root.tsx`
  - `plane/apps/web/public/site.webmanifest.json`
  - `plane/apps/web/public/manifest.json`
  - `plane/apps/admin/public/site.webmanifest.json`
  - `plane/apps/space/public/site.webmanifest.json`
- Aviso/link AGPL e primeiro texto PT-BR prioritário aplicados na tela de autenticação:
  - `plane/apps/web/core/components/auth-screens/footer.tsx` (corrigido acentuação para "Código-fonte")

## Tradução Padrão PT-BR e Otimizações de Build Docker (25/05/2026)

- **Tradução Automática PT-BR out-of-the-box**:
  - Habilitado Português Brasileiro (PT-BR) como o idioma padrão da aplicação (alteração do `FALLBACK_LANGUAGE` no arquivo `plane/packages/i18n/src/constants/language.ts`), garantindo uma interface institucional traduzida de fábrica sem necessidade de alteração manual pelos usuários.
- **Otimização de Build Docker (Redução de 15 minutos para 2.7 minutos)**:
  - Corrigido o bug de invalidação de camadas do Docker nos Dockerfiles front-end (`web`, `admin`, `space`, `live`), reordenando as etapas de build para instalar dependências *antes* de copiar o código-fonte completo.
  - Eliminado o gargalo do `pnpm fetch` em monorepos (que baixava dependências de todas as outras apps desnecessariamente), substituindo-o por `pnpm install` sobre o escopo podado de dependências e habilitando cache persistente ideal de BuildKit (`--mount=type=cache`).
- **Homologação e Testes**:
  - Homologado com sucesso o fluxo completo de nova máquina (setup, login, criação de workspace, projetos e tarefas) em stack Docker isolada na porta `8095` sem afetar o banco ativo.
  - Validada a integridade geral do ambiente local via testes de fumaça (`make smoke`).
