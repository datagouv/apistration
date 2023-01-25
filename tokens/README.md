# Jetons

Ce dossier contient des jetons valide pour l'environnement de staging.

## Génération d'un nouveau jeton

Vous pouvez utiliser `bin/generate_token.rb` de la manière suivante:

```sh
# Pour générer un jeton avec tous les scopes
bundle exec ruby bin/generate_token.rb

# Pour générer un jeton avec certains scopes
bundle exec ruby bin/generate_token.rb scope1 scope2 scope3
```

## Liste (non exhaustive)

* [default](./default) : jeton avec tous les droits
