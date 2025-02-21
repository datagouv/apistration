# Génération d'un nouveau JWT token

Dans le cas où vous êtes amené à régénérer un token JWT, vous pouvez utiliser la
commande suivante:

```sh
ruby bin/generate_jwt_token.rb environment
```

Avec `environment` un environnement valide.
/!\ Attention: Un jeton de sandbox est valide sur la sandbox qui peut récupérer
des données de production. Il doit donc être traité avec les mêmes mesures de sécurité
qu'un jeton de production.

## Cas de l'environnement de test

Dans le cadre des tests (lors de l'ajout d'un nouveau rôle), le script récupère
automagiquement les rôles depuis les controllers, vous pouvez modifier le
script pour ajouter le rôle à la main dans la variable `extra_scopes`.

Il vous suffit à la fin de prendre la valeur générée et remplacer dans le
fichier [jwt_helper.rb](spec/support/helpers/jwt_helper.rb) dans la méthode
`jwt` à la clé `valid` avec la bonne valeur.

N'oubliez pas non plus d'ajouter le nouveau rôle dans la méthode
`values_for_valid_jwt`
