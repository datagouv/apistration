# Nomenclature des codes erreurs

Les deux APIs publient la liste des erreurs que chaque opération peut
renvoyer. Cette liste est générée depuis le code : une erreur n'y figure pas
parce que quelqu'un l'a recopiée, mais parce qu'une classe la déclare.
Ce document décrit comment elle est construite, publiée, et les garde-fous
qui empêchent le code et la documentation de diverger.

Le format des codes (`XXYYY`, préfixes fournisseurs, sous-codes communs) est
décrit dans [`siade/nomenclature-errors.md`](../siade/nomenclature-errors.md).

## Invariant

Pour chaque opération v3+ :

```
erreurs rendues en production ⊆ nomenclature (même code, même statut) ⊆ swagger (statuts)
```

Un code n'a qu'un seul sens (un seul titre, un seul statut) sur toute l'API.

L'inclusion est volontairement large : la nomenclature peut lister un code
qu'aucun appel ne rend, jamais l'inverse. Un intégrateur qui prévoit un cas
en trop ne casse rien ; un code absent le surprend en production. Les
garde-fous vérifient donc qu'aucune erreur rendue ne manque, pas que chaque
erreur listée soit atteignable (seul le garde d'émission des validateurs
impose que leurs déclarations soient émises en spec). Voir « Limites
connues ».

## Sources

| Source | Rôle |
| --- | --- |
| `siade/config/errors.yml` | Titre et détail de chaque code et sous-code |
| `siade/app/errors/*.rb` | Une classe par erreur ; le code vient de la classe (préfixe fournisseur + sous-code) |
| `Errors::HTTPStatusForKind` | Statut HTTP à partir du `kind` de l'erreur |
| `Errors::BaselineErrors` | Erreurs que personne ne déclare parce que tout le monde peut les rendre |

### Déclarations

Les erreurs spécifiques sont déclarées au plus près du code qui les lève :

```ruby
class GIPMDS::Effectifs::ValidateResponse < ValidateResponse
  raises GIPMDSError, kind: :quota_error
end

class ServiceUser::ValidateUserId < ValidateUuid
  raises UnprocessableEntityError, field: :user_id
end
```

| DSL | Où | Effet |
| --- | --- | --- |
| `raises Klass, **options` | intéracteur | l'erreur est documentée pour toute opération dont l'organizer exécute l'intéracteur |
| `declares_no_specific_errors!` | intéracteur | l'intéracteur n'émet que des erreurs de la baseline |
| `delegates_to Klass` | intéracteur | l'intéracteur exécute `Klass` hors de sa chaîne `organize` et relaie ses erreurs : celles d'un retriever sont documentées sous le fournisseur de ce retriever, celles d'un autre intéracteur ou organizer deviennent celles de l'appelant |
| `absorbs_errors_of Klass` | intéracteur | l'intéracteur exécute `Klass` mais transforme son échec en une erreur à lui (`ValidateRecipient` et `ValidateSiret`) |
| `nomenclature organizers: { 3 => Organizer }` | contrôleur v3+ | associe chaque version de l'endpoint à l'organizer qu'elle exécute |
| `nomenclature_undocumented!` | contrôleur v3+ | la route reste hors des opérations (open data RBE, introspection du jeton) |

`ErrorRegistry` stocke ces déclarations. Il suit la chaîne `organize` des
organizers, les ancêtres des classes, et les délégations, y compris à travers
un intéracteur intermédiaire. Une déclaration héritée vaut pour toutes les
sous-classes : un validateur qui rejette un autre champ que son parent
partage son code par un concern plutôt que par héritage (`YearValidation`,
`MonthValidation`), et un appelant ne délègue qu'à ce qu'il peut réellement
faire échouer (`CNAV::ValidateTranscogageParams`).

### Baseline

`Errors::BaselineErrors` porte deux familles d'erreurs :

- `platform` : les codes `00` que tout endpoint peut rendre avant même son
  organizer (jeton, IP, paramètres obligatoires, délégation, version, 400,
  409, 429, erreur réseau). Rendus par Rack, un `before_action` ou un
  `rescue_from`.
- `for_provider(provider)` : les erreurs génériques de tout fournisseur
  (inconnue, interne, timeout, indisponible, DNS, SSL, rate limit, 404,
  maintenance 503). Rendues par `RetrieverOrganizer`, `MakeRequest` ou
  `ValidateResponse`.

## Assemblage

`ErrorsNomenclature.new(api).to_h` produit :

