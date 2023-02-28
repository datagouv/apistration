# Dépôt de données de tests pour API Entreprise v3+ & API Particulier

[![Tests](https://github.com/etalab/siade_staging_data/actions/workflows/tests.yml/badge.svg)](https://github.com/etalab/siade_staging_data/actions/workflows/tests.yml)

* [Fonctionnement](#fonctionnement)
  * [Cas de FranceConnect](#cas-de-franceconnect)
* [Contribution](#contribution)
* [Développement](#developpement)
  * [Installation en local](#installation-en-local)
  * [Lancer la suite de tests pour vérifier les payloads](#lancer-la-suite-de-tests-pour-vérifier-les-payloads)
  * [Génerer un jeton](#générer-un-jeton)
  * [Ajout d'un nouvel endpoint](#ajout-dun-nouvel-endpoint)
  * [Déploiement des données](#déploiement-des-données)
* [Limitations](#limitations)

Ce dépôt contient l'ensemble des données de tests pour les environnements de bac
à sable d'API Entreprise (seulement pour la v3+)
( https://staging.entreprise.api.gouv.fr ) et d'API
Particulier ( https://staging.entreprise.api.gouv.fr )

## Fonctionnement

Les payloads de réponses se trouvent dans le dossier `payloads/`.
Chaque endpoint possède son propre dossier sous l'une de ces formes :

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
racine du dossier payload : [README.md](./payloads/README.md) (généré
automatiquement par `bin/generate_payload_readme.rb`)

Chaque dossier possède un README.md ainsi que des fichiers YAML ayant le format
suivant :

```yaml
---
params:
  first_name: 'John'
  last_name: 'Doe'
status: 200
payload: |-
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
  -H 'X-Api-Key: TOKEN' \
  -G -d 'first_name=John' -d 'last_name=Doe' \
  https://staging.particulier.api.gouv.fr/v1/dgfip/impots
```

Pour le cas d'API Entreprise:

```sh
curl -X GET \
  -H 'Authorization: Bearer TOKEN' \
  -G -d 'first_name=John' -d 'last_name=Doe' \
  https://staging.entreprise.api.gouv.fr/v1/dgfip/impots
```

Les routes sont listées à la racine du dossier [payloads](./payloads)

À noter qu'il est possible de mettre n'importe quel status (valide), hormis ceux
associés aux paramètres invalides et au jeton invalide:
* Pour API Entreprise: `422` et `403` ;
* Pour API Particulier: `400` et `401`.

En effet, les paramètres d'entrées sont vérifiés directement par l'application,
ce qui garantie un comportement iso avec la production.

### Cas de FranceConnect

Certains endpoints d'API Particulier sont FranceConnectés : cela implique que
l'on peut passer un jeton FranceConnect à la place des paramètres classiques
afin d'effectuer un appel auprès des fournisseurs de données. À l'aide du jeton
FranceConnect, l'API effectue un appel auprès de FranceConnect pour récupérer
des données de civilité (un exemple [ici](./payloads/france_connect/default.yaml)),
données qui sont ensuite formatées pour effectuer un appel auprès du fournisseur
de données correspondant.

Les données de tests de FranceConnect se trouvent dans le dossier
[payloads/france_connect/](payloads/france_connect/)

Il est possible dans ce dépôt de faire un mapping jeton <-> données
FranceConnect, et derrière faire un mapping Données FranceConnect <-> réponse de
l'API.

Par exemple pour `api/v2/etudiants-boursiers`:

1. Un mapping valide pour FranceConnect: [payloads/france_connect/cnous.yaml](./payloads/france_connect/cnous.yaml) ;
2. Un mapping pour `api/v2/etudiants-boursiers` qui prend exactement les
   paramètres d'identité renvoyés par le fichier ci-dessus:
   [payloads/api_particulier_v2_cnous_student_scholarship/franceconnect_cnous.yml](./payloads/api_particulier_v2_cnous_student_scholarship/france_connect_cnous.yml).

Ainsi, l'appel suivant renverra in-fine la réponse définie en 2. :

```sh
curl -X GET \
  -H "Authorization: Bearer cnous" \
  https://staging.particulier.api.gouv.fr/api/v2/etudiants-boursiers
```

Le jeton `cnous` correspond à la valeur du paramètre `token` dans le fichier de
définition de FranceConnect.

À noter que les scopes renvoyés par FranceConnect permettent de construire la
réponse adéquate : si les scopes nécessaires pour renvoyer la réponse ne sont pas
présents l'API renverra une `401`.

Attention, il y a une divergence entre la production et le staging sur les
champs renvoyés : l'API en production effectue un filtrage des champs en fonction
des scopes. Par exemple ici si `cnous_email` est absent des scopes, l'API en
production retira le champ `email` de la réponse. Ce comportement n'existe pas
en staging, l'API renverra la payload définie dans le fichier de ce dépôt sans
aucun filtrage.

Pour contourner ce problème, il faut retirer les champs de la payload finale.
Vous pouvez vous référer à l'exemple
[payloads/api_particulier_v2_cnous_student_scholarship/franceconnect_cnous_with_less_scopes.yml](./payloads/api_particulier_v2_cnous_student_scholarship/franceconnect_cnous_with_less_scopes.yml),
où les clés `nom`, `prenom`, `prenom2`, `dateNaissance`, `lieuNaissance`, `sexe`
ont été omises.

Plusieurs exemples existent pour tous les endpoints FranceConnectés dans le
dossier [france_connect](./payloads/france_connect/), avec une description
indiquant la réponse associée sur le fournisseur de données.

## Déploiement des données

Lorsque des nouvelles données sont poussées sur la branche `develop`, le système
effectue des vérifications sur la cohérence à l'aide d'une suite de tests
automatisés. Si tout est OK, le système notifie l'API afin que celle-ci prenne
en compte les nouvelles données.

En cas de problème, il est possible d'effectuer une recharge des données en
lançant la commande suivante :

```sh
bundle exec ruby bin/reload_mock_backend.rb
```

## Contribution

Si vous êtes développeur, référez-vous à la section [Développement](#developpement) ci-dessous.

Si ce n'est pas le cas, il y a deux cas de figures:

1. Le dossier associé au endpoint que vous voulez n'existe pas : ouvrez un
   ticket pour que l'on vous accompagne sur l'implémentation : [Ajout d'un
   endpoint manquant](https://github.com/etalab/siade_staging_data/issues/new?template=proposer-une-am-lioration.md)
2. Le dossier existe :
   1. Soit vous pouvez tenter d'ajouter vous-même les fichiers que vous voulez à
      l'aide d'une pull request ;
   2. Soit vous ouvrez un ticket pour que l'on vous accompagne sur
      l'implémentation : [Ajout de nouvelles données](https://github.com/etalab/siade_staging_data/issues/new?template=ajout-payloads.md).

## Développement

### Installation en local

#### Dépendances

* ruby 3.2.0

```sh
bundle install
```

### Lancer la suite de tests pour vérifier les payloads

```sh
bundle exec rspec
```

### Générer un jeton

Référez-vous à [tokens/](./tokens)

### Ajout d'un nouvel endpoint

1. Identifier l'operation_id (dans les fichiers swaggers: `x-operationId`) ;
2. Executer la commande : `bundle exec ruby bin/bootstrap_payload.rb
   operation_id` ;
3. La commande crée un dossier avec un `default.yaml` que vous devez adapter pour
   que la suite de tests passe (cf plus bas).

## Limitations

* Pour API Particulier, si un jeton ne possède pas l'ensemble des scopes pour
  un fournisseur de données, l'environnement de test ignore le filtrage sur ces
  scopes (contrairement à la production qui filtre en fonction des scopes).

  Par exemple, si votre jeton possède l'ensemble des autorisations pour
  `/v2/etudiants-boursiers` sauf celle de récupérer l'e-mail (`cnous_email`), la
  production retirera le champ `email` de la réponse, mais pas l'environnement
  de test.

  Pour palier ce problème, le plus simple reste de créer une réponse spécifique
  avec moins de champ.
* Pour les endpoints qui ne sont pas encore présents dans ce dépôt, des
  ajustements techniques vis-à-vis des paramètres à prendre en compte peuvent
  être nécessaires.

Si ces limitations sont problématiques pour votre développement et intégration,
nous vous invitons à [ouvrir un ticket](https://github.com/etalab/siade_staging_data/issues/new).
