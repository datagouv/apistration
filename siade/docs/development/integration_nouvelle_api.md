# Intégration d'une nouvelle API

Afin de faciliter la création d'une nouvelle API dans la philosophie 'v3'
il existe un générateur qui créer l'ensemble des fichiers nécessaires.
Pour les options et fichiers générés, voir :

`bundle exec rails generate scaffold_resource --help`

Si l'API n'est pas encore prête à être développée, la commande précédente peut être appellée
avec l'option `--prochainement`. Cela crée un squelette pour la prochaine API et permet de
la documenter dans le fichier OpenAPI.
Il faut bien se rapeller de rajouter le tag `Prochainement` dans le swagger de l'API.

