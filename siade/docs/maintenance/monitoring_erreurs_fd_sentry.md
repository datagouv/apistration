# Monitoring des erreurs des fournisseurs de données via Sentry

**A. Configuration globale**

Les notifications sentry sont, pour chaque endpoint, définie à l'aide
de Metric Alert ([ici](https://errors.data.gouv.fr/organizations/sentry/alerts/rules/?project=9)). Plus d'infos sur les Metric alerts [ici](https://docs.sentry.io/product/alerts-notifications/metric-alerts/)

Pour tous les endpoints (sauf cas contraire spécifié), la configuration est la suivante:
* Environment: **production**
* Data Source: **event.type:error OR event.type:default**
* Filter: **provider:PROVIDER_NAME endpoint:/path/to/endpoint#action** avec:
  * **provider** = Nom du provider (exemple: INSEE)
  * **endpoint** = la route telle qu'elle est définie par Rails (exemple: api/v2/entreprises_restored#show)
* Metric
  * Function: **count()**
  * Window: **30 minutes**

Vis-à-vis des paliers, c'est en fonction des endpoints. On peut regarder sur 30 jours les events et définir en fonction des pics un Critical Status et un Warning Status.

Mettre une action d'envoi d'emails à l'équipe api-entreprise pour le Critical Status.

**B. Philosophie**

L'objectif est d'avoir un tracking des erreurs assez fin en fonction du type d'erreur, et de garder un backlog sur Sentry le plus minimal possible.

Cela permet de fixer au fil de l'eau, en fonction de la doctrine ci-dessous, les erreurs. Mise à part les erreurs de connections aux webservices qui seront géré de manière générique, les fixes seront présent au sein des drivers du fournisseur afin de comprendre au mieux ce qui peut planter sans avoir à remonter jusqu'à un rescue générique et/ou global.

En synthèse, cela donne:

1. Privilégier la gestion de l'erreur de réponse fournisseur dans les classes spécifiques aux fournisseurs
2. Pratiquer une "inbox 0" dans le Sentry sur les erreurs 500 permet de fixer au fil de l'eau les erreurs fournisseurs

A noter que toutes les erreurs fournisseurs seront trackées, mais seulement les comportements anormaux lèveront des alertes.

Configuration du Sentry (v1)

Liste des erreurs traitées :
1. Erreurs 500 du système
2. Erreurs 500 du fournisseur
3. Erreurs 502 du fournisseur
4. Erreurs 503 du fournisseur
5. Erreurs 504 du fournisseur
6. Erreurs 403 du fournisseur
7. Erreurs de données manquantes du fournisseur (code 206)
8. Erreurs de données dépréciées du fournisseur (code 200)

Configuration générale

Pour chaque erreur remonté autre que 500:
* Affecter au tag "endpoint" la ressource
* Affecter au tag "provider" le nom du fournisseur

Nomenclature pour chaque erreur

a. Erreur 500 du système (cas 1.) :
* Label Erreur
* Notifier à la première occurrence
* Notifier si plus de X occurrences en moins de Y temps

b. Erreur 50X et 403 du fournisseur (cas  2., 3., 4., 5., 6.) :
Le nom de l'erreur inclura le fournisseur et le code retour (1 event / fournisseur x code retour)
* Label Warning
* Notifier si plus de X occurrences en moins de Y temps

c. Erreur de donnée(s) manquante(s) d'un fournisseur (code retour 206) (cas 7.)
Le nom de l'erreur inclura le fournisseur et le champ manquant  (1 event / fournisseur x champ)
* Label Info
* Notifier si plus de X occurrences en moins de Y temps

d. Erreur de données dépréciées du fournisseur (code retour 200) (cas 8.)
Le nom de l'erreur inclura le fournisseur et le champ manquant  (1 event / fournisseur x champ)
* Label Info
* Notifier si plus de X occurrences en moins de Y temps

**C. Notes spécifiques par provider**

i. Endpoints sans alertes configurées
* DGFIP (tous les endpoints) : rien n'a été setup, trop aléatoire et pas vraiment de "trend" détectable
* Attestations sociales retraite ProBTP : c'est constamment le même trend, on va se faire spammer pour rien
* Effectifs covid : pas d'erreurs sur sentry (fourni par nous donc à priori pas de souci)
* Ademe: de manière récurrente à ~13h un des champs est vide

ii. Endpoints avec des configurations particulières
* ACOSS attestations sociales: on ignore les FUNC503 (analyse situation du compte en cours)
* INPI: actes et bilans, pas assez de data (2 max d'erreurs sur 30m). J'ai quand même mis 3 en critique

## Données personnelles dans Sentry

Afin d'éviter la fuite de données personnelles dans Sentry les query params
d'API Particulier sont chiffrés à l'aide de GPG avant d'être envoyés dans Sentry.

Les clefs publiques de chiffrement sont déployés par Ansible dans `config/gpg_public_keys_for_data_encryption`

> Dans le repo very_ansible, run `ansible-vault view roles/siade/files/private.asc | gpg --import` pour importer les credentials te permettant de déchiffrer les données. Pour obtenir la passphrase demandée par cette dernière commande, `ansible-vault view secrets/siade_gpg_infos.yml` -> clef `siade_gpg_passphrase`.

Pour déchiffrer les données :
```shell
./bin/decrypt_gpg_json_params_from_unknown_provider_tracking_error.sh <encrypted_data_from_sentry.gpg>
```

## Récupération d'événements pour transmission à un fournisseur de données

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
