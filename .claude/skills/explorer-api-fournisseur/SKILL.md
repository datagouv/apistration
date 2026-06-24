---
name: explorer-api-fournisseur
description: >-
  Explorer et analyser une API externe (fournisseur de données) en vue de
  l'intégrer au catalogue API Entreprise / API Particulier. Use when the user
  veut explorer/analyser/cadrer une nouvelle API à intégrer, étudier un swagger
  ou une doc fournisseur, comprendre les payloads/données d'une API tierce,
  préparer une fiche endpoint dans commons/endpoints, ou produire un document
  d'exploration + une liste de questions pour le dev fournisseur. Triggers :
  « explore cette API », « analyse ce swagger », « qu'est-ce qu'on peut exposer »,
  « intégrer l'API X », « doc d'exploration », « questions pour le fournisseur ».
---

# Explorer une API fournisseur à intégrer

Objectif : transformer un accès à une API tierce (swagger + doc métier + clé de
test) en **4 livrables** exploitables par l'équipe API Entreprise / API
Particulier :

1. **Document d'exploration** (high level, en `.md` puis `.pdf` pour le PO) :
   ce que renvoie l'API, taux de remplissage réels, recommandations
   d'exposition par cas d'usage.
2. **Document de questions** (fichier `.txt`, bullet points, vouvoiement) à
   destination du dev fournisseur — exploitable aussi bien dans un mail que dans
   Tchap : tout ce qui bloque ou reste flou.
3. **Matière pour la fiche endpoint** dans `commons/endpoints/` (périmètre,
   ouverture, format, paramètres, mots-clés, FAQ).
4. **Pré-cadrage technique** (brouillon, pas un plan de production) : contrat
   cible pressenti, points d'attention SIADE, artefacts probablement concernés.

Principe directeur : **ne pas se contenter du swagger**. Tester réellement
l'API, mesurer le remplissage des champs sur un échantillon, et croiser avec les
**cas d'usage** d'API Entreprise pour décider quoi exposer.

## Déroulé

Suivre ces étapes dans l'ordre. Ne pas sauter l'étape 2 (tests réels) : le
swagger ment souvent (champs vides en prod, types optionnels toujours nuls,
endpoints non autorisés pour la clé…).

### 1. Réunir les entrées

**Demander à l'utilisateur de déposer dans un dossier dédié
(`sandbox/api/<NOM-API>/`) tous les documents amont** — a minima le **swagger /
OpenAPI**. Travailler à partir de ce dossier.

Ce dont l'exploration a besoin (ne pas inventer ce qui manque, demander) :

- **Swagger / OpenAPI** du fournisseur (obligatoire).
- **Produit cible** : API Entreprise ou API Particulier. Pour API Particulier,
  préciser la modalité envisagée si elle est connue : Identité pivot,
  FranceConnect, identifiant métier, ou combinaison.
- **Doc métier** : à quoi sert la donnée, contexte réglementaire, vocabulaire du
  domaine. Si l'utilisateur « n'y connaît rien », prévoir un **encart
  pédagogique** dans le doc d'exploration.
