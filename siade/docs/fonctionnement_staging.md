# Fonctionnement du staging

En staging, aucun appel aux FDs n'est effectué: un système de bouchonnage est
mis en place et se comporte de manière différente en fonction des endpoints
appelés:

## API Particulier et API Entreprise v3+

De part l'utilisation de la nouvelle stack d'API à base d'organizer, le système
intecepte au sein de la classe `MakeRequest` (classe mère qui effectue tous les
appels externes) tous les appels et les forward au service
[`MockService`](./app/services/mock_service.rb).

Ce service tente séquentiellement:

1. De trouver une payload correspondante via `MockDataBackend` ;
2. De générer une réponse à l'aide du fichier OpenAPI.

Pour 1., `MockDataBackend` utilise l'identifiant `operation_id` (générer à
l'aide du chemin du controller) ainsi que les paramètres d'appel afin
d'identifier dans le dépôt [apistration](https://github.com/datagouv/apistration/tree/develop/mocks)
la payload correspondante.

Par exemple pour le endpoint `/v2/etudiants` de API Particulier, avec en
paramètres `ine=1234567890G`, la réponse renvoyée correspond à cette
[payload](https://github.com/datagouv/apistration/blob/develop/mocks/payloads/api_particulier_v2_mesri_student_status/ine.yaml)

Il est possible via ce système de simuler des réponses (couple `(status, payload)`)
différentes en fonction des paramètres.

Si aucune payload n'est trouvée, le système fallback sur 2.

A noter que les classes `ValidateResponse` et `BuildResource`, ainsi que la
serialisation sont bypassé.

Le comportement reste inchangé pour:

- La vérification du jeton ;
- La vérification des paramètres d'entrées.

## Uptime / pings

On renvoi une réponse vide avec le status 200

## Tests en local

```sh
# Pour récupérer le jeton GitHub
rails credentials:show --environment staging | grep github_personal_access_token
# Pour générer un jeton en local
bundle exec ruby bin/generate_jwt_token.rb development > .token.development
STAGING=true GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxx rails s
```

Puis copiez les urls sur le dépôt et remplacer l'url de base par
`http://entreprise.api.localtest.me:3000` ou
`http://particulier.api.localtest.me:3000`

Exemple:

```
token=`cat .token.development`
curl -H "Authorization: Bearer $token" \
  -G -d 'recipient=13002526500013' \
  -d 'what=ever' \
  --url "http://particulier.api.localtest.me:3000/v3/what/ever/identite"
```
