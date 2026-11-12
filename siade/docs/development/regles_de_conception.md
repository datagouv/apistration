# Règles de conception des endpoints

Règles strictes, à connaître avant de concevoir ou de modifier un
endpoint. Y déroger demande une raison écrite (ici, dans la liste des
exceptions de la règle concernée).

## 1. API Particulier : toute clé racine de la réponse est derrière un scope

Dans un serializer API Particulier v3 et plus, chaque attribut racine
porte un `if: -> { scope?(:...) }`, et le scope est déclaré dans
[`commons/data/authorizations.yml`](../../../commons/data/authorizations.yml).
Une nouvelle clé reçoit son propre scope ; seules des clés indissociables
partagent un scope.

**Pourquoi** : un scope est une donnée que l'habilitation (Datapass)
accorde ou non. Une clé sans scope est servie à tout porteur d'un jeton
de l'endpoint, quelle que soit la donnée qu'il a été autorisé à recevoir.
La vérification du contrôleur ne suffit pas : elle n'exige qu'un des
scopes de l'endpoint.

**Précédents** :

- `app/serializers/api_particulier/cnav/participation_familiale_eaje/v3.rb` :
  `allocataires`, `enfants`, `adresse`,
  `parametres_calcul_participation_familiale`, un scope chacun ;
- clés indissociables sous un même scope : `est_beneficiaire` et
  `date_debut_droit` (AAH, ASF, CSS, RSA, prime d'activité),
  `annee_scolaire`, `est_scolarise` et `statut_eleve` (MEN scolarités).

**Exceptions** : `identifiant` de France Travail indemnités v3, qui est
le paramètre d'entrée renvoyé tel quel, pas une donnée du fournisseur.

**Contrôle** : `spec/serializers/api_particulier/v3_and_more/base_serializer_subclasses_spec.rb`
rend chaque serializer v3 et plus sans aucun scope et échoue si une clé
racine apparaît. Une exception se déclare dans
`root_keys_served_without_scope` et se justifie dans la liste ci-dessus.

## 2. Nouvelle clé derrière un nouveau scope = nouvelle version

Par défaut, ajouter une clé derrière un nouveau scope, c'est créer une
nouvelle version de l'endpoint, dont le serializer hérite de la
précédente.

**Pourquoi** : la réponse d'une version est un contrat. Les clients qui
reçoivent le nouveau scope sans avoir migré ne doivent pas voir changer
la réponse de la version qu'ils appellent.

**Précédents** :

- CNOUS étudiant boursier v5 = v4 + `ine` derrière `cnous_ine`
  (`58d3c246e`, `app/serializers/api_particulier/cnous/etudiant_boursier/v5.rb`) ;
- MEN scolarités v5 = v4 + `regime_pensionnat` derrière
  `men_regime_pensionnat` (`414c7ee47`,
  `app/serializers/api_particulier/men/scolarites_serializer/v5.rb`).

Quand les habilitations existantes doivent recevoir le nouveau scope sans
démarche de leur part, une migration côté `site/` le leur ajoute :
précédent
[`site/db/migrate/20250326104012_migrate_tokens_scopes_to_api_particulier_v3.rb`](../../../site/db/migrate/20250326104012_migrate_tokens_scopes_to_api_particulier_v3.rb).

**Exception** : un arbitrage produit explicite peut enrichir la version
existante sans en créer une, quand trois conditions tiennent :

- l'ajout a été annoncé aux consommateurs ;
- c'est une donnée attendue par tous ;
- le choix est fait explicitement par le produit, pas par défaut.

Le nouveau scope est alors ajouté à tous les jetons existants par une
migration côté `site/`. Cas réel, API-7115 : `dossier_allocataire`
derrière `cnav_participation_familiale_eaje_dossier_allocataire`,
ajouté à la v3 de la participation familiale EAJE sans v4. Les éditeurs
attendaient la donnée depuis des mois, jamais une montée de version, et
une migration avant janvier n'était pas souhaitable.

Toute nouvelle version s'accompagne d'une itération sur les SDKs
(`clients/`, cf. `CLAUDE.md` racine).

## 3. Un endpoint = un seul fournisseur de données

Un endpoint appelle un seul fournisseur de données (FD). On évite au
maximum d'en appeler un deuxième.

**Pourquoi** : chaque FD de plus est une raison de plus de tomber en
panne, et l'endpoint n'est disponible que si tous ses FD le sont.

**Exceptions** :

- **Dictionnaires DGFIP (Adélie)**, pour les bilans Banque de France
  (`app/interactors/banque_de_france/bilans_entreprise/enrich_resource_collection_with_dictionaries.rb`).
  Les liasses fiscales les appellent aussi, mais c'est le même FD
  (`app/interactors/dgfip/liasses_fiscales/retrieve_dictionaries_with_fallback.rb`,
  `app/organizers/dgfip/dictionaries.rb`). Mis en cache et stockés en
  local avec repli
  (`app/interactors/dgfip/liasses_fiscales/retrieve_dictionary_from_cache_or_remote.rb`) :
  le risque de panne est faible.
- **Transcogage INSEE (Métadonnées)**, pour les endpoints avec civilité
  qui acceptent le nom de la commune de naissance à la place de son code
  COG : MESRI statut étudiant, CNOUS étudiant boursier
  (`app/interactors/civility/extract_code_commune_from_transcogage.rb`).
  Appelé seulement quand le client ne fournit pas le code, sans copie
  locale : une panne INSEE fait tomber ces appels-là.

Un appel imbriqué vers un autre FD se déclare avec `delegates_to`, ce qui
permet de le retrouver (`grep -rn delegates_to app`).