- **Besoins usagers** : demander s'il existe un **recensement des besoins**
  (quel acteur demande quoi, pour quel cas d'usage, sous quelle base légale).
  C'est ce qui transforme la recommandation « quoi exposer » de générique en
  concrète, et qui permet de positionner l'API par rapport à l'existant
  (complément vs doublon). À utiliser en étape 4.
- **Accès de test** : tout ce qu'il faut pour appeler l'API réellement et être
  **autonome** — URL de base (souvent absente du swagger), auth (clé/token,
  tunnel SSH, mTLS…), identifiants de test valides. Les **modalités techniques
  sont à l'appréciation du dev fournisseur** : lui demander de fournir ce qui
  rend les appels possibles, sans présumer du moyen.
- **Secret** : ne jamais afficher un token ; le consommer via `$(cat fichier)`
  ou une variable d'env, et ne pas le committer.

### 2. Tester l'API

Vérifier l'accès puis récupérer un échantillon. Utiliser `scripts/probe_api.sh`
(un appel : statut + corps joli) pour dégrossir, puis `scripts/sample_api.sh`
pour constituer un échantillon (50–150 entités).

```bash
scripts/probe_api.sh "<URL>" "X-API-Key: $(cat .token)"
```

**Obtenir des clés d'appel valides** : pour API Entreprise, tirer un échantillon
de **SIRET/SIREN réels** de l'API publique annuaire
(`recherche-entreprises.api.gouv.fr/search`), filtrable par `tranche_effectif_salarie`,
`etat_administratif`, `nature_juridique`, etc. — c'est la source la plus rapide
pour un échantillon représentatif. Ne pas inventer d'identifiants.

**Boucler proprement** : `scripts/sample_api.sh` ouvre **une seule** connexion
réutilisable (gère le cas tunnel SOCKS/SSH pour les API derrière allowlist IP),
boucle sur une liste d'ids, journalise `id,endpoint,http,rows` en CSV et sauve
les payloads non vides. Préférer ce script à des appels un par un (l'allowlist IP
et l'absence d'URL de base dans le swagger sont la norme, pas l'exception).

Vérifier systématiquement :

- l'endpoint répond `200` (et `401` sans token, pour confirmer l'auth) ;
- quels endpoints sont **autorisés pour notre clé** (un `403`/`401` cible un
  scope manquant, pas forcément une panne) ;
- **chaque famille d'endpoint au moins une fois** : noter les `500` / non
  implémentés en DEV (un endpoint au swagger n'est pas un endpoint qui marche —
  ex. vues secteur/agrégées souvent cassées en démo) ;
- les limites des endpoints batch (taille max de lot, instabilité).
- pour API Particulier : la modalité d'appel réelle (Identité pivot,
  FranceConnect, identifiant métier), les paramètres obligatoires, la tolérance
  du matching et les cas où une personne non retrouvée renvoie un `404`
  fonctionnel.

### 3. Disséquer le modèle de données

Sur l'endpoint de **détail** principal, documenter **chaque champ** : type,
description, exemple, et **taux de remplissage mesuré** sur l'échantillon
(`scripts/field_stats.py`).

```bash
scripts/field_stats.py /tmp/echantillon/*.json
scripts/field_stats.py --format markdown --enum-limit 20 /tmp/echantillon/*.json > stats_champs.md
```

Couvrir :

- champs racine + **sous-objets** + objets contenus dans les listes (adresse,
  personnes/dirigeants, documents, événements…) ;
- **fichiers / documents** attachés (types, métadonnées, mode de
  téléchargement) ;
- **événements / historisation** si l'API en expose ;
- **valeurs d'énumération** et fréquences observées (`type`, `statut`,
  `etat`, `categorie`, etc.) ;
- **diversité inter-entités** (détection des fixtures) : un champ rempli à 100 %
  mais avec **une seule valeur distincte** sur 50-150 entités différentes est un
  signal d'alerte. `field_stats.py` affiche le nombre de valeurs distinctes ; si
  les données ne varient quasiment pas d'une entité à l'autre, **suspecter un
  environnement à fixtures** (le DEV rejoue des profils canned) et **exiger une
  recette avec vraies données** avant tout engagement — le remplissage mesuré
  n'est alors pas représentatif ;
- **cohérence / qualité interne** (distinct du remplissage) : formats
  incohérents d'un même champ (ex. code sur 2 vs 5 caractères), libellés qui ne
  correspondent pas au code, champ au **nom trompeur** (ex. « code_postal »
  contenant un département), valeurs d'un champ qui changent de type ou de
  comportement entre endpoints. Ces incohérences deviennent des questions
  fournisseur ;
- les **pièges du jeu de test** : données anonymisées, champs systématiquement
  vides en DEV (schéma présent mais non alimenté), placeholders.

### 4. Croiser avec les cas d'usage

Décider **quoi exposer** selon l'usage côté API Entreprise / Particulier, pas
selon ce que l'API offre « par défaut ». Lire `references/cas-usage-et-fiche.md`
pour les cas d'usage récurrents et le mapping donnée → usage. **Si un
recensement des besoins usagers a été fourni (étape 1)**, le croiser
explicitement : tableau besoin → couverture par l'API (exposé / prévu / absent),
et positionner l'API par rapport à l'existant (complément ciblé vs doublon vs
réponse au besoin dominant). Comparer avec une **fiche existante proche** dans
`commons/endpoints/` (réutiliser ses partis pris : ouverture, structure).
Attention aux versions **dépréciées** : se caler sur la fiche la plus récente.