```yaml
api: entreprise
providers:          # préfixe → nom du fournisseur, limité aux préfixes de l'API ; 00 porte son nom
generic_subcodes:   # sous-code → titre, détail
platform_codes:     # statut → erreurs 00xxx
endpoints:
  <operation_id>:
    provider: <nom>
    errors:
      '422': [...]
      '404': [...]
      '502': [...]
```

Pour chaque contrôleur déclaré, et pour chaque version, les erreurs de
l'opération sont :

1. les erreurs déclarées sur la chaîne de l'organizer ;
2. les erreurs FranceConnect sur les variantes FranceConnect ;
3. la baseline `for_provider` du fournisseur de l'organizer, sans son 404
   générique `XX003` quand la chaîne déclare son propre `NotFoundError` (la
   CNAV rend le 404 de la caisse qui a répondu, jamais `36003`) ;
4. les erreurs des retrievers délégués, sous leur propre fournisseur ;

moins les codes déjà publiés dans `platform_codes`. Un code n'apparaît qu'une
fois ; la déclaration d'un endpoint l'emporte sur l'exemple générique.

Les exemples sont construits par `build_example` : `MaintenanceError`, par
exemple, ne lit pas l'horloge, pour que le fichier généré ne dépende pas de
l'heure de génération.

## Génération

```bash
cd siade && bin/generate_swagger.sh
```

1. rswag écrit `commons/swagger/openapi-*.yaml` depuis les specs de requête ;
2. `bin/augment_openapi_files.rb` enrichit chaque opération :
   - `Openapi::ErrorInjector` ajoute les erreurs communes de
     `config/openapi_common_errors/*.yml`, avec le fournisseur que la
     nomenclature attribue à l'opération ;
   - `Openapi::ErrorsNomenclatureStatusFiller` ajoute tout statut de la
     nomenclature (codes plateforme compris) que le swagger n'a pas encore ;
   - `Openapi::ErrorsNomenclatureLinker` ajoute sur chaque réponse d'erreur
     le lien vers la liste complète ;
3. `bin/generate_errors_nomenclature.rb` écrit `commons/data/errors_*.yml`,
   lu par `siade/` et `site/` via des liens symboliques.

Le swagger garde en principe un exemple par statut ; la liste complète vit
dans la nomenclature.

## Publication

| Surface | Contenu |
| --- | --- |
| `GET /errors` (API Entreprise), `GET /api/errors` (API Particulier) | la nomenclature complète, sans jeton, cache public d'une heure ; `?operation_id=` restreint `endpoints` à une opération, 404 si elle est inconnue |
| swagger | un exemple par statut, et un lien vers `/errors?operation_id=…` et la fiche |
| fiches du site | section « Erreurs » de chaque endpoint, groupée par statut, avec un bloc dédié aux erreurs FranceConnect |
| page développeurs | format `XXYYY`, préfixes fournisseurs, sous-codes communs, codes plateforme |
| SDKs Ruby et Node | méthode `errors(operation_id:)` (`clients/SPECS.md` §9.6) |

## Garde-fous

Tous tournent dans `bundle exec rspec` en CI ; `bin/test_swagger.sh` vérifie en
plus que les swaggers commités sont ceux que la génération produit.

| Spec | Échoue quand |
| --- | --- |
| `spec/support/validate_response_emission_guard.rb` | un validateur émet dans ses specs une erreur qu'il ne déclare pas, ou porte une déclaration, la sienne ou celle d'un ancêtre, qu'aucun de ses specs ne lui fait émettre : une sous-classe exerce aussi ce qu'elle hérite (exemples partagés `a CNAV response validator`, `an Infogreffe response validator`, `a birth date validator`) |
| `spec/support/nomenclature_coverage_guard.rb` | une requête de spec renvoie un code absent de la nomenclature pour cette opération et ce statut |
| `spec/acceptances/errors_nomenclature_platform_coverage_spec.rb` | une erreur rendue par Rack ou par un contrôleur v3+ routé (et ses ancêtres) n'est ni un code plateforme, ni une erreur des opérations du contrôleur |
| `spec/acceptances/errors_nomenclature_layers_coverage_spec.rb` | une classe atteinte par la nomenclature, ou une couche dont elle hérite (`RetrieverOrganizer`, `MakeRequest`…), référence une erreur ni déclarée sur elle ou sa chaîne, ni dans la baseline ; une sous-classe ne compte comme documentée que si elle figure dans la table explicite `renders_as`, vérifiée fournisseur par fournisseur |
| `spec/acceptances/errors_nomenclature_delegations_spec.rb` | une classe atteinte par la nomenclature référence un intéracteur, un organizer ou un retriever porteur d'erreurs qu'elle n'organise pas, dont elle n'hérite pas, et qu'elle ne déclare ni avec `delegates_to` ni avec `absorbs_errors_of` |
| `spec/acceptances/errors_nomenclature_declarations_spec.rb` | un contrôleur v3+ routé n'a pas de déclaration, déclare un autre organizer que celui qu'il exécute, sort de la nomenclature hors de la liste explicite, ou une route v3+ (`/v:api_version/`, `/v4/…`, `/api/v3/…`) est servie hors du namespace `v3_and_more` |
| `spec/acceptances/error_codes_unicity_spec.rb` | un code a deux sens |
| `spec/acceptances/errors_nomenclature_conformity_spec.rb` | un préfixe n'est pas attribué, une déclaration ne sait pas construire son erreur, une erreur `00` est déclarée sur un `ValidateResponse` |
| `spec/acceptances/errors_nomenclature_freshness_spec.rb` | `commons/data/errors_*.yml` n'est pas celui que le code produit |
| `spec/acceptances/errors_nomenclature_swagger_coverage_spec.rb` | un statut de la nomenclature manque au swagger d'une opération |

