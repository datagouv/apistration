# Données de tests API Entreprise v3+ & API Particulier / Utilisation de l'environnement de test

[![Tests](https://github.com/etalab/siade_staging_data/actions/workflows/tests.yml/badge.svg)](https://github.com/etalab/siade_staging_data/actions/workflows/tests.yml)

Ce dépôt contient l'ensemble des données de tests pour les environnements de bac
à sable d'API Entreprise (seulement pour la v3+)
( https://staging.entreprise.api.gouv.fr ) et d'API
Particulier ( https://staging.particulier.api.gouv.fr ).

- [Quick start](#quick-start)
- [Fonctionnement](#fonctionnement)
  - [Un dossier de cas de tests pour chaque endpoint](#1endpoint-1dossier)
  - [Format des cas de test](#format-cas-test)
  - [Exemples d'appel d'un cas de test](#exemple-appel-cas-de-test)
  - [Appels avec FranceConnect - _Uniquement API Particulier_](#apiparticulier-france-connect)
- [Contribution : Ajouter des données de test](#ajouter-donnees-de-test)
- [Développement](#developpement)
  - [Installation en local](#installation-en-local)
  - [Lancer la suite de tests pour vérifier les payloads](#lancer-la-suite-de-tests-pour-vérifier-les-payloads)
  - [Génerer un jeton](#générer-un-jeton)
  - [Ajout d'un nouvel endpoint](#ajout-dun-nouvel-endpoint)
  - [Déploiement des données](#déploiement-des-données)
- [Limitations](#limitations)

## <a name="quick-start"></a> Quick start

**tl;dr: Trois commandes en console pour faire fonctionner l'environnement de test :**

Récupération d'un jeton:

```sh
token=`curl https://raw.githubusercontent.com/etalab/siade_staging_data/develop/tokens/default`
```

Test d'API Entreprise:

```sh
curl -H "Authorization: Bearer $token" \
  -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
  --url "https://staging.entreprise.api.gouv.fr/v3/urssaf/unites_legales/418166096/attestation_vigilance"
```

Test d'API Particulier

```sh
curl -H "X-Api-Key: $token" \
  -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=DUPONT' -d 'prenoms[]=JEANNE' -d 'prenoms[]=LAURE' -d 'anneeDateDeNaissance=1993' -d 'moisDateDeNaissance=8' \
  --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
```

Les exemples sont dans les accordéons "Commande cURL" dans les dossiers de
[payloads](./payloads)

## <a name="fonctionnement"></a> Fonctionnement

### <a name="1endpoint-1dossier"></a> Un dossier de cas de tests pour chaque endpoint :

Chaque endpoint de l'API Entreprise ou de l'API Particulier, pour lesquels des cas de tests ont été proposés, possède un dossier dans [`payloads/`](https://github.com/etalab/siade_staging_data/tree/develop/payloads), où sont regroupés ses cas de tests.

Le nom de ce dossier a la forme suivante : `bouquetapi_version_endpointname`.

Une table de correspondance _url de l'endpoint_ <-> _nom du dossier_ est disponible à la
racine du dossier [`payloads/`](https://github.com/etalab/siade_staging_data/tree/develop/payloads) : [README.md](./payloads/README.md) (généré
automatiquement par `bin/generate_payload_readme.rb`)

**Pour API Entreprise :**

Nom type du dossier d'un endpoint : `api_entreprise_version_endpointname`

> Par exemple : `api_entreprise_v3_insee_unite_legale`

➡️ [Liens des dossiers d'endpoints de l'API Entreprise](https://github.com/etalab/siade_staging_data/blob/develop/payloads/README.md#api-entreprise-v3)

**Pour API Particulier :**

Nom type du sous-dossier d'une payload : `api_particulier_version_endpointname`

> Par exemple : `api_particulier_v2_dgfip_svair`

➡️ [Liens des dossiers d'endpoints de l'API Particulier](https://github.com/etalab/siade_staging_data/blob/develop/payloads/README.md#api-particulier)

### <a name="format-cas-test"></a> Format des cas de test :

Chaque dossier possède un README.md ainsi que des fichiers YAML des différents cas de tests ayant un format du type suivant :

```yaml
---
params:
  first_name: "John"
  last_name: "Doe"
status: 200
payload: |-
  {
    "status": "OK"
  }
```

Avec:

- `params`, ensemble de clé valeur traduisant les paramètres qui déclenchent la
  réponse associée ;
- `status`, le status de la réponse HTTP associé ;
- `payload`, la payload renvoyée.

Toutes les autres clé potentiellements présentes dans la payload sont
facultatives ou servent pour tout autre chose (affichage d'exemples sur les
fiches métiers par exemple). Une liste (non-exhaustive) :

- `title`, titre de la payload, utilisé pour l'exemple ;
- `description`, une description de la payload, utilisé pour l'exemple ;
- `example`, booléen, précise si la payload sera affichée sur dans les fiches métiers du catalogue ;

### <a name="exemple-appel-cas-de-test"></a> Exemples d'appel d'un cas de test :

Pour déclencher l'[exemple de payload de réponse précédent](#format-cas-test), exemple créé de toute pièce pour ce tutoriel, avec comme chemin tout aussi fictif `v1/dgfip/impots`, il faut effectuer l'appel suivant:

Pour API particulier :

```sh
curl -X GET \
  -H 'X-Api-Key: TOKEN' \
  -G -d 'first_name=John' -d 'last_name=Doe' \
  https://staging.particulier.api.gouv.fr/v1/dgfip/impots
```

Pour API Entreprise :

```sh
curl -X GET \
  -H 'Authorization: Bearer TOKEN' \
  -G -d 'first_name=John' -d 'last_name=Doe' \
  https://staging.entreprise.api.gouv.fr/v1/dgfip/impots
```

Les routes sont listées à la racine du dossier [`payloads/`](./payloads)

À noter qu'il est possible de mettre n'importe quel status (valide), hormis ceux
associés aux paramètres invalides et au jeton invalide:

- Pour API Entreprise: `422` et `403` ;
- Pour API Particulier: `400` et `401`.

En effet, les paramètres d'entrées sont vérifiés directement par l'application,
ce qui garantie un comportement iso avec la production.

### <a name="apiparticulier-france-connect"></a> Appels avec FranceConnect - Uniquement pour API Particulier

Certains endpoints d'API Particulier sont FranceConnectés : cela implique que
l'on peut passer un jeton FranceConnect à la place des paramètres classiques
afin d'effectuer un appel auprès des fournisseurs de données. À l'aide du jeton
FranceConnect, l'API effectue un appel auprès de FranceConnect pour récupérer
des données de civilité (un exemple [ici](./payloads/france_connect/default.yaml)),
données qui sont ensuite formatées pour effectuer un appel auprès du fournisseur
de données correspondant.

#### En utilisant le FranceConnect d'integration

Il est possible d'utiliser directement le service d'integration de FranceConnect et d'envoyer sur nos serveurs en staging un jeton FranceConnect valide.
Dans ce cas nous allons directement appeler le fournisseur de données avec l'identité pivot renvoyée par FranceConnect. Vous pouvez accédez à l'ensemble des identifiants valides sur le [dépot de FranceConnect](https://github.com/france-connect/identity-provider-example/blob/master/database.csv).

Afin que l'environnement d'intégration fonctionne il est impératif de demander les scopes relatifs à l'identité pivot lors de votre authentification auprès de FranceConnect. Les scopes obligatoires sont :

- given_name
- family_name
- birthdate
- gender
- birthplace
- birthcountry
- preferred_username

Il est possible d'utiliser les alias de scope tel que précisé dans la documentation de [FranceConnect](https://partenaires.franceconnect.gouv.fr/fcp/fournisseur-service#identite-pivot).

À noter que seules certaines identités sont prises en compte dans les cas de test, le plus souvent la première de la liste (Angela DUBOIS). S'il n'y a pas de cas de test, vous recevrez la réponse générique tel que défini dans les fichiers swagger de l'api.

Si vous souhaitez ajouter des cas de test, merci de vous réferrez à la section [Ajouter des données de test](#ajouter-donnees-de-test).

Vous pouvez utiliser la documentation de FranceConnect pour construire votre propre environnement d'intégration pour tester de bout-en-bout, ou pour un rapide test vous pouvez utiliser l'espace d'intégration d'exemple de FranceConnect :

Exemple step-by-step avec l'endpoint ANTS `/v3/ants/extrait_immatriculation_vehicule/france_connect` :

1.  Récupérer un access_token sur FC v2 sandbox

    a. Ouvrir la page du fournisseur de service de démonstration

        https://fsp1-low.sbx.fcp.fournisseur-de-service.fr/login

    b. Ajouter les scopes ants demandés pour le token

        openid ants_extrait_immatriculation_vehicule_identite_particulier ants_extrait_immatriculation_vehicule_adresse_particulier ants_extrait_immatriculation_vehicule_statut_rattachement ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule

    c. Cliquer sur le bouton FranceConnect pour commencer la cinématique

    d. Sélectionner le fournisseur d'identité fip1-low

    e. Utiliser le compte "test" avec mot de passe "123"

    d. Finaliser la cinématique

    e. Copier l'access_token reçu

2.  Appeler API SIV géré par API Particulier

    curl "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013&immatriculation=FC-456-CD" -H "Authorization: Bearer $access_token"

#### En utilisant les faux jetons FranceConnect

Les données de tests de FranceConnect se trouvent dans le dossier
[payloads/france_connect/](payloads/france_connect/)

Il est possible dans ce dépôt de faire un mapping _jeton_ <-> _données
FranceConnect_, et derrière faire un mapping _Données FranceConnect_ <-> _réponse de
l'API_.

Par exemple pour `api/v2/etudiants-boursiers`:

1. Un mapping valide pour FranceConnect: [payloads/france_connect/cnous.yaml](./payloads/france_connect/cnous.yaml) ;
2. Un mapping pour `api/v2/etudiants-boursiers` qui prend exactement les
   paramètres d'identité renvoyés par le fichier ci-dessus:
   [payloads/api_particulier_v2_cnous_student_scholarship/fake_franceconnect_cnous.yml](./payloads/api_particulier_v2_cnous_student_scholarship/fake_france_connect_cnous.yml).

Ainsi, l'appel suivant renverra in-fine la réponse définie en 2. :

```sh
curl -X GET \
  -H "Authorization: Bearer cnous" \
  https://staging.particulier.api.gouv.fr/api/v2/etudiants-boursiers?recipient=13002526500013
```

Le jeton `cnous` correspond à la valeur du paramètre `token` dans le fichier de
définition de FranceConnect.

À noter que les scopes renvoyés par FranceConnect permettent de construire la
réponse adéquate : si les scopes nécessaires pour renvoyer la réponse ne sont pas
présents l'API renverra une `401`.

Attention, il y a une divergence entre la production et le staging sur les
champs renvoyés : l'API en production effectue un filtrage des champs en fonction
des scopes. Par exemple ici si `cnous_email` est absent des scopes, l'API en
production retira le champ `email` de la réponse. Ce comportement n'existe pas
en staging, l'API renverra la payload définie dans le fichier de ce dépôt sans
aucun filtrage.

Pour contourner ce problème, il faut retirer les champs de la payload finale.
Vous pouvez vous référer à l'exemple
[payloads/api_particulier_v2_cnous_student_scholarship/fake_france_connect_cnous_with_less_scopes.yml](./payloads/api_particulier_v2_cnous_student_scholarship/fake_france_connect_cnous_with_less_scopes.yml),
où les clés `nom`, `prenom`, `prenom2`, `dateNaissance`, `lieuNaissance`, `sexe`
ont été omises.

Plusieurs exemples existent pour tous les endpoints FranceConnectés dans le
dossier [france_connect](./payloads/france_connect/), avec une description
indiquant la réponse associée sur le fournisseur de données.

## Déploiement des données

Lorsque des nouvelles données sont poussées sur la branche `develop`, le système
effectue des vérifications sur la cohérence à l'aide d'une suite de tests
automatisés. Si tout est OK, le système notifie l'API afin que celle-ci prenne
en compte les nouvelles données.

En cas de problème, il est possible d'effectuer une recharge des données en
lançant la commande suivante :

```sh
bundle exec ruby bin/reload_mock_backend.rb
```

## <a name="ajouter-donnees-de-test"></a> Contribution : Ajouter des données de test

**Si vous êtes développeur**, référez-vous à la section [Développement](#developpement) ci-dessous.

**Si vous êtes un fournisseur de données** :

- Pour un endpoint ayant déjà un dossier dans [`payloads/`](./payloads) :
  - Si vous êtes à l'aise avec Github, vous pouvez ajouter vous-même les fichiers des cas de tests que vous souhaitez, au travers d'une Pull Request ;
  - Autrement, vous pouvez ouvrir un ticket pour que l'on vous accompagne sur l'implémentation : [Ajout de nouvelles données](https://github.com/etalab/siade_staging_data/issues/new?template=ajout-payloads.md)
- Pour un endpoint n'ayant pas encore de dossier dans [`payloads/`](./payloads) :
  - Si vous êtes à l'aise avec Github, vous pouvez créer un dossier dans [`future_payloads/`](./future_payloads) à l'aide d'une Pull Request ;
  - Autrement, vous pouvez ouvrir un ticket pour que l'on vous accompagne sur l'implémentation : [Ajout d'un endpoint manquant](https://github.com/etalab/siade_staging_data/issues/new?template=proposer-une-am-lioration.md).

## <a name="developpement"></a> Développement

### Installation en local

#### Dépendances

- ruby 3.2.0

```sh
bundle install
```

### Lancer la suite de tests pour vérifier les payloads

```sh
bundle exec rspec
```

### Générer un jeton

Référez-vous à [tokens/](./tokens)

### Ajout d'un nouvel endpoint

1. Identifier l'operation_id (dans les fichiers swaggers: `x-operationId`) ;
2. Executer la commande : `bundle exec ruby bin/bootstrap_payload.rb
operation_id` ;
3. La commande crée un dossier avec un `default.yaml` que vous devez adapter pour
   que la suite de tests passe (cf plus bas).

Par défaut, la commande se base sur les fichiers OpenAPI en staging.
Pour utiliser les fichiers openapi locaux (dossier `openapi_files`), utilisez la variable d'environnement `LOCAL=true`

## Limitations

- Pour API Particulier, si un jeton ne possède pas l'ensemble des scopes pour
  un fournisseur de données, l'environnement de test ignore le filtrage sur ces
  scopes (contrairement à la production qui filtre en fonction des scopes).

  Par exemple, si votre jeton possède l'ensemble des autorisations pour
  `/v2/etudiants-boursiers` sauf celle de récupérer l'e-mail (`cnous_email`), la
  production retirera le champ `email` de la réponse, mais pas l'environnement
  de test.

  Pour palier ce problème, le plus simple reste de créer une réponse spécifique
  avec moins de champ.

- Pour les endpoints qui ne sont pas encore présents dans ce dépôt, des
  ajustements techniques vis-à-vis des paramètres à prendre en compte peuvent
  être nécessaires.

Si ces limitations sont problématiques pour votre développement et intégration,
nous vous invitons à [ouvrir un ticket](https://github.com/etalab/siade_staging_data/issues/new).
