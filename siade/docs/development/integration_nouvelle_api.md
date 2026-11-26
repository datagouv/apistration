# Intégration d'une nouvelle API

Avant de concevoir l'endpoint, lire les
[règles de conception](regles_de_conception.md).

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
3/ Ajouter le ping et le test case, obligatoires (voir [Sortie en production](#sortie-en-production--ping-et-test-case))

## État du mode prochainement

Exemple de generation pour un endpoint API Particulier en mode prochainement, avec civilité et franceconnect :
`rails g scaffold_resource Provider::MyResource --api-kind=particulier --validation-type=civility --with-france-connect=true --prochainement=true`

(Provider est habituellement un acronyme, donc en majuscules)

En mode prochainement, vous pouvez déjà développer la validation des paramètres, les controllers, les fichier RSwag de test de requête (à l'exception d'au moins la réponse 200 et 404 qu'il faudra laisser en `pending`, possiblement davantage de cas selon le provider).

La signature de l'endpoint (paramètres, format de réponse) ne se fige qu'à partir du swagger ou du contrat d'interface du fournisseur. Sans l'un ni l'autre, la description de la PR indique que la signature est provisoire, et le PO décide avant qu'elle soit figée : une signature figée sans source se corrige ensuite par une nouvelle version.

Le serializer peut être développé si vous connaissez déjà la réponse attendue de l'endpoint (et que les scopes sont définis dans le cas d'API Particulier)

Selon la documentation disponible du provider, et si l'analyse de l'API provider a été déjà effectuée, vous pouvez aussi possiblement développer aussi les interactors MakeRequest, BuildResource, ValidateResponse.

## Données du swagger

Ajouter les données swagger dans le fichier endpoint `commons/endpoints/api_*/` ou dans `commons/endpoints/_swagger_shared/<provider>.yml` (voir section doc correspondante)
Lancer `bin/generate_swagger.sh` incluera l'API en mode prochainement dans le fichier OpenAPI correspondant.

## Nouveau provider

Bien ajouter le provider dans les fichiers suivants:

- `config/initializers/inflections.rb` si le provider est un acronyme
- `app/services/errors_backend.rb` pour les subcodes d'erreurs

## Options à ajouter manuellement

à répéter autant de fois que de modalités d'appels sont intégrées (ex: civilité + franceconnect) :

- Ajouter la ou les routes adéquates.
- Ajouter les scopes dans le fichier `commons/data/authorizations.yml` (à la racine du dépôt).
- Ajouter le(s) throttles adéquat dans le fichier `config/throttles.yml`.

## Sortie en production : ping et test case

Un endpoint ne sort pas du mode prochainement sans son ping : sans lui,
pas de status page ni d'alerte quand le fournisseur tombe.

- Ajouter une entrée dans `commons/pings.yml` (symlinké en
  `config/pings.yml` dans `siade/` et `site/`), sous `shared.api_entreprise`
  ou `shared.api_particulier`. Un ping qui couvre déjà le même
  fournisseur et la même route peut être réutilisé.
- Le ping d'un driver `retriever` ou `make_request` appelle réellement le
  fournisseur : son identifiant de test doit exister en production et
  donner une réponse rapide et légère (peu de données, pas de document).
  Le valider en production avant de l'inscrire.
- Renseigner `ping_url` dans la fiche `commons/endpoints/` :
  `https://entreprise.api.gouv.fr/ping/<clé>` ou
  `https://particulier.api.gouv.fr/api/<clé>/ping`.
- Vérifier une fois déployé : `bundle exec rails runner bin/test_pings.rb`.
- Ajouter le test case dans `config/endpoints_with_test_case.yml`.

Deux specs le vérifient en CI :

- `site/spec/endpoint_ping_urls_consistency_spec.rb` échoue quand une
  fiche qui n'est ni en prochainement (tag `Prochainement` du swagger) ni
  dépréciée n'a pas de `ping_url`, ou quand un `ping_url` vise une clé
  absente de `pings.yml`. Les endpoints déjà en production sans ping y
  sont listés : la liste ne doit que diminuer ;
- `spec/acceptances/endpoints_with_test_case_spec.rb` échoue quand un
  endpoint API Entreprise hors prochainement n'a pas de test case.

Aucune ne vérifie que l'identifiant du ping est réel et léger : c'est au
relecteur de la PR de sortie du mode prochainement.
