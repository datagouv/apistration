---
name: write-content
description: >
  Rédiger ou relire un contenu publié sur les sites API Entreprise et API
  Particulier : article de blog (`site/config/blog_posts/`), fiche métier,
  FAQ et historique d'un endpoint (`commons/endpoints/`), FAQ et fiches
  pratiques (`site/config/locales/`). Règles de rédaction et de mise en
  forme DSFR tirées des reviews éditoriales. Triggers : "écrire un article
  de blog", "rédiger l'article", "annoncer la fonctionnalité sur le blog",
  "rédiger la FAQ", "relire le texte de la fiche", "améliorer la
  rédaction".
---

# Rédiger un contenu publié

Règles tirées des reviews éditoriales de Dorine (chargée de contenu) :
PR #413 (article `attestation-pdf-verifiable.md`), PR #288 (documentation
de l'espace éditeur) et ses propres relectures de fiches métier. Chaque
règle donne un avant / après. Elles valent pour tout texte lu par des
usagers : articles, fiches, FAQ, historique, documentation.

## L'exactitude passe avant le style

Une reformulation plus claire mais fausse est rejetée. Vérifier dans le
code chaque affirmation technique (qui détient quoi, qui appelle quoi,
durées, limites, codes HTTP) avant de l'écrire, et avant d'accepter une
suggestion de relecture.

- Suggestion rejetée : « sans la clé détenue par le logiciel de gestion de
  l'EAJE ». Le jeton est chiffré et déchiffré par le serveur d'API
  Particulier ; texte final : « sans la clé détenue par API Particulier ».
- #288 : la relecture a signalé un process décrit faux (qui dépose
  l'habilitation) ; en reprenant le texte, l'auteur a trouvé une autre
  erreur du même genre : « Seul le couple `recipient` / `delegation_id`
  est spécifique à l'usage éditeur » → « Seul le `delegation_id` est
  spécifique… » (`recipient` est obligatoire sur tous les appels API
  Entreprise).

## Structure

### Un plan par étape, puis par public

Ordonner les parties dans l'ordre où le lecteur en a besoin, pas dans
l'ordre de développement de la fonctionnalité. Pour un article qui
présente une fonctionnalité, le plan par défaut : contexte, solution
(scénario d'usage, contenu, sécurité, choix de conception), puis mise en
œuvre (appel API, vérification, environnement de test). Une information
transverse (durée de validité, limites) est répartie dans les parties qui
en ont besoin, pas isolée dans sa propre partie.

- Avant (`95449be84e`, 9 parties au même niveau) : « Pourquoi une
  attestation vérifiable ? », « Le fonctionnement en bref », « Demander
  une preuve avec l'en-tête X-Generate-Proof », « Le contenu de
  l'attestation PDF », « Vérifier une attestation », « Durées de
  validité », « Sécurité et données personnelles », « Pourquoi un QR code
  plutôt qu'une signature électronique ? », « Tester en environnement de
  test ».
- Après : « Contexte », « Solution proposée » (scénario d'usage, contenu,
  consultation sans résultat, sécurité, choix de conception), « Utiliser
  la solution » (appel API, procédure de vérification, environnement de
  test). « Durées de validité » disparaît : 5 minutes va avec le
  téléchargement du PDF, 5 ans avec la vérification.

### Annoncer à qui s'adresse une partie destinée à un public précis

Quand une partie vise un public particulier (intégrateurs, agents de
contrôle), son introduction le nomme et liste ce qu'elle contient.

- Avant : « Cette partie s'adresse aux éditeurs de logiciels de gestion. »
- Après : « Cette partie s'adresse aux éditeurs de logiciels de gestion
  d'EAJE. Elle explique : » suivi d'une liste, une puce par sous-partie.

Quand une sous-partie vise un autre public que la partie (l'agent CAF dans
une partie pour les éditeurs), l'écrire à la 3e personne (« L'agent chargé
du contrôle scanne… ») et dire au lecteur de la partie quoi en faire
(« à relayer aux structures qui utilisent votre logiciel »).

### Titres : nommer ce que le lecteur trouve

