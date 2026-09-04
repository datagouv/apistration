# CLAUDE.md - Apistration Monorepo Guide

Ce dépôt regroupe plusieurs projets ; chacun a son propre `CLAUDE.md`
avec les conventions spécifiques :

- `siade/CLAUDE.md` — backend SIADE (API Entreprise / API Particulier)
- `site/CLAUDE.md` — admin SIADE (front + back-office)
- `mocks/CLAUDE.md` — mocks fournisseurs
- `clients/` — SDKs officiels (`clients/SPECS.md` normatif, `clients/ruby/`
  et `clients/node/` ; autres langages à venir)

## Conventions transverses

- Messages de commit rédigés en anglais.
- **Toute itération sur une signature d'API publique** (nouveau endpoint,
  nouvelle version, paramètre ajouté/supprimé/renommé/rendu optionnel,
  changement de format de réponse, dépréciation) doit s'accompagner d'une
  itération sur les clients officiels dans `clients/` — au minimum
  régénération du scaffolding pour **les deux SDKs** :
  - Ruby : `clients/ruby/bin/scaffold_resources`
  - Node : `cd clients/node && npx tsx bin/scaffold-resources.ts`

  puis release SemVer-correcte (cf. skill `release-new-version`). Un
  changement serveur sans mise à jour client = SDK qui ment à ses utilisateurs.

## Worktrees

Par défaut, tout développement démarre dans un worktree dédié sous
`worktrees/<nom>`, un worktree par sujet. Le nom est soit un ticket Linear
(`API-7345`), soit un slug pour une demande ad hoc sans ticket (`cnav-nir`).
Depuis n'importe quel worktree :

```bash
bin/setup_worktree.sh API-7345            # ticket Linear, branche déduite
bin/setup_worktree.sh cnav-nir            # demande ad hoc, branche feature/cnav-nir
bin/setup_worktree.sh API-7345 fix/insee  # branche imposée
bin/setup_worktree.sh -p 4000 API-7345    # ports imposés (siade 4000, site 4001)
cd worktrees/api-7345
```

Le script réutilise une branche existante (locale ou `origin/`) dont le nom
contient le nom donné — typiquement la branche générée par Linear
(`feature/api-7345-...`) — sinon crée `feature/<nom>` depuis `develop`.
Il génère ensuite dans `siade/` et `site/` un `.env.local` (dev) et un
`.env.test.local` (test, car dotenv ignore `.env.local` en `test`) avec :

- des bases Postgres propres au worktree (`siade_development_api_7345`,
  `admin_apientreprise_test_api_7345`, etc.) ;
- un `PORT` propre au worktree : `1NNNN` pour `siade`, `2NNNN` pour `site`,
  NNNN étant le numéro du ticket (API-7345 → 17345 / 27345) ou un hash du
  slug pour une demande ad hoc. Lu par `config/puma.rb`,
  `ProConnectConfig.host` et les URLs des mails.

puis lance `bundle install` et `bin/rails db:prepare` dans les deux apps.
`bin/rails s` suffit ensuite, sans `-p`. Plusieurs worktrees peuvent tourner
en parallèle.

Ne pas démarrer un développement sur le worktree principal sauf demande
explicite.

### Nettoyage après merge

Dès qu'une PR liée à un worktree est mergée, nettoyer dans la foulée, sans
attendre qu'on le redemande, depuis le worktree principal :

```bash
bin/remove_worktree.sh API-7345
bin/remove_worktree.sh cnav-nir
```

Le script arrête les serveurs du worktree, supprime le worktree, la branche
locale (la branche distante est conservée) et toutes ses bases Postgres.

## Ressources partagées (`commons/`)

- `commons/endpoints/` — fiches descriptives des endpoints (YAML). Contient
  la documentation utilisateur (périmètre, paramètres, FAQ, historique des
  versions) affichée sur le site. C'est ici qu'il faut modifier la doc
  d'un endpoint.
- `commons/swagger/` — fichiers OpenAPI générés (ne pas éditer à la main,
  régénérer via `siade/bin/generate_swagger.sh`).
- `commons/data/authorizations.yml` — scopes d'accès API.

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
