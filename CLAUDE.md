# CLAUDE.md - Apistration Monorepo Guide

Ce dépôt regroupe plusieurs projets ; chacun a son propre `CLAUDE.md`
avec les conventions spécifiques :

- `siade/CLAUDE.md` — backend SIADE (API Entreprise / API Particulier)
- `site/CLAUDE.md` — admin SIADE (front + back-office)
- `mocks/CLAUDE.md` — mocks fournisseurs
- `clients/` — SDKs officiels (`clients/SPECS.md` normatif, `clients/ruby/`
  implémentation de référence ; autres langages à venir)

## Conventions transverses

- Messages de commit rédigés en anglais.

## Outils partagés

### Sentry / Production Errors

Scripts à `bin/sentry/` (voir `bin/sentry/README.md`). Supportent les
projets `siade-backend` (défaut) et `siade-site` via `-P/--project` ou
`SENTRY_PROJECT`.

```bash
bin/sentry/issues                 # siade-backend
bin/sentry/issues -P siade-site   # siade-site
```

Les filtres spécifiques aux erreurs fournisseurs (`http_response_code`,
`http_response_body`, `provider`, controller/action) ne s'appliquent qu'à
`siade-backend`.