### 5. Identifier les bloquants d'intégration

Vérifier explicitement (pièges les plus coûteux quand découverts tard) :

- **Clé d'appel** : peut-on interroger par **SIREN/SIRET** ? C'est la clé
  d'entrée d'API Entreprise. Si l'API n'indexe que par son id interne →
  **bloquant**, à remonter au fournisseur.
- **Modalité API Particulier** : peut-on interroger par Identité pivot,
  FranceConnect ou identifiant métier ? Quels paramètres ont le plus de poids
  dans l'identification et comment interpréter un `404` ?
- **Ouverture** : données publiques vs protégées vs open data (pré-remplissage).
  Repérer le gating des données personnelles (RGPD).
- **Rate limiting & sécurité** : quotas, filtrage IP, mTLS, rotation de clé.
- **Robustesse** : préférer **1 endpoint API Entreprise = 1 appel fournisseur**
  (dégradation partielle plutôt que panne totale) ; éviter d'agréger plusieurs
  appels amont derrière un endpoint.
- **Contrat cible provisoire** : pressentir ce qui irait dans `data`, `links`
  et `meta`, les erreurs fournisseur importantes, les règles de cache/ping, et
  les artefacts SIADE probablement concernés. Rester au niveau débroussaillage :
  ne pas écrire le plan de production complet.

### 6. Produire les livrables

Rédiger tous les livrables en **français correct, avec accents, en UTF-8**.

- **Doc d'exploration** : suivre le plan de
  `references/plan-doc-exploration.md`. Rédiger en `.md`, puis générer le PDF en
  utilisant un **skill de conversion PDF s'il en existe un** ; sinon, l'outillage
  local (pandoc/weasyprint). Si la conversion PDF bloque, le `.md` suffit. Pour
  un envoi au PO, privilégier un **PDF unique auto-portant** qui bundle le doc
  d'exploration **+ ses annexes** (stats, pré-cadrage, questions, payloads), avec
  sauts de page entre sections.
- **Doc de questions** : suivre `references/questions-checklist.md`. Fichier
  **`.txt`** en **bullet points** clairs, **vouvoiement** (exploitable en mail
  comme dans Tchap). Questions classées par priorité, **bloquants en tête**.
- **Fiche endpoint** : rassembler les champs listés dans
  `references/cas-usage-et-fiche.md` (s'appuyer sur les `template.*.example` de
  `commons/endpoints/`). Le skill `edit-endpoint` peut prendre le relais pour
  l'écriture effective.
- **Pré-cadrage technique** : produire une section ou un fichier court. **Séparer
  deux registres** : (a) un **design recommandé et assumé** (« si le fournisseur
  est propre, voilà ce que je conseille » — endpoints, maille, format de réponse,
  ordre de mise en œuvre, avec le pourquoi de chaque choix) ; (b) les
  **questions ouvertes** qui restent à confirmer. Ne pas se contenter de lister
  des arbitrages : **trancher**, puis isoler ce qui reste incertain. Couvrir :
  endpoints pressentis, paramètre(s) d'appel, découpage `data` / `links` /
  `meta`, erreurs à mapper, besoin éventuel de document download, et liste
  indicative des zones du dépôt à regarder ensuite (`siade`, `commons/endpoints`,
  mocks, SDK clients si signature publique).

## Conventions

- Travailler dans `sandbox/api/<NOM-API>/` (documents amont déposés par
  l'utilisateur + livrables au même endroit).
- Rédiger les livrables en **français correct avec accents** (UTF-8).
- Conserver des noms de livrables stables quand c'est possible :
  `exploration.md`, `questions_fournisseur.txt`, `stats_champs.md`,
  `pre_cadrage_technique.md`, `payloads_anonymises/`, et le bundle pour le PO
  `dossier_<NOM-API>.pdf`.
- Ne jamais committer le token ni des payloads bruts contenant des données
  réelles non anonymisées.
- Anonymiser tout payload d'exemple inséré dans un livrable (masquer SIRET,
  tronquer les textes longs, réduire les listes).
