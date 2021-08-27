# Documentation

La documentation est séparée et se trouve sur doc.entreprise.api.gouv.fr

## Setup Dev environment

    $ rake dev:init

Il est nécessaire d'avoir Redis d'installé pour l'environnement de dévelopment
(pas nécessaire pour les tests)

Le package *QPDF* doit par ailleurs être installé.  Exemple sur Ubuntu :

```sh
sudo apt-get install qpdf
```

De même pour `libmagic-dev`:

```sh
sudo apt-get install libmagic-dev
```

## Utilisation et edition des credentials

### Une vue rapide d'ensemble
Par defaut 2 fichiers : un fichier encrypte, ainsi qu'une cle ne devant pas etre
versionnee. En ce qui nous concerne, la clef est disponible dans le repertoire
`very_ansible`, sous dossiers 'secrets'. Il faut disposer du mot de passe ansible
pour dechiffrer le fichier a l'aide de `ansible-vault`

Cela donne :
* fichier de credentials par defaut `config/credentials.yml.enc' accompagne de
  sa clef `config/master.key`
* pour un `ENV` donne, respectivement `config/credentials/ENV.yml.enc' et
  `config/credentials/ENV.key`
* Possibilite de faire des liens symboliques pour eviter la duplication dans
  certains cas

Situation non "evidente" nous concernant :
* Credentials prod like regroupes dans les credentials par defaut, avec une
  master key commune aux 3 envs pour minimiser les erreurs de recopie d'un
  fichier a l'autre qui serait necessaire dans le cas d'un fichier par env.
* Credentials dev / test par env. Cela permet d'avoir une master key ne pouvant
  dechiffrer les credentials de prod pour notre env de CI. Nous pouvons
  egalement versionner la master key de dev / test sans risques.

### Editer, installer en savoir plus
L'edition se passe comme suit :
```sh
bin/rails credentials:edit # par defaut
bin/rails credentials:edit --environment ENV # pour l'environnement ENV
```

L'edition se fait a la ansible-vault, il faut un EDITOR connu par le shell. Pour
vim, `echo 'export EDITOR="vim"' >> ~/.bashrc; source ~/.bashrc` fera l'affaire si vous utilisez
le shell bash.

Plus d'infos en ligne de commande ici :

```sh
bin/rails credentials:help
```

## Déploiement sur les serveurs

    $ rake deploy to=<sandbox|staging|production>

Dans le cas d'un test sur sandbox avec la branche `features/whatever`

    $ bundle exec mina deploy domain=production.entreprise.api.gouv.fr branch=features/whatever to=sandbox

`domain` ici représente le domaine sur lequel vous voulez déployer votre
application. L'exemple ci-dessus pointe sur la machine frontale.

Les 3 valeurs possibles pour le domain:

*   production.entreprise.api.gouv.fr
*   production1.entreprise.api.gouv.fr
*   production2.entreprise.api.gouv.fr


La première représente la machine frontale (qui est soit la 2e soit la 3e).

## Debugging du Gitlab CI en local

Si vous rencontrez des difficultés à faire fonctionner le CI (pour X ou Y
raison), vous pouvez le faire tourner en local à l'aide de `gitlab-runner`.

