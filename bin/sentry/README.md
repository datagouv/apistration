# Sentry CLI Tools

Scripts pour interagir avec l'API Sentry (errors.data.gouv.fr) pour les
projets `siade-backend` et `siade-site`.

## Setup

1. Créer un token sur https://errors.data.gouv.fr/settings/account/api/auth-tokens/
2. Scopes requis: `event:read`, `project:read`
3. Sauvegarder le token à la racine du repo (ou dans le cwd) :

```bash
echo "votre_token" > .sentry_token
```

Le token est cherché d'abord dans `Dir.pwd/.sentry_token` puis à la racine
du dépôt (`<repo>/.sentry_token`).

## Sélection du projet

Tous les scripts acceptent `-P/--project` (alias env `SENTRY_PROJECT`).
Projets valides : `siade-backend` (défaut), `siade-site`.

```bash
bin/sentry/issues -P siade-site
SENTRY_PROJECT=siade-site bin/sentry/issues
```

## Scripts

### issues - Lister les issues

```bash
bin/sentry/issues                              # siade-backend, 14j
bin/sentry/issues -P siade-site                # siade-site
bin/sentry/issues -p 24h                       # Sur 24 heures
bin/sentry/issues -q "http_response_code:502"  # Recherche custom (siade-backend)
```

### issue - Détails d'une issue

```bash
bin/sentry/issue 123456                     # Affiche en markdown
bin/sentry/issue 123456 -P siade-site
bin/sentry/issue 123456 -o tmp/issue.md     # Sauvegarde dans un fichier
```

### events - Lister les events

```bash
bin/sentry/events 123456                    # 100 premiers events
bin/sentry/events 123456 -p 5               # 500 events (5 pages)
bin/sentry/events 123456 --full             # Avec détails complets
```

Sur `siade-backend` : http_code + controller. Sur `siade-site` : title/message.

### export - Export CSV

```bash
bin/sentry/export 123456                    # -> tmp/sentry_123456.csv
bin/sentry/export 123456 -p 5               # 500 events
bin/sentry/export 123456 --full             # Inclut http_response_body (siade-backend)
bin/sentry/export 123456 -o rapport.csv     # Fichier custom
```

Colonnes par projet :
- `siade-backend` : event_id, date, http_status, http_body, controller, action
- `siade-site`    : event_id, date, title, message, url

Note : sur `siade-backend`, sans `--full`, `http_body` sera vide. Utiliser
`--full` pour récupérer les `http_response_body` des Provider errors
(fetch chaque event).

### watch-precheck - Précheck du job ags `sentry-watch`

Liste en JSON les issues unresolved de niveau error/fatal des deux projets,
apparues ou régressées depuis `AGS_LAST_SUCCESS_AT` (6 h avant le premier
succès), dédupliquées. Exit 1 si rien de neuf. Une API en panne (429,
5xx, page HTML) fait sauter le run ; elle devient une erreur après 30 min
de panne continue (état dans `AGS_JOB_STATE_DIR`). 401/403 : erreur
immédiate. Prompt du job : `.ags/sentry-watch.md`.

Le job est partagé dans `.ags.yml` : chaque collègue qui l'a ajouté le
lance toutes les 5 min. Pour qu'une issue ne soit triée qu'une fois, le
précheck la revendique en postant sur Sentry la note `Triage claimed by
the ags job sentry-watch`, avec le token d'écriture, puis relit 3 s plus
tard. La première note gagne (date et id attribués par Sentry), comptée
depuis la régression pour une issue régressée, depuis toujours pour une
nouvelle ; le perdant retire la sienne et ne transmet pas
l'issue. Une issue déjà revendiquée par soi lors d'un run échoué est
retransmise.

```bash
AGS_JOB_STATE_DIR=tmp AGS_LAST_SUCCESS_AT=2026-11-03T00:00:00Z bin/sentry/watch-precheck
ruby bin/sentry/test/watch_precheck_test.rb  # Ruby stdlib, HTTP stubbé
```

### resolve - Résoudre une issue

```bash
bin/sentry/resolve 123456  # id numérique, pas le short id
```

Token d'écriture distinct dans `.sentry_write_token` (scope `event:write`),
cherché comme `.sentry_token`.

## Spécificités siade-backend

Les filtres et extractions liés aux erreurs fournisseurs ne s'appliquent
qu'au projet `siade-backend`. Les erreurs fournisseurs sont stockées dans
le context `Provider error` avec :

- `http_response_code` - Code HTTP de la réponse
- `http_response_body` - Corps de la réponse (JSON, HTML, PDF base64...)
- `http_response_headers` - Headers de la réponse

Les noms de providers sont définis dans `siade/app/services/errors_backend.rb`.

### Exemples de queries siade-backend

```bash
# Par provider (voir siade/app/services/errors_backend.rb pour les noms)
bin/sentry/issues -q "provider:ACOSS"
bin/sentry/issues -q "provider:INSEE"
bin/sentry/issues -q "provider:DGFIP"

# Par code HTTP
bin/sentry/issues -q "http_response_code:502"
bin/sentry/issues -q "http_response_code:400"

# Par endpoint
bin/sentry/issues -q "controller:api_entreprise"
bin/sentry/issues -q "url:*/v3/insee/*"

# Par niveau
bin/sentry/issues -q "is:unresolved level:error"
bin/sentry/issues -q "is:unresolved level:warning"

# Combiné
bin/sentry/issues -q "is:unresolved provider:ACOSS level:error"
bin/sentry/issues -q "is:unresolved http_response_code:502" -p 24h
```

## Legacy

`events_lookup_legacy.rb` - Ancien script avec décryptage des params API
Particulier (siade-backend uniquement).
