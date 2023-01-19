# Dépôt de données de tests pour API Particulier / API Entreprise

# ⚠️ Il s'agit encore d'un dépôt en chantier, rien n'est actuellement fonctionnel ⚠️

Ce dépôt contient l'ensemble des données de tests pour les environnements de bac
à sable d'API Entreprise ( https://staging.entreprise.api.gouv.fr ) et d'API
Particulier ( https://staging.entreprise.api.gouv.fr )

## Fonctionnement

L'ensemble des payloads de réponses se trouvent dans le dossier `payloads/`.
Chaque endpoint possède son propre dossier au sein de son api sous cette forme:

```
api_entreprise/path_to_payload_with_{param}
api_particulier/path_to_payload_with_{param}
```

Chaque dossier possède un README.md ainsi que des fichiers YAML ayant le format
suivant:

```yaml
---
params:
  first_name: ‘John’
  last_name: ‘Doe’
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

