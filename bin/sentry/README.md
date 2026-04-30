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
