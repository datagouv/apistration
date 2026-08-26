# Nomenclature codes erreurs API Entreprise

Tiré de JSON API:

- https://jsonapi.org/format/#errors
- https://jsonapi.org/examples/#error-objects

## Format de la payload

```json
{
  "errors": [
    {
      "code": string,
      "title": string,
      "detail": string,
      "source": source
    }
  ]
}
```

## Classification

- `XXYYY` -> `XX` = code fournisseur de données | `YYY` = code erreur

### Codes fournisseur de données (XX)

Liste non-exhaustive (la liste se trouve dans [`ErrorsBackend`](app/services/errors_backend.rb))

- `01` = INSEE
- `02` = Infogreffe
- `03` = DGFIP
- `04` = ACOSS
- `05` = INPI
- `06` = Qualibat
- `07` = RNA
- `08` = CNETP
- `09` = ProBTP
- `10` = MSA
- `11` = OPQIBI
- `12` = FNTP
- `14` = Fabrique numérique des Ministères Sociaux
- `15` = CMA France
- `16` = DGDDI
- `17` = Banque de France
- `18` = Agence BIO
- `19` = ADEME
- `20` = API Geo

La valeur `00` correspond aux erreurs relatives à l'API Entreprise et
**n'implique pas de fournisseur de données**.

### Règle : le préfixe indique qui a rendu le verdict

Le préfixe répond à la question « **un fournisseur de données a-t-il été
sollicité ?** », pas à la question « où est la cause ? ». Cette dernière est
déjà portée par le statut HTTP.

- `00XXX` ⟺ **aucun appel fournisseur n'a eu lieu**. L'erreur a été décidée par
  nos seuls moyens : validation de paramètres, authentification, habilitations.
  Elle est déterministe : à paramètres identiques, la réponse ne changera pas.
- `XXYYY` (`XX` ≠ `00`) ⟺ **un fournisseur a été appelé**, et c'est lui qui a
  rendu le verdict. `meta.provider` nomme ce fournisseur. La réponse n'est pas
  déterministe dans le temps : les données du fournisseur peuvent évoluer.

Le statut HTTP reste, lui, l'indicateur de l'action attendue de l'appelant :

| Statut | Signification pour l'appelant |
| ------ | ----------------------------- |
| `422`  | La requête est inexploitable : corriger la saisie et rappeler |
| `404`  | La requête est bonne, la donnée n'existe pas : clore le dossier |
| `502`  | Panne du fournisseur : réessayer plus tard |

Un `422` peut donc parfaitement porter un préfixe fournisseur : c'est le cas
lorsque seul le fournisseur est capable de dire que l'entrée transmise ne
correspond à personne (échec d'appariement SNGI, civilité refusée, critères
d'identité ambigus). Ces erreurs sont construites par
[`ProviderUnprocessableEntityError`](app/errors/provider_unprocessable_entity_error.rb),
qui dérive le code **et** `meta.provider` du même `provider_name`, rendant
l'invariant impossible à violer.

Concrètement : une erreur émise depuis un `ValidateParams` porte le préfixe
`00`, une erreur émise depuis un `ValidateResponse` porte un préfixe
fournisseur. La règle est vérifiée par
[`spec/services/errors_nomenclature_spec.rb`](spec/services/errors_nomenclature_spec.rb).

> Exception héritée : les codes `50001` à `50004` (jetons FranceConnect)
> utilisent un préfixe `50` non attribué dans `ErrorsBackend`. Ils sont
> explicitement listés dans le spec de conformité en attendant leur propre
> reclassement.

### Codes erreur (YYY)

#### Erreurs communes de base

Ces erreurs sont comprises entre `000` et `049`.

- `XX000` = Erreur inconnue (Unknown error)

  Il s'agit généralement d'une erreur d'un fournisseur de données non traitée.

- `XX001` = Service non disponible (Service unaivalable)

  Le fournisseur de données est soit en maintenance, soit surchargé.

- `XX002` = Intermédiaire hors délai (Gateway Time-out)

  Le fournisseur de données n'as pas répondu dans les délais.

- `XX003` = Ressource non trouvée (Resource not found)

  Erreur générique lorsqu'une ressource n'a pas été trouvée chez le fournisseur
  de données. Certains fournisseurs de données peuvent avoir des codes erreurs
  spécifiques en fonction de la nature de l'erreur.

- `XX004` = Erreur de résolution DNS

  Le service du fournisseurs de données n'est pas atteignable. Cette erreur est
  généralement dû à une erreur temporaire de réseau.

- `XX005` = Indisponible pour des raisons légales (Unavailable For Legal Reasons)

  La ressource ne peut être fournit pour des raisons légales.

- `XX006` = Erreur d'authentificatin auprès du fournisseur de données

  Cette erreur intervient généralement quand le fournisseur de données est
  indisponible pour des raisons inconnues.

- `XX007` = Entité disparue

  Cette erreur indique que la ressource n'est plus disponible : il s'agit du
  code HTTP utilisé lorsqu'un fournisseur de données ne renvoie plus cette
  donnée, et que le endpoint ne sera plus jamais en capacité de renvoyer des
  données.

  Cette erreur intervient généralement quand le fournisseur de données est
  indisponible pour des raisons inconnues.

##### XX05Z Erreurs associés aux fichiers renvoyés par les fournisseurs de données

- `XX051` = Le fichier en base64 renvoyé est invalide
- `XX052` = Intermédiaire hors délai
- `XX053` = Erreur HTTP
- `XX054` = URL du fichier non valide
- `XX055` = Extension de fichier non valide

#### Erreurs API Entreprise (XX = 00)

##### 00010Z Erreurs associés aux jetons

- `00100` = Privilèges insuffisants
- `00101` = Jeton non valide ou non renseigné
- `00102` = Jeton sous l'ancien format
- `00103` = Jeton expiré

##### 0020Z Erreurs associés aux paramètres obligatoires

- `00201` = Context manquant
- `00202` = Object manquant
- `00203` = Recipient manquant
- `00210` = Recipient n'est pas un siret valide
- `00211` = Recipient identique au paramètre d'appel

##### 0003Z Erreurs associés aux entrées non traitables

Ces erreurs sont détectées **avant tout appel fournisseur**, par validation
locale des paramètres.

- `00301` = Siren non valide
- `00302` = Siret non valide
- `00303` = Siret ou numéro RNA non valide

##### Autres erreurs

- `00401` = Mauvaise requête du client (Bad request)
- `00402` = Version non supportée de l'API (Not found)
- `00006` = Accès interdit (Forbidden)
- `00401` = Mauvaise requête du client (Bad request)
- `00429` = Trop de requêtes (Too Many Requests)

#### Erreurs fournisseurs spécifiques

L'ensemble de ces erreurs sont définis dans le fichier
[`errors.yml`](./config/errors.yml), et leur sous code commencent au minimum à
la valeur `500`

##### XX56Z Entrées rejetées par le fournisseur de données

Sous-codes partagés par tous les fournisseurs, pour les entrées que seul le
fournisseur peut invalider. Ils produisent un `422`, avec le préfixe du
fournisseur interrogé.

- `XX560` = Identité non reconnue par le fournisseur de données
- `XX561` = Paramètres de civilité refusés par le fournisseur de données
- `XX562` = Identifiant refusé par le fournisseur de données
- `XX563` = Identité ambiguë pour le fournisseur de données
- `XX564` = Identité inexploitable renvoyée par le fournisseur de données
