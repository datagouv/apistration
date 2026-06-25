# Plan du document d'exploration

Document high level destiné au PO (et à l'équipe). Rédigé en `.md`, converti en
`.pdf` simple si l'outillage local le permet. Si la conversion PDF bloque, le
`.md` suffit. Rester factuel : distinguer ce qui est **mesuré** (échantillon
réel) de ce qui est **supposé**.

## En-tête

Titre, destinataire (ex. PO API Entreprise), auteur, date, source (nom de l'API
+ environnement testé + URL de base).

## Encart pédagogique (si domaine peu connu du lecteur)

Expliquer le métier en quelques paragraphes : qu'est-ce que l'entité manipulée,
les types/catégories, le vocabulaire, les obligations réglementaires qui
expliquent certains champs. À insérer tôt dans le document.

## 1. Contexte & méthode

- Environnement testé, anonymisation éventuelle des données de test.
- Taille de l'échantillon analysé, comment les ids ont été obtenus.
- Pagination / volumétrie totale disponible.
- Produit cible envisagé : API Entreprise ou API Particulier. Pour API
  Particulier, préciser la modalité testée ou supposée : Identité pivot,
  FranceConnect, identifiant métier.

## 2. Vue d'ensemble de l'API

Tableau des endpoints (méthode, path, usage). Distinguer endpoints « liste »
(résumé léger) des endpoints « détail » (payload riche). Noter les endpoints
non autorisés pour la clé.

## 3. Détail du payload de l'endpoint principal

- **Tableau champ par champ** : nom, type, description, **taux de remplissage
  mesuré**, remarque. C'est le cœur du document.
- Sous-sections pour les **sous-objets** (adresse normalisée/géocodée,
  personnes/dirigeants, documents, événements, etc.) avec un exemple JSON.
- Tableau des **valeurs d'énumération** importantes (types, états…) avec leur
  fréquence.
- Pour les listes : cardinalité observée (liste vide, 1 élément, plusieurs
  éléments) et champs réellement remplis dans les éléments.

## 4. Fichiers / documents

Métadonnées disponibles, **types de documents** et leur fréquence, mode de
téléchargement (binaire, URL), intérêt de chaque type.

## 5. Événements / historisation (si applicable)

Ce que trace l'API (modifications, snapshots avant/après), champs clés.

## 6. Limitations & points d'attention

Lister les **bloquants en tête** (encadré visible). Typiquement : pas d'accès
par SIREN/SIRET, champs vides en DEV, scope manquant, limites de batch, données
anonymisées, champs jamais remplis.

## 7. Contrat cible provisoire

Pré-cadrage technique, sans écrire le plan de production complet :

- endpoint(s) API Entreprise / Particulier pressentis ;
- paramètre(s) d'appel : SIREN, SIRET, RNA, Identité pivot, FranceConnect,
  identifiant métier ;
- découpage probable `data` / `links` / `meta` ;
- documents à exposer en URL ou en binaire, si applicable ;
- erreurs fournisseur à mapper : non trouvé fonctionnel, indisponibilité,
  timeout, réponse inexploitable ;
- règles à clarifier plus tard : cache, ping, maintenance, SDK clients si la
  signature publique évolue.

## 8. Recommandations pour API Entreprise / Particulier

- **8.0 Préalable bloquant** s'il y en a un (ex. clé d'appel SIREN/SIRET,
  impossibilité de matcher une identité, identifiant interne inaccessible).
- **8.1 Cadre & découpage** : comparer à une fiche existante du catalogue,
  poser le principe 1 endpoint = 1 appel fournisseur, niveaux d'ouverture
  (protected / open_data).
- **Mapping cas d'usage → données** (tableau).
- **Ce qu'on expose / sous condition / ne pas exposer** (justifié).
- **Points de vigilance** de mise en œuvre (RGPD, clé d'appel, fraîcheur,
  robustesse, mise à jour des SDK clients).

## Annexe — exemples de payloads (anonymisés)

Un exemple par type d'endpoint (détail, événements, liste). Masquer SIRET,
tronquer les textes longs, réduire les listes en indiquant les totaux.