Le titre dit ce que contient la partie, du point de vue de son lecteur,
de préférence en groupe nominal. Un préfixe situe la partie dans le
raisonnement (« Contexte : », « Choix de conception : »). Une question
reste possible quand c'est celle que se pose le lecteur : l'article
final garde « Contexte : pourquoi ajouter une attestation vérifiable ? »
(proposé par la relectrice) et « Quel mode choisir ? ». Titres corrigés
en relecture :

- « Vérifier une attestation » → « Procédure de vérification d'une
  attestation »
- « Pourquoi un QR code plutôt qu'une signature électronique ? » →
  « Choix de conception : un QR code plutôt qu'une signature électronique »
- « Le fonctionnement en bref » → « Scénario d'usage »

Un libellé dit au lecteur ce qui le concerne : « Paramètres » → « Vos
informations éditeur », onglets « Vos délégations », « Vos jetons
éditeur » (#288).

Un titre destiné aux intégrateurs reprend les termes du contrat d'API
qu'ils chercheront dans le swagger, pas un nom inventé : « Appel API avec
l'en-tête X-Generate-Proof », pas « Appel API avec le mode attestation »
(aucun mode ne porte ce nom).

## Rédaction

### Scénario d'usage : qui fait quoi, et pourquoi, à chaque étape

Chaque étape nomme l'acteur, l'action et son but. Lier la fiche de l'API à
sa première mention.

- Avant : « 1. Le logiciel de gestion appelle l'API en ajoutant l'en-tête
  `X-Generate-Proof: pdf`. »
- Après : « 1. Pour récupérer les informations nécessaires au calcul de la
  participation familiale, le logiciel de gestion de l'EAJE appelle
  [l'API Participation familiale EAJE](…) **en ajoutant l'en-tête
  `X-Generate-Proof: pdf`**. »
- Avant : « 4. Lors d'un contrôle, l'agent scanne le QR code… »
- Après : « 4. Lors d'un contrôle, l'EAJE présente l'attestation à l'agent
  de la CAF. Pour s'assurer de l'authenticité du document, l'agent scanne
  le QR code… »

Même chose pour le contexte : dire pourquoi l'usage actuel existe, pas
seulement ce qu'il est (« Puis, pour conserver un justificatif en cas de
contrôle, ils faisaient une capture d'écran »).

### La première phrase pose le sujet sans fausse piste

Une tournure qui évoque une autre notion du domaine égare le lecteur
jusqu'à la phrase suivante.

- Avant (#288) : « Chaque ligne expose le jeton principal de
  l'habilitation, qui permet d'appeler l'API pour le compte de
  l'organisation cliente. » (« pour le compte de » fait penser à la
  délégation)
- Après : « Chaque ligne expose le jeton principal rattaché à
  l'habilitation du client. »

### Dire à quoi ressemble ce dont on parle

Un identifiant, un code, une valeur attendue : donner sa forme.

- « Le lien entre l'éditeur et l'habilitation d'une administration
  cliente » → « …, identifié par un **UUID** (le `delegation_id`) » (#288)
- Déjà juste dans le premier jet de #413 : « le code de vérification,
  10 caractères au format `XXXX-XXXX-XX` ».

### Pas de formule vague ni de jargon interne

Une formule qu'un développeur de l'équipe comprend n'est pas comprise par
le lecteur. Remplacer par ce qui se passe concrètement, les règles qui
s'appliquent ou le comportement attendu.

| Signalé comme incompréhensible | Version finale |
|---|---|
| « Les champs vides sont omis. » | « Un champ que la caisse ne renseigne pas, comme un nom d'usage absent, n'apparaît pas non plus. » |
| « ne contient que des données minimisées » | « ne contient que des données partiellement masquées : les 3 premières lettres du nom de naissance, le mois et l'année de naissance… ([détail des règles](#minimisation)) » |
| « il doit être traité avec le même soin que le document » | « comme le PDF, il ne doit être communiqué qu'aux personnes chargées du contrôle, et jamais publié ni transmis à d'autres destinataires » |
| « Il n'y a pas de dossier à citer, seulement la question posée et la réponse obtenue » | « Le document indique le résultat de l'appel avec l'erreur renvoyée par l'API, l'organisme qui a répondu… » |
| « une réponse `404` qui [s'atteste](…) » | « une réponse `404` qui [donne lieu à attestation](…) » |
| « sans le scope adresse » | « si l'EAJE n'a pas obtenu les droits requis pour l'information « adresse » » |

Repérer en particulier : participes passés sans agent (« omis »,
« minimisé »), « avec soin », « de manière sécurisée », vocabulaire du
code (scope, payload, champ) dans un texte pour non-développeurs.

### Acronymes et références

Développer à sa première occurrence tout acronyme que le public visé ne
connaît pas forcément, et lier le texte réglementaire ou la fiche
cité. Les deux corrections de #413 :

- « La CAF contrôle… » → « La caisse d'allocations familiales (CAF)
  contrôle… »
- « au sens du règlement eIDAS » → « au sens du [règlement européen
  eIDAS](https://eur-lex.europa.eu/…){:target="_blank"} (*electronic
  IDentification, Authentication and trust Services*), qui encadre… »

### Procédures : l'indispensable, l'informatif, et le but de chaque étape

Pour une procédure à suivre (vérification, migration), dire ce que le
lecteur doit absolument contrôler, ce qui n'est qu'informatif, et à quoi
sert chaque étape.

- Avant : « 3. lit sur la page « Attestation authentique et valide », le
  code de vérification, le SIRET du demandeur, les dates… et une partie
  des données ; »
- Après : « 3. **lit le statut de l'attestation** : la page doit indiquer
  « Attestation authentique et valide ». Elle affiche aussi le SIRET du
  demandeur et les dates…, à titre d'information ; »
- « 2. **vérifie que l'adresse de la page est bien
  `particulier.api.gouv.fr`** (et s'assure ainsi qu'il n'est pas sur un
  site frauduleux) ; »

Une étape commence par son verbe en gras.

### Placement : une note se place à côté de ce qu'elle concerne

- La note « liste des champs figée pour une version d'API » est remontée
  au-dessus des captures du PDF qu'elle décrit.
- « Quel mode choisir ? » est remonté juste sous le tableau qui présente
  les deux modes, avant l'exemple d'appel.
- Une capture annoncée dans le texte est désignée (« comme l'exemple
  présenté ci-dessous »).
- Un texte d'introduction va sous le titre qu'il introduit ; s'il
  concerne toute la page, il passe en `{:.fr-text--lead}` sous le `h1`
  (#288).

## Fiches métier (`commons/endpoints/`)

Constantes des relectures de fiches par Dorine (complète le skill
`edit-endpoint`, qui couvre le format YAML) :

- **Périmètre** : « ✅ Cette API concerne… » puis « ❌ Elle ne concerne
  pas… », avec la raison d'une exclusion quand elle n'est pas évidente :
  « ❌ Elle ne couvre pas les
  véhicules immatriculés dans les collectivités d'Outre-Mer car elles
  disposent de leurs propres systèmes d'immatriculation. »
- **Fraîcheur des données** : rythme, source et raison du rythme, et la
  conséquence pour l'usager (`7d7ec96374`). Avant : « **Les données sont
  mises à jour trimestriellement** car le processus de recensement est
  trimestriel. » Après :

  ```
  **La DSNJ, et donc cette API, sont informées** :
  - **trimestriellement du recensement** d'un jeune car cette information est communiquée que tous les trois mois par les communes ;
  - **en temps réel de la participation à la journée de défense et citoyenneté**.
  ```

  suivi d'un avertissement : un jeune en règle peut ne pas encore être
  déclaré comme tel par l'API.
- **Typographie** : minuscule aux noms d'institutions et de prestations
  après la première lettre (« caisse nationale des allocations
  familiales (CNAF) », « allocation d'éducation de l'enfant handicapé
  (AEEH) »).
- **Gras** : sur l'information clé, pas sur les détails subordonnés
  (`4577ac6030` retire le gras de « la date d'ouverture du droit » et
  « l'organisme de rattachement », sous-éléments d'une liste dont les
  éléments principaux restent en gras).

## Mise en forme DSFR

Valable partout (articles, fiches, FAQ, documentation) :

- **Avertissement** (ne pas faire, risque) :
  `{:.fr-highlight.fr-highlight--caution}` puis `> ⚠️ …`. Avant, la
  consigne « ne transmettez ce lien qu'à des personnes habilitées » était
  noyée en fin de paragraphe (#413).
- **Exemple** : `{:.fr-highlight.fr-highlight--example}`. En simple texte
  gras, les exemples ressemblent à des titres et le lecteur ne relie plus
  le texte au bon exemple (#288).
- **Mise en avant d'une information** : `{:.fr-highlight}`. Posé sur un
  paragraphe, il ne couvre que ce paragraphe (titre en gras en début de
  paragraphe) ; posé sur une citation `>`, il couvre toute la citation,
  plusieurs paragraphes compris.
- **Liste de points à savoir** : un titre suivi d'une liste, pas un
  highlight (« À savoir pour votre intégration », #413). Le niveau du
  titre suit la hiérarchie (un cran sous la partie) ; `{:.fr-h5}` n'en
  règle que la taille.
- **Tableau** : même emphase sur la même sorte de valeur dans toutes les
  lignes (« jeton **JWT** » comme les autres valeurs attendues en gras,
  #288).
- **Liens externes** : `{:target="_blank"}`.

### Articles de blog

Fichier : `site/config/blog_posts/<api_entreprise|api_particulier>/<slug>.md`,
publié sur `/blog/<slug>`. Markdown kramdown avec ERB (`endpoint_path`,
`image_path`) ; images dans `site/app/assets/images/<api>/blog/`.

Les articles existants ne sont pas homogènes ; conventions par défaut
pour un nouvel article, sur le modèle de `attestation-pdf-verifiable.md` :

- **En-tête** : date (« Mardi 27 octobre 2026 - Publication »), `# Titre`,
  chapeau en `{:.fr-text--lead}` (ou `{:.fr-text--lg}`).
- **Sommaire** : `<nav class="fr-summary">` dès que l'article a plusieurs
  parties ; liens vers des ancres `<a name="…"></a>` posées dans les
  titres (`## <a name="contexte"></a>Contexte : …`). Le libellé du
  sommaire reprend le titre.
- **Espacements** : `<br/>` avant chaque `##`, `{:.fr-mt-6w}` avant chaque
  `###` qui suit un bloc de contenu.
- **Captures** : des captures qui se comparent (états d'un même écran)
  sont regroupées en un seul endroit, dans une grille
  `fr-grid-row--gutters` avec `fr-responsive-img` et un `alt` qui décrit
  le contenu. Les pages de vérification valide, sans résultat et invalide
  sont côte à côte dans la procédure de vérification (#413). Les captures
  d'un tutoriel, elles, restent à côté de l'étape qu'elles illustrent
  (`parametre-lieu-naissance-code-cog.md`).

Vérifier le rendu dans le navigateur (`bin/rails s` dans `site/`, puis
`/blog/<slug>`) : ancres du sommaire, highlights, grilles d'images.

## Relecture avant de proposer le texte

1. Le plan suit-il l'ordre de lecture ? Une partie destinée à un public
   précis le nomme-t-elle ? Les titres nomment-ils ce que le lecteur
   trouve ?
2. Chaque étape d'un scénario nomme-t-elle l'acteur et le but ?
3. La première phrase de chaque partie pose-t-elle le sujet sans
   ambiguïté ? Chaque identifiant ou valeur a-t-il sa forme ?
4. Reste-t-il une formule qu'un lecteur extérieur ne saurait pas traduire
   en comportement concret ?
5. Chaque acronyme peu connu du public est-il développé à sa première
   occurrence, chaque texte cité lié ?
6. Chaque note est-elle à côté de ce qu'elle concerne ?
7. Chaque affirmation technique a-t-elle été vérifiée dans le code ?
