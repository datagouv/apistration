# Cas d'usage & fiche endpoint

## Cas d'usage récurrents (qui pilotent « quoi exposer »)

API Entreprise / Particulier sert des **administrations** qui instruisent des
dossiers. La donnée n'a de valeur que rapportée à un usage. Les grands cas :

- **Marchés publics** : vérifier existence, identité, capacité, **probité** d'un
  candidat (état, comptes à jour, certifications, attestations de vigilance).
- **Subventions** : instruire une demande (identité, objet, dirigeants,
  comptes, agréments).
- **Pré-remplissage de démarche** : récupérer des infos publiques pour éviter la
  ressaisie usager (souvent un endpoint **open data** sans données personnelles).
- **Contrôle / conformité** : signaux de sérieux (retards de dépôt de comptes,
  dissolution, financements sensibles).
- **Instruction de droits ou démarches particuliers** : vérifier un statut, une
  éligibilité ou une situation à partir d'une Identité pivot, de FranceConnect ou
  d'un identifiant métier. Ici, la qualité du matching est aussi importante que
  la donnée renvoyée.

Pour chaque champ de l'API, se demander : **quel cas d'usage le consomme ?** Si
aucun → ne pas l'exposer (bruit technique). Exposer sous condition les données
personnelles (gating RGPD) et les données sensibles.

## Croiser avec les besoins usagers fournis

Si un **recensement des besoins** existe (cf. entrées du skill : quel acteur
demande quoi, base légale), ne pas se contenter des cas d'usage génériques :
produire un **tableau besoin → couverture par l'API** (exposé / prévu mais non
dispo / absent), puis **positionner l'API** :

- répond-elle au **besoin dominant**, ou n'est-ce qu'un **complément ciblé** à
  côté de ce qui est déjà servi (éviter de survendre) ?
- y a-t-il **doublon** avec une donnée existante du catalogue (ex. deux notions
  d'effectif de sources différentes) → à arbitrer et documenter.

Ce croisement change la recommandation et la priorisation : il faut le faire
quand la matière est disponible.

## Comparer à l'existant

Avant de recommander une structure, lire une fiche proche dans
`commons/endpoints/api_entreprise/` (ou `api_particulier/`). Réutiliser ses
partis pris :

- **niveaux d'ouverture** : une fiche `protected` (données complètes, backoffice
  instructeur) + éventuellement une fiche `open_data` (`public`, pré-remplissage,
  sans PII) ;
- **clé d'appel** (`call_id`) : SIREN / SIRET / RNA… ;
- **modalités API Particulier** : Identité pivot, FranceConnect, identifiant
  métier, et explication des paramètres qui sécurisent le matching ;
- découpage des endpoints.

Repérer les fiches **dépréciées** (`old_endpoint_uids`, mention v3 vs v4) pour
se caler sur la version courante, pas l'ancienne.

## Champs d'une fiche à rassembler pendant l'exploration

Référence complète : `commons/endpoints/template.entreprise.yml.example` (et
`.particulier.`). Le skill `edit-endpoint` écrit la fiche ; l'exploration doit
fournir la matière. À ce stade, il s'agit d'un brouillon de cadrage, pas d'une
fiche prête à intégrer en production :

- `uid`, `path` (= path du swagger), `controller` (côté siade).
- `perimeter` : `entity_type_description` (entités couvertes),
  `geographical_scope_description` (métropole, DROM-COM, exclusions),
  `updating_rules_description` (fréquence + source de mise à jour),
  `entities`.
- `call_id` : la **clé d'appel** (point critique — cf. SIREN/SIRET).
- `provider_uids` : identifiant fournisseur.
- `keywords` : termes de recherche métier.
- `data.description` : nature/format des données délivrées (markdown GFM).
- `opening` : `public` ou `protected`.
- `format` : ex. « Donnée structurée JSON », « URL vers documents PDF ».
- `parameters` : paramètres d'appel.
- `faq` : questions fréquentes (ex. « mes infos ne sont pas à jour ? » → où les
  corriger).
- `swagger` : titre, description, tags, `attributes` (réponse JSON) ou
  `document_url_properties` (PDF).

## Contrat cible provisoire

Séparer deux registres : un **design recommandé et assumé** (« si le fournisseur
est propre, voilà ce que je conseille » — endpoints, maille, format de réponse,
ordre de mise en œuvre, avec le pourquoi) **et** les **questions ouvertes** qui
restent à confirmer. Trancher, ne pas se contenter de lister des arbitrages.

Pour préparer la suite sans faire le travail d'intégration complet, relever :

- le ou les endpoint(s) publics pressentis, avec leur paramètre d'appel ;
- le mapping fournisseur brut → `data`, `links`, `meta` ;
- les champs qui semblent devoir rester internes ou en `meta` technique ;
- les erreurs fonctionnelles à distinguer des erreurs fournisseur ;
- les besoins de document download, cache, ping, ou maintenance à éclaircir ;
- les zones du dépôt probablement concernées plus tard : `siade`,
  `commons/endpoints`, mocks, et SDK clients si la signature publique change.

## Rappel SDK clients

Toute itération sur une signature d'API publique implique de régénérer les SDK
`clients/ruby` et `clients/node` puis une release SemVer (cf. CLAUDE.md racine).
À mentionner dans les recommandations seulement comme point d'attention futur :
l'exploration ne régénère pas les SDK.
