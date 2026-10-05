# SIADE : Système d'Information des API de l'État [![CI](https://github.com/etalab/siade/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/etalab/siade/actions/workflows/ci.yml)

API pour API Entreprise et API Particulier

## Requirements

- ruby 4.0.1
- postgresql >= 9
- redis-server >= 5
- gnugpg and gpgme (installed with script below)

## Install

```sh
./bin/install.sh
```

Pour seed la base:

```sh
./bin/seeds.sh
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

## Static security

[brakeman](https://github.com/presidentbeef/brakeman) est installé. Pour
vérifier le code comme le fait la CI :

```sh
./bin/brakeman
```

La commande échoue (code de sortie non nul) dès qu'un warning n'est pas
ignoré ou qu'une entrée de `config/brakeman.ignore` est devenue obsolète.

Pour ignorer un faux positif, lancer le mode interactif, qui met à jour
`config/brakeman.ignore` ; renseigner une note expliquant pourquoi le
warning est sans risque :

```sh
./bin/brakeman_ignore
```

## Code Coverage

Celui-ci est automatiquement généré à chaque push, et est publié sur gitlab
pages pour la branche develop.

Pour générer un code coverage en local:

```sh
COVERAGE=true bundle exec rspec
```

## Documentation

La documentation se trouve dans le dossier [docs/](docs/).

Notamment pour l'édition du swagger, voir le fichier [docs/development/edition_swagger.md](docs/development/edition_swagger.md)