Les gardes statiques parcourent les classes atteintes par la nomenclature :
organizers de chaque version, organizers intermédiaires, intéracteurs,
délégations et retriever FranceConnect (`spec/support/nomenclature_walk.rb`),
et lisent leur source (noms de constantes). Les gardes dynamiques relisent ce
que les specs émettent ou renvoient. Les
premières couvrent les chemins qu'aucun spec n'exerce, les secondes les
références que la lecture du source ne voit pas.

### Limites connues

- Une erreur levée par un chemin qu'aucun spec n'exerce, et référencée
  indirectement (variable, `const_get`, nom construit dynamiquement), échappe
  aux deux familles de gardes.
- La lecture du source ne distingue pas le code d'un commentaire ou d'une
  chaîne : une erreur nommée dans un commentaire peut produire un faux
  positif, jamais un faux négatif.
- `ValidateResponse` et `ValidateParamInteractor` sont exclus du scan des
  couches : ils n'émettent qu'à travers des helpers appelés par leurs
  sous-classes, et c'est le garde d'émission qui impose ces déclarations.
- Une route v3 écrite en lambda Rack, sans contrôleur, n'est pas scannée ; les
  lambdas actuelles répondent un 410 en texte brut, sans code.
- La couverture du swagger porte sur les statuts, pas sur les codes.
- Une déclaration vaut pour toute opération dont l'organizer exécute la
  classe, quelle que soit la variante d'appel. `CNOUS::ValidateResponse`
  déclare `26561` (civilité refusée) et `26562` (INE refusé) et choisit selon
  les paramètres reçus : les trois variantes CNOUS listent les deux codes,
  alors que la variante INE ne rend que `26562` et les autres que `26561`.
  Restreindre une déclaration à une variante demanderait une option dédiée
  et un garde d'émission qui la comprenne ; la liste reste un sur-ensemble.

## Recettes

**Nouvelle erreur spécifique à un fournisseur.** Créer ou compléter la classe
`<Fournisseur>Error < AbstractSpecificProviderError` (sous-code hors des
sous-codes génériques, `kind` donnant le statut), ajouter l'entrée dans
`config/errors.yml`, la déclarer avec `raises` sur l'intéracteur qui la lève,
écrire le spec qui la fait émettre, puis régénérer.

**Nouvelle erreur rendue par toutes les opérations.** L'ajouter à
`Errors::BaselineErrors#platform` (avant l'organizer) ou `#for_provider`
(pendant l'appel fournisseur), puis régénérer.

**Nouvel endpoint v3+.** Contrôleur sous `v3_and_more`, `nomenclature
organizers: { version => Organizer }`, specs rswag, régénération.

**Appel direct à un autre intéracteur, organizer ou retriever.** Déclarer
`delegates_to Klass` si ses erreurs sont relayées telles quelles,
`absorbs_errors_of Klass` si l'appelant les remplace par la sienne.

**Route volontairement hors des opérations.** `nomenclature_undocumented!` sur
le contrôleur et ajout à la liste explicite de
`errors_nomenclature_declarations_spec.rb`. Elle ne peut alors rendre que des
codes plateforme.

Dans tous les cas :

```bash
cd siade
bin/generate_swagger.sh
bundle exec rspec spec/acceptances
```
