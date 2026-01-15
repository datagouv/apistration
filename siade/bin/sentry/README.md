# Sentry CLI Tools

Scripts pour interagir avec l'API Sentry du projet SIADE (errors.data.gouv.fr).

## Setup

1. Créer un token sur https://errors.data.gouv.fr/settings/account/api/auth-tokens/
2. Scopes requis: `event:read`, `project:read`
3. Sauvegarder le token:

```bash
echo "votre_token" > .sentry_token
```

## Scripts

### issues - Lister les issues

```bash
bin/sentry/issues                           # Issues non résolues (14j)
bin/sentry/issues -p 24h                    # Sur 24 heures
bin/sentry/issues -q "http_response_code:502"  # Recherche custom
```

### issue - Détails d'une issue

```bash
bin/sentry/issue 123456                     # Affiche en markdown
bin/sentry/issue 123456 -o tmp/issue.md     # Sauvegarde dans un fichier
```

Affiche: info, exception, request, contexte, tags, stacktrace.

### events - Lister les events

```bash
bin/sentry/events 123456                    # 100 premiers events
bin/sentry/events 123456 -p 5               # 500 events (5 pages)
bin/sentry/events 123456 --full             # Avec détails complets
```

### export - Export CSV

```bash
bin/sentry/export 123456                    # -> tmp/sentry_123456.csv
bin/sentry/export 123456 -p 5               # 500 events
bin/sentry/export 123456 -o rapport.csv     # Fichier custom
```

Colonnes: event_id, date, http_status, http_body, controller, action.

## Exemples de queries Sentry

```bash
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
bin/sentry/issues -q "is:unresolved http_response_code:502" -p 24h
```

## Legacy

`events_lookup_legacy.rb` - Ancien script avec décryptage des params API Particulier.