Pour l'installation : [Install GitLab
Runner](https://docs.gitlab.com/runner/install/)

Il suffit ensuite de lancer avec la commande suivante:

    $ gitlab-runner exec docker test

## Code Coverage

Celui-ci est automatiquement généré à chaque push, et est publié sur gitlab
pages pour la branche develop.

Pour générer un code coverage en local:

    $ CODE_COVERAGE=true bundle exec rspec

## Édition du Swagger

Vous pouvez tester votre fichier Swagger à l'aide de l'éditeur disponible en
ligne à l'adresse suivante: [Swagger Editor](https://editor.swagger.io/)

## Génération d'un nouveau JWT token pour les tests

Dans le cas où vous êtes amené à régénérer un token JWT pour les tests (et
uniquement pour les tests, question de sécurité), vous pouvez passer par
[jwt.io](https://jwt.io/).

Récupérez la valeur du token valid (dans la méthode `jwt`) présent dans le
[jwt_helper.rb](spec/support/helpers/jwt_helper.rb), et copiez là dans
l'encard "Encoded" de jwt.io.

Dans l'encart "Verify Signature" de "Encoded", vous devez mettre la valeur du
jwt secret, celle-ci se trouve dans le fichier credentials sous la clé `jwt_hash_secret`

En théorie dans la partie "Decoded" vous retrouverez les informations
associées à ce token.

Vous pouvez maintenant modifier les informations de votre JWT dans l'encart
"Payload" de "Decoded".

Lorsque vous avez fini vos modifications, vous devez:

1.  Remplacer la valeur précédemment récupérée dans la clé `valid` par la
    nouvelle valeur dans l'encart "Encoded"
2.  Mettre à jour, dans la méthode `values_for_valid_jwt` du fichier
    `jwt_helper.rb`, les valeurs que vous avez modifié


## Création d'un rôle d'accès à un nouvel endpoint

Lors de l'ajout d'une nouvelle API il faut (quasiment à chque fois) ajouter un
nouveau rôle d'accès à ladie ressource.
1.  Dans SIADE, créer une nouvelle policy Pundit avec le tag associé ; le tag
    est passé à la méthode `authorize` dans le controller `authorize :new_role` ;
2.  Créer le nouveau rôle dans les API Admin : se connecter au
    [dashboard](https://dashboard.entreprise.api.gouv.fr/login) et créer le rôle
    (depuis le menu adéquat sur la gauche).
    Le "code" doit être indentique au tag Pundit utilisé dans SIADE ;
3.  Communiquer le code/tag à DataPass afin qu'ils mettent le formulaire de
    demande d'accès à jour


## Ajouter un nouvel endpoint au monitoring Uptime Robot

Il y a deux étapes pour ajouter un endpoint au monitoring Uptime Robot :
1. se connecter à l'interface et ajouter le nouvel endpoint sur le modèle des
   endpoints existant :
   * URL `https://entreprise.api.gouv.fr/v2/uptime`
   * avec un *query parameter* `route` contenant le path d'accès à la donnée
     (ex : route=/v2/ressource/siren)
   * et un *query parameter* `token` contenant le **token de monitoring**
     (disponible dans l'interface depuis les endpoints déjà monitoré ou dans le
     dashboard).
2. mettre à jour le jeton de ping *réel* utilisé pour réaliser les appels aux
   différents endpoints en background depuis le serveur (voir
   `app/controller/api/v2/uptime_controller.rb` pour la logique de monitoring
   sous jacente). Ce jeton est renseigné dans le fichier credentials.

/!\ Attention à ne renseigner qu'un JWT contenant le droit d'accès `uptime`
**uniquement**. Ce jeton est de fait public et ne doit en aucun cas avoir le
moindre droit d'accès aux données servies par API Entreprise !


## Test des endpoints

Vous pouvez utiliser le script suivant: `./bin/test_endpoints.rb` de la
manière suivante:

```sh
bundle exec ruby bin/test_endpoints.rb [host] [id1,id2]
```

Avec:

*   `host`, optionnel, host du backend à tester. Exemple:
    `https://production2.entreprise.api.gouv.fr`
*   `id1,id2`, optionnel, index du endpoint à faire tourner. Ceci permet de
    juste faire tourner un certain nombre de endpoints. Exemple: 3,14

## Création d'une nouvelle API

Afin de faciliter la création d'une nouvelle API dans la philosophie 'v3'
il existe un générateur qui créer l'ensemble des fichiers nécessaires.
Pour les options et fichiers générés, voir :

`bundle exec rails generate scaffold_resource --help`

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
