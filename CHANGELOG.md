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
  - `plane/apps/web/core/components/auth-screens/footer.tsx`
