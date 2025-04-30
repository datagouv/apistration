# Gestion des erreurs

L'ensemble des erreurs renvoyées via l'API se situent dans le dossier
`app/errors`.

Les erreurs sont renvoyées au format 'flat' dans la v2 de API Particulier et au format [JSON API Error](https://jsonapi.org/format/#errors) dans la v3 de Particulier et Entreprise.

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
