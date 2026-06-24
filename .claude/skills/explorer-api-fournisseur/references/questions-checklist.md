# Checklist des questions au dev fournisseur

Catégories à balayer. Garder uniquement les questions pertinentes pour l'API en
cours. **Mettre les bloquants en tête.**

Format du livrable : fichier **`.txt`**, **bullet points** clairs, regroupés par
thème, **vouvoiement** — exploitable aussi bien dans un mail que dans Tchap (pas
de `#`, `**`, backticks). Formuler les questions ci-dessous au vouvoiement.

## Clé d'appel (souvent BLOQUANT)

- Peut-on récupérer une entité par **SIRET / SIREN** ? Sinon quelle est la clé
  d'appel (identifiant interne uniquement ?) et la méthode recommandée ?
- Existe-t-il un endpoint de recherche ? Est-il autorisé pour notre clé ?
  Permet-il un **match exact** (vs plein texte) ?

## Modalités API Particulier (si concerné)

- L'API peut-elle être appelée avec une Identité pivot ? Quels champs sont
  obligatoires et lesquels améliorent fortement le matching ?
- L'API peut-elle être appelée via FranceConnect ? Si oui, quelles données du
  jeton sont utilisées pour identifier la personne ?
- Existe-t-il un identifiant métier plus fiable que l'identité ? Comment est-il
  obtenu par un usager ou une administration ?
- Comment distinguer une personne réellement non trouvée d'une identité
  insuffisamment précise ou ambiguë ?
- Quels exemples de personnes de test couvrent les cas limites utiles :
  homonymie, naissance à l'étranger, changement de nom, dossier récent,
  bénéficiaire non éligible ?

## Données métier / champs

- Quels champs vides en environnement de test sont **réellement alimentés en
  prod** ? Source et fréquence de mise à jour ?
- Comment sont calculés les champs dérivés / indicateurs ?
- Énumérations : liste exhaustive des valeurs possibles d'un champ « type » /
  « état » ?
- Garantie de présence : quels champs sont toujours là vs `null`/absents ?
- Les listes peuvent-elles être vides ? Quelle cardinalité maximale réaliste
  faut-il prévoir pour les listes de documents, personnes, établissements ou
  événements ?

## Données de test / fixtures (si environnement DEV)

- L'environnement de test renvoie-t-il de **vraies données** par entité, ou un
  jeu de **fixtures** rejoué (mêmes valeurs quel que soit l'identifiant) ?
- Existe-t-il une **recette/préprod avec données réelles** (sous habilitation)
  pour valider la forme et le remplissage exacts avant la prod ?

## Cohérence / qualité des données (incohérences constatées)

- Champs dont le **format varie** (ex. un code tantôt sur 2, tantôt sur 5
  caractères) : quelle est la règle et la nomenclature de référence ?
- **Libellés** qui ne correspondent pas au code associé : bug ou comportement
  attendu ?
- Champs au **nom trompeur** (ex. un « code postal » contenant un département) :
  pouvez-vous confirmer le contenu réel et/ou clarifier le nom ?
- Champs dont le **type ou le comportement change** d'un endpoint à l'autre
  (ex. même champ `null` ici, `0` là) : est-ce normal ?
- Champs **non documentés** présents dans les réponses : à quoi servent-ils,
  faut-il les ignorer ?

## Données personnelles / sensibles

- Les données personnelles (dirigeants…) sont-elles réelles en prod ?
- Comportement exact du flag de confidentialité (objet vidé, partiel, masqué) ?

## Documents / fichiers

- Durée de validité des identifiants / URLs de fichiers ? Purge / expiration ?
- Formats, types de documents, fiabilité de présence ?

## Endpoints & accès

- Périmètre prod : couverture complète ? Volumétrie réelle vs environnement de
  test ?
- Endpoints réservés (ex. vue dédiée à un consommateur) : peut-on y accéder ?
- Quels codes HTTP et formats d'erreur sont renvoyés pour : non trouvé,
  mauvais paramètre, droits insuffisants, indisponibilité, timeout, réponse
  partielle ?

## Sécurité & exploitation (à anticiper côté intégration)

- Rate limiting (req/s, quotas par clé, burst) ? Seuils par endpoint ?
- Contrôle d'accès : filtrage IP / allow-list, mTLS ? IP sortantes à déclarer ?
- Gestion des clés (rotation, révocation, durée de vie) ?
- SLA / disponibilité, fenêtres de maintenance ?
- Environnement de **recette avec données réelles** (sous habilitation) pour
  valider la forme exacte des payloads avant prod ?
- Contraintes utiles au pré-cadrage : timeout recommandé, latence habituelle,
  cache autorisé ou interdit, route de supervision/ping disponible ?
