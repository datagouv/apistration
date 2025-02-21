# Tests des endpoints et pings

## Endpoints

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

## Pings

```sh
bundle exec rails runner bin/test_pings.rb
```
