# Intégration d'une nouvelle API

## Génération des fichiers

Afin de faciliter la création d'une nouvelle API dans la philosophie 'v3'
il existe un générateur qui créer l'ensemble des fichiers nécessaires.
Pour les options et fichiers générés, voir :

`bundle exec rails generate scaffold_resource --help`

Si l'API n'est pas encore prête à être développée, la commande précédente peut être appellée avec l'option `--prochainement`. Cela crée un squelette pour la prochaine API et permet de la documenter dans le fichier OpenAPI.
⚠️Il faut bien se rapeller de rajouter le tag `Prochainement` dans le swagger de l'API.

Quand l'API est prête à rentrer en production, vous pouvez relancer la commande sans l'option `--prochainement`, attention à :
1/ Ne pas écraser les fichiers existants
2/ Bien modifier le MakeRequest pour ne plus hériter de MockedInteractor

## État du mode prochainement

Exemple de generation pour un endpoint API Particulier en mode prochainement, avec civilité et franceconnect :
`rails g scaffold_resource Provider::MyResource --api-kind=particulier --validation-type=civility --with-france-connect=true --prochainement=true`

(Provider est habituellement un acronyme, donc en majuscules)

En mode prochainement, vous pouvez déjà développer la validation des paramètres, les controllers, les fichier RSwag de test de requête (à l'exception d'au moins la réponse 200 et 404 qu'il faudra laisser en `pending`, possiblement davantage de cas selon le provider).

Le serializer peut être développé si vous connaissez déjà la réponse attendue de l'endpoint (et que les scopes sont définis dans le cas d'API Particulier)

Selon la documentation disponible du provider, et si l'analyse de l'API provider a été déjà effectuée, vous pouvez aussi possiblement développer aussi les interactors MakeRequest, BuildResource, ValidateResponse.

## Données du swagger

Créer le fichier `config/swagger_data/<provider>.yml` (voir section doc correspondante)
Lancer `bin/generate_swagger.sh` incluera l'API en mode prochainement dans le fichier OpenAPI correspondant.

## Nouveau provider

Bien ajouter le provider dans les fichiers suivants:

- `config/initializers/inflections.rb` si le provider est un acronyme
- `app/services/errors_backend.rb` pour les subcodes d'erreurs

## Options à ajouter manuellement

à répéter autant de fois que de modalités d'appels sont intégrées (ex: civilité + franceconnect) :

- Ajouter la ou les routes adéquates.
- Ajouter les scopes dans le fichier `config/authorizations.yml`.
- Ajouter le(s) throttles adéquat dans le fichier `config/throttles.yml`.

## Autres tâches à effectuer plus tard

- Config de ping dans `config/ping.yml`.
- Ajout du test case dans `config/endpoints_with_test_case.yml`.
