# Bandeau d'annonce

Bandeau DSFR `warning` (refermable) affiché sur toutes les pages
d'API Entreprise et d'API Particulier, pour prévenir d'un événement
temporaire (maintenance ProConnect, etc).

## Utilisation

Éditer [`config/announcement_banner.yml`](../config/announcement_banner.yml) :

```yaml
shared:
  start: "2026-04-23 17:50"
  end: "2026-04-23 19:30"
  title: "Maintenance ProConnect ce soir à 18h"
  description: "..."
```

Dates parsées par [Chronic](https://github.com/mojombo/chronic) :
formats variés acceptés (`"2026-04-23 17:50"`, `"April 23 2026 at 6pm"`…),
fuseau serveur (Paris).

Le bandeau s'affiche uniquement entre `start` et `end`. Pour le
désactiver sans redéployer : mettre `end` dans le passé.
