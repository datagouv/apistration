# SIADE : Système d'Information des API de l'État [![CI](https://github.com/etalab/siade/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/etalab/siade/actions/workflows/ci.yml)

## Requirements

* ruby 3.2.1
* postgresql >= 9
* redis-server >= 5
* gnugpg and gpgme (installed with script below)

## Install

```sh
./bin/install.sh
```

## Tests

Par défaut:

```sh
rspec
```

Avec le coverage:

```sh
COVERAGE=true rspec
```

Si vous rencontrez des problèmes de matching sur les cassettes VCR, vous pouvez
obtenir plus de logs de la manière suivante:

```sh
DEBUG_VCR=true rspec
```

### Avertissements sur les cas de tests

Il n'est pas possible de mettre de données personnelles dans les tests, soit le
fournisseur de données a un environnement de test soit il faut utiliser webmock
et non VCR.

## Utilisation et edition des credentials

Avant toute chose, lisez la partie sur la gestion des credentials chiffré dans
la [doc officielle de
Rails](https://edgeguides.rubyonrails.org/security.html#environmental-security)

Les credentials sont séparés en 3 fichiers:

1. Pour les machines de production, qui regroupent les environnements
   `production`, `staging` et `sandbox`
2. Un fichier pour le développement
3. Un fichier pour les tests

Le format des fichiers sont les suivants:

```yaml
# environment == production, sandbox, development ...
environment:
  key: value
```

En effet étant donné que les apps partagent pas mal de credentials en commun,
c'est une manière simple de partager les données entre des environments
similaire.

Nous avons donc pour les machines de production le fichier
`config/credentials.yml.enc`, dont la master key (à placer dans
`config/master.key`) est chiffré dans le dépôt very_ansible

Vous pouvez utiliser le script `./bin/retrieve_master_key.sh` pour importer
automatiquement la clé.

Pour éditer les credentials des machines de production:

```sh
rails credentials:edit
```

Pour test et development, il y a en réalité 1 seul fichier et un lien symbolique
de development vers test. A noter que la master key est ici versionnée (car les
données sont non sensibles)

Pour éditer les credentials de dev/test:

```sh
rails credentials:edit --environment development
```

**Il ne faut absolument pas mettre de véritable credentials dans ce fichier,
uniquement dans ceux de productions**

### D'où viennent les credentials

Certains credentials ont été transmis par email ou autre, mais tous les accès qui
sont récupérable depuis Internet doivent être documenté avec un commentaire

- l'URL pour se connecter au service qui sert à récupérer les credentials ;
- l'email/idenfiant pour se connecter

Pour l'email il faut privilégier integration-bouquet-api@api.gouv.fr qui est une
redirection vers une adresse de notre choix (depuis [OVH](https://www.ovh.com/manager/#/web/email_domain/api.gouv.fr/email/redirection)).
Seule la personne spécifiée dans OVH peut théoriquement accéder à l'interface,
si besoin faire une récupération de mot de passe.

## Déploiement sur les serveurs

```sh
./bin/deploy
```

Dans le cas d'un test sur sandbox de watchdoge1 avec la branche `features/whatever`

```sh
ssh -A watchdoge1 -- /usr/local/bin/rails_deploy_siade_sandbox.sh features/whatever
```

## Code Coverage

Celui-ci est automatiquement généré à chaque push, et est publié sur gitlab
pages pour la branche develop.

Pour générer un code coverage en local:

    $ COVERAGE=true bundle exec rspec

## Édition du Swagger

Vous pouvez tester votre fichier Swagger à l'aide de l'éditeur disponible en
ligne à l'adresse suivante: [Swagger Editor](https://editor.swagger.io/)

Le fichier OpenAPI peut être régénéré avec la commande:

    bin/generate_swagger.sh

## Génération d'un nouveau JWT token

Dans le cas où vous êtes amené à régénérer un token JWT, vous pouvez utiliser la
commande suivante:

```sh
ruby bin/generate_jwt_token.rb environment
```

Avec `environment` un environnement valide.
/!\ Attention: Un jeton de sandbox est valide sur la sandbox qui peut récupérer
des données de production. Il doit donc être traité avec les mêmes mesures de sécurité
qu'un jeton de production.

### Cas de l'environnement de test

Dans le cadre des tests (lors de l'ajout d'un nouveau rôle), le script récupère
automagiquement les rôles depuis les controllers, vous pouvez modifier le
script pour ajouter le rôle à la main dans la variable `extra_scopes`.

Il vous suffit à la fin de prendre la valeur générée et remplacer dans le
fichier [jwt_helper.rb](spec/support/helpers/jwt_helper.rb) dans la méthode
`jwt` à la clé `valid` avec la bonne valeur.

N'oubliez pas non plus d'ajouter le nouveau rôle dans la méthode
`values_for_valid_jwt`

## Création d'un rôle d'accès à un nouvel endpoint

Lors de l'ajout d'une nouvelle API il faut (quasiment à chque fois) ajouter un
nouveau rôle d'accès à ladie ressource.

1.  Dans SIADE, créer une nouvelle policy Pundit avec le tag associé ; le tag
    est passé à la méthode `authorize` dans le controller `authorize :new_scope` ;
2.  Créer le nouveau rôle dans les API Admin : se connecter au
    [dashboard](https://dashboard.entreprise.api.gouv.fr/login) et créer le rôle
    (depuis le menu adéquat sur la gauche).
    Le "code" doit être indentique au tag Pundit utilisé dans SIADE ;
3.  Communiquer le code/tag à DataPass afin qu'ils mettent le formulaire de
    demande d'accès à jour

## Test des endpoints

Vous pouvez utiliser le script suivant: `./bin/test_endpoints.rb` de la
manière suivante:

```sh
bundle exec ruby bin/test_endpoints.rb [-h host] [-i id1,id2] [--api api]
```

Avec:

- `host`, optionnel, host du backend à tester. Exemple:
  `https://production2.entreprise.api.gouv.fr`
- `id1,id2`, optionnel, index du endpoint à faire tourner. Ceci permet de
  juste faire tourner un certain nombre de endpoints. Exemple: 3,14
- `api`, optionnel, 'entreprise' ou 'particulier'

Si vous obtenez une erreur de jeton invalide, vous pouvez en régénérer un avec
le script `bin/generate_jwt_token.rb` (documenté plus haut)

## Test des pings

```sh
bundle exec rails runner bin/test_pings.rb
```

## Création d'une nouvelle API

Afin de faciliter la création d'une nouvelle API dans la philosophie 'v3'
il existe un générateur qui créer l'ensemble des fichiers nécessaires.
Pour les options et fichiers générés, voir :

`bundle exec rails generate scaffold_resource --help`

Si l'API n'est pas encore prête à être développée, la commande précédente peut être appellée
avec l'option `--prochainement`. Cela crée un squelette pour la prochaine API et permet de
la documenter dans le fichier OpenAPI.
Il faut bien se rapeller de rajouter le tag `Prochainement` dans le swagger de l'API.

## Fonctionnement du staging

En staging, aucun appel aux FDs n'est effectué: un système de bouchonnage est
mis en place et se comporte de manière différente en fonction des endpoints
appelés:

### API Particulier et API Entreprise v3+

De part l'utilisation de la nouvelle stack d'API à base d'organizer, le système
intecepte au sein de la classe `MakeRequest` (classe mère qui effectue tous les
appels externes) tous les appels et les forward au service
[`MockService`](./app/services/mock_service.rb).

Ce service tente séquentiellement:

1. De trouver une payload correspondante via `MockDataBackend` ;
2. De générer une réponse à l'aide du fichier OpenAPI.

Pour 1., `MockDataBackend` utilise l'identifiant `operation_id` (générer à
l'aide du chemin du controller) ainsi que les paramètres d'appel afin
d'identifier dans le dépôt [siade\_staging\_data](https://github.com/etalab/siade_staging_data)
la payload correspondante.

Par exemple pour le endpoint `/v2/etudiants` de API Particulier, avec en
paramètres `ine=1234567890G`, la réponse renvoyée correspond à cette
[payload](https://github.com/etalab/siade_staging_data/blob/develop/payloads/api_particulier_v2_mesri_student_status/ine.yaml)

Il est possible via ce système de simuler des réponses (couple `(status, payload)`)
différentes en fonction des paramètres.

Si aucune payload n'est trouvée, le système fallback sur 2.

A noter que les classes `ValidateResponse` et `BuildResource`, ainsi que la
serialisation sont bypassé.

Le comportement reste inchangé pour:

- La vérification du jeton ;
- La vérification des paramètres d'entrées.

### Uptime / pings

On renvoi une réponse vide avec le status 200

### API Entreprise v2 (ancien comportement)

Les payloads renvoyées sont générées à l'aide du fichier swagger.
Plus d'infos dans le code de
[`InterceptWithOpenAPIMockedPayloadInStaging`](app/controllers/concerns/intercept_with_open_api_mocked_payload_in_staging.rb)

## Documentation

### Monitoring des erreurs des fournisseurs de données

La documentation relative à cette gestion (implémentation technique, doctrine
et les notifications Sentry) se trouve ici: [Monitoring des
erreurs](https://3.basecamp.com/4318089/buckets/14298426/vaults/3437220238)

### Gestion des erreurs

L'ensemble des erreurs renvoyées via l'API se situent dans le dossier
`app/errors`.

Dans l'optique de faire vivre les erreurs dans la v2 et la v3, chaque erreur
possède 2 implémentations : une flat et une sous la forme d'un [JSON API
Error](https://jsonapi.org/format/#errors), actionnable dans la v2 avec le
paramètre en query `error_format=json_api`.

Chaque erreur doit hériter de la classe
[`ApplicationError`](./app/errors/application_error.rb), qui permet d'aller
chercher la définition des erreurs dans un fichier de configuration :
[`config/errors.yml`](./config/errors.yml).

On distingue ensuite 3 typologie d'erreurs:

1. Les erreurs spécifiques à API Entreprise, qui implémentent basiquement
   l'interface de `ApplicationError`
1. Les erreurs communes à chaque fournisseurs de données, qui implémentent
   l'interface de
   [`AbstractGenericProviderError`](./app/errors/abstract_generic_provider_error.rb)
   et qui permet, à l'aide d'un sous-code, de sortir les informations
1. Les erreurs spécifiques aux fournisseurs de données, qui implémentent
   l'interface de
   [`AbstractSpecificProviderError`](./app/errors/abstract_specific_provider_error.rb)

L'objectif est de garder le maximum d'informations dans le fichier de config,
tout en gardant les interfaces dans le code compréhensible (i.e. sans avoir à
aller ouvrir le fichier de config pour comprendre l'erreur).

L'explication de la nomenclature des codes erreurs se trouve dans le fichier
[Nomenclature codes erreurs API Entreprise](./nomenclature-errors.md)

### Gestion des maintenances des fournisseurs de données

Certains fournisseurs de données sont en maintenance applicatives de manière
journalières, d'autres annonces des maintenances de manières ponctuelles.

Il est possible de gérer applicativement ces 2 types de maintenances dans SIADE et renvoyer
aux utilisateurs des erreurs spécifiques à ces maintenances (avec les dates, et
quand est-ce que la maintenance s'arrête).

La configuration s'effectue dans le fichier
[maintenances.yml](./config/maintenances.yml) sous la clé `production`.

La liste exacte des fournisseurs se trouve dans le fichier
[nomenclature-errors](./nomenclature-errors.md)

### Format des payloads

Les payloads suivent systématiquement le même format qui suit la logique REST.
Celle-ci est fortement inspirée de [JSON:API](https://jsonapi.org/)

Pour une resource seule:

```json
{
  "data": {
    "attribute1": "value1",
    "attribute2": "value2",
    "nested_attribute": {
      "nested_attribue1": "nested_value1"
    }
  },
  "links": {
    "name": "https://whatever.com"
  },
  "meta": {
    "meta1": "meta_value1"
  }
}
```

Les clés `data`, `links` et `meta` sont systématiquement présentes et sont
forcément un objet. (à minima l'objet vide `{}`)

Pour une collection:

```json
{
  "data": [
    {
      "attribute1": "value1",
      "attribute2": "value2",
      "nested_attribute": {
        "nested_attribue1": "nested_value1"
      }
    }
  ],
  "links": {
    "name": "https://whatever.com"
  },
  "meta": {
    "meta1": "meta_value1"
  }
}
```

La clé `data` est un tableau de données. Les 3 clés sont aussi systématiquement
présentes. A noter que `links` et `meta` s'appliquent à l'ensemble de la collection.

Pour des erreurs:

```json
{
  "errors": [
    {
      "code": "00304",
      "title": "Entité non traitable",
      "detail": "Le numéro de siret ou le numéro EORI n'est pas correctement formatté",
      "source": {
        "parameter": "id"
      }
    }
  ]
}
```

Chaque entrée du tableau `errors` possède comme attributs:

- `code`, `string`: code correspondant à la table de correspondance
- `title`, `string`: nom associé au code (fixe en fonction du code)
- `detail`, `string`: description exhaustive associée à l'erreur

### Gestion des scopes de jetons

L'ensemble des scopes sont regroupé dans le fichier
[`config/authorizations.yml`](./config/authorizations.yml).

Le format est le suivant:

```yaml
endpoint_path_without_controller:
  - scope1
  - scope2
```

### Debug de requêtes

Il est possible de sauvegarder dans un fichier de log temporaire
`log/requests_debugger.log` les appels HTTP en 200 et 404 afin d'effectuer des
investigation sur des bugs.

Le fichier de configuration se trouve dans [config/requests_debugging.yml](config/requests_debugging.yml)
et permet:

* D'activer / désactiver le monitoring à l'aide d'une date `enabled_until` ;
* De lister les opérations monitorées (pour une liste exhaustive, cherchez
    `x-operationId` dans les fichiers swaggers)

Il y a de même un filtrage sur les status, qui exclut principalement les erreurs
clients (401, 403, 422)

## Liste des API où on est whitelistés

Pour accéder à certaines API nos IP ont été mises sur liste blanche / whitelist.

API Entreprise :
* Banque de France ;
* GIP-MDS ;
* EORI ;
* MSA

API Particulier :
* FranceConnect ;
* Quotient Familial v2 ;
* Complémentaire Santé Solidaire

Les contacts peuvent être trouvés dans le CRM.
