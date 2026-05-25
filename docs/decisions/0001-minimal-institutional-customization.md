# 0001 - Customizacao institucional minima

Data: 2026-05-25

## Status

Aprovada para primeiro ciclo.

## Contexto

Este repositorio mantem um fork institucional do Plane CE para a ARTESP. O primeiro
ciclo deve provar que o monorepo, o ambiente dev local, o smoke test e a governanca AGPL
funcionam antes de customizacoes profundas.

## Decisao

Aplicar apenas customizacoes de baixo risco e alto sinal institucional:

- branding textual ARTESP em metadados, manifestos PWA e titulo das aplicacoes;
- aviso AGPL visivel na tela de autenticacao do web app;
- primeiro texto PT-BR prioritario na tela publica de autenticacao;
- configuracao institucional mantida em `.env.example` e documentacao, sem secrets reais.

Nao entram neste ciclo:

- SSO/OIDC;
- auditoria robusta;
- workflows formais;
- alteracoes estruturais no modelo de dados;
- exposicao publica direta do Plane.

## Consequencias

- O codigo do Plane passa a ter alteracoes derivadas em `plane/` e deve continuar sob AGPL v3.
- `COMPLIANCE.md` e `CHANGELOG.md` devem apontar os arquivos modificados.
- O build a partir do codigo-fonte passa a ser validacao obrigatoria antes de promover novas customizacoes.

