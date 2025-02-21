# Récupération d'événements pour transmission à un fournisseur de données

Afin de faciliter l'extraction d'informations à transmettre à un fournisseur de
données concernant des appels en défaut, il est possible d'utiliser le script `bin/sentry_events_lookup.rb`

L'usage est le suivant:

```sh
bundle exec ruby bin/sentry_events_lookup.rb ISSUE_ID [page_count]
```

Ce script permet de lookup les événements d'un issue et d'en extraire les
informations suivantes:

1. La réponse du fournisseur de données : body et status
2. La date
3. Les paramètres

Un fichier CSV avec ces informations est ensuite généré.

Pour les paramètres, dans le cas d'API Particulier, ceux-ci sont déchiffrés à la
volée. Le fichier généré contient donc des informations sensibles concernant les
utilisateurs, à manipuler avec prudence donc.
