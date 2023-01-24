# Dépôt de données de tests pour API Particulier / API Entreprise v3+

[![Tests](https://github.com/etalab/siade_staging_data/actions/workflows/tests.yml/badge.svg)](https://github.com/etalab/siade_staging_data/actions/workflows/tests.yml)

# ⚠️ Il s'agit encore d'un dépôt en chantier, rien n'est actuellement fonctionnel ⚠️

Ce dépôt contient l'ensemble des données de tests pour les environnements de bac
à sable d'API Entreprise (seulement pour la v3+)
( https://staging.entreprise.api.gouv.fr ) et d'API
Particulier ( https://staging.entreprise.api.gouv.fr )

## Fonctionnement

L'ensemble des payloads de réponses se trouvent dans le dossier `payloads/`.
Chaque endpoint possède son propre dossier sous l'une de ces formes:

```
api_entreprise_version_path_to_payload
api_particulier_version_path_to_payload
```

Par exemple:

```
api_entreprise_v3_insee_unite_legale
api_particulier_v2_dgfip_svair
```

Une table de correspondance url <-> nom du dossier est disponible à la
racine du dossier payload: [README.md](./payloads/README.md) (généré
automatiquement par `bin/generate_payload_readme.rb`)

Chaque dossier possède un README.md ainsi que des fichiers YAML ayant le format
suivant:

```yaml
---
params:
  first_name: 'John'
  last_name: 'Doe'
status: 200
payload: |
  {
    "status": "OK"
  }
```

Avec:

* `params`, ensemble de clé valeur traduisant les paramètres qui déclenchent la
    réponse associée ;
* `status`, le status de la réponse HTTP associé ;
* `payload`, la payload renvoyée.

Pour déclencher la réponse ci-dessous, avec comme application API Particulier
et comme chemin `v1/dgfip/impots`, il faut effectuer l'appel suivant:

```sh
curl -X GET \
  -G -d 'first_name=John' -d 'last_name=Doe' \
  https://staging.particulier.api.gouv.fr/v1/dgfip/impots
```

L'ensemble des routes sont listé à la racine du dossier [payloads](./payloads)

A noter qu'il est possible de mettre n'importe quel status hormis celui associé
aux paramètres invalides:

* Pour API Entreprise: 422
* Pour API Particulier: 400

En effet, les paramètres d'entrées sont vérifiés directement par l'application,
ce qui garantie un comportement iso avec la production.

## Contribution

FEEDME

## Installation

### Dépendances

* ruby 3.2.0

```sh
bundle install
```

## Lancer la suite de tests pour vérifier les payloads

```sh
bundle exec rspec
```

## TODO

* Script de bootstrap de dossier pour un endpoint
* Exclure les 422 => c'est déjà
* Tester avec FranceConnect sur API Particulier
* Bootstrap un exemple avec API Entreprise v3
* Vérifier qu'il n'y a pas de doublons dans les params
