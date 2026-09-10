# API-SECU : les prestations sociales sur API Particulier

Description fonctionnelle de la chaîne qui relie API Particulier aux
caisses de la Sécurité sociale (CNAV, SNGI, RNCPS, CNAF, MSA). Ce
document ne parle pas d'implémentation ; pour le code, partir de
`siade/app/organizers/cnav/`.

Les points ci-dessous ont été validés avec le fournisseur de données,
notamment lors du point CNAV du 10 septembre 2026, ou recoupés avec
les tickets Linear et l'historique du projet.

## Les acteurs

### API-SECU

Guichet unique de la Sécurité sociale, exploité par la CNAV (Caisse
nationale d'assurance vieillesse). C'est le seul interlocuteur d'API
Particulier pour les prestations sociales et le quotient familial : on
ne parle jamais directement à une caisse.

API-SECU ne détient aucune donnée métier. Il reçoit une identité, la
contrôle, la fait transformer en NIR (numéro d'inscription au
répertoire), trouve la caisse compétente, lui pose la question et
relaie sa réponse. Nos routes le nomment `dss` (`/v3/dss/...`).

API-SECU applique ses propres règles métier sur les paramètres avant de
passer la main au SNGI pour l'identification. Ces règles ne sont pas
celles de l'identification : le sexe, par exemple, est aujourd'hui
obligatoire pour API-SECU alors qu'il ne pèse presque rien dans le
matching du SNGI. Un paramètre peut donc être refusé par le guichet
sans que cela dise quoi que ce soit sur les chances d'identifier la
personne.

### SNGI

Système national de gestion des identifiants. Référentiel des identités
de la Sécurité sociale, exploité par la CNAV.

Les caisses ne connaissent pas les identités civiles, uniquement des
NIR. Le SNGI est le seul système capable de passer d'une identité pivot
(nom de naissance, prénoms, date et lieu de naissance, sexe) à un NIR.
Sans cette conversion, aucune caisse ne peut être interrogée.

C'est ce qui explique le poids inégal des paramètres d'identification :
le nom de naissance, l'année de naissance et le lieu de naissance
suffisent souvent à trouver la personne si elle n'a pas d'homonyme, et
leur absence fait chuter le taux d'identification.

### RNCPS

Répertoire national commun de la protection sociale, exploité par la
CNAV. À partir du NIR, il indique le régime et la caisse de rattachement
de la personne. Une même personne peut avoir plusieurs rattachements,
potentiellement sur plusieurs caisses.

Les caisses y remontent aussi les droits ouverts pour les prestations,
mais les prestations elles-mêmes restent stockées chez chaque caisse.
Pour les statuts de prestation (statut RSA, statut AAH, prime
d'activité, etc.), le RNCPS sert donc d'annuaire : API-SECU y lit les
rattachements puis interroge la ou les caisses concernées, qui
répondent avec leurs prestations.

La complémentaire santé solidaire est l'exception : le RNCPS répond
lui-même, avec les droits que la CNAM (Assurance maladie) et la MSA
lui remontent, la CNAM n'étant pas encore branchée en direct sur
API-SECU.

### CNAF et MSA

Les caisses qui possèdent réellement les dossiers allocataires :

- CNAF : régime général, réseau des CAF ;
- MSA : régime agricole.

La CNAM (Assurance maladie) doit rejoindre la chaîne prochainement.

C'est chez elles que vivent le quotient familial, la composition
familiale, l'adresse et la participation familiale EAJE. Ces
informations ne remontent pas au RNCPS : le répertoire sait qu'une
personne a un droit ouvert à une prestation, il ne connaît pas le
contenu de son dossier. Pour les obtenir, API-SECU doit interroger la
caisse elle-même.

Les deux caisses ne fonctionnent pas au même rythme :

- la MSA recalcule en temps réel à chaque changement de situation ;
- la CAF met à jour une fois par mois, après le premier week-end du
  mois. Un appel sur le mois en cours avant cette bascule ne trouve
  rien : c'est une cause connue de 404 en début de mois ;
- seule la CAF sert un historique du quotient familial : le mois en
  cours et les 23 mois précédents.

## Le parcours d'une demande

1. L'administration appelle API Particulier avec l'identité pivot de
   l'usager, ou via FranceConnect qui fournit cette identité.
2. API Particulier contrôle la forme des paramètres et transmet à
   API-SECU.
3. **API-SECU** contrôle la saisie (format du nom, sexe présent, lieu
   de naissance connu). Un refus ici est un 400 avec un code d'erreur
   du guichet.
4. **SNGI** : conversion de l'identité en NIR. Aucune correspondance :
   l'appel s'arrête sur « identité non reconnue par le fournisseur ».
   L'usager est invité à vérifier ses informations.
5. **RNCPS** : à partir du NIR, recherche du régime et de la caisse de
   rattachement. Aucun rattachement : « allocataire non référencé auprès
   des caisses éligibles ».
6. Lecture de la donnée, selon l'endpoint :
   - statut de prestation : auprès de la ou des caisses de
     rattachement, sauf la complémentaire santé solidaire lue dans le
     RNCPS lui-même ;
   - quotient familial et participation familiale EAJE : auprès de la
     CAF ou de la MSA, selon le rattachement.
7. API-SECU relaie la réponse en indiquant la caisse qui a répondu.
   API Particulier la restitue, en nommant CAF ou MSA sur le quotient
   familial.

### Savoir qui a répondu

API-SECU renseigne dans sa réponse un en-tête avec le code de la caisse
interrogée. En-tête absent ou vide : l'appel a été bloqué avant
d'atteindre une caisse, au contrôle de saisie ou à l'identification
SNGI. La correspondance code / caisse est dans
`siade/app/organizers/cnav/retriever_organizer.rb`.

## Les refus d'API-SECU

Un refus peut venir de trois niveaux, avec des conséquences différentes
pour l'appelant.

| Origine | Exemple | Ce que l'appelant peut faire |
|---|---|---|
| Contrôle de saisie du guichet | format du nom, commune de naissance inconnue, sexe absent, département inconnu | corriger les paramètres |
| Identification (SNGI, RNCPS) | personne introuvable, aucun rattachement | vérifier l'identité, ou fermer le dossier |
| Caisse (CAF, MSA) | dossier absent, période hors historique, mauvais routage | rien sur l'identité ; changer la période ou réessayer plus tard |

Sur les statuts de prestation, une caisse qui ne répond pas dans la
chaîne produit une erreur RNCPS « dossier absent » alors que la
personne est bénéficiaire. Le fournisseur en a confirmé la cause en
2026 sans donner de délai de correction ; le quotient familial et
l'EAJE ne sont pas concernés. Par ailleurs un droit ouvert peut mettre
jusqu'à 30 jours à apparaître dans l'API, délai avéré sur la
complémentaire santé solidaire et suspecté sur les autres statuts.

Sur le quotient familial, deux refus de la caisse ne sont pas des
erreurs d'identité et sont restitués comme tels :

- **Période trop ancienne** : la CAF ne sert que le mois en cours et
  les 23 mois précédents. API Particulier refuse désormais une période
  plus ancienne avant tout appel (erreur `00355`). Si le guichet la
  refuse malgré tout, elle est restituée comme « période refusée par
  le fournisseur de données » et remontée comme anomalie : c'est notre
  contrôle qui a laissé passer. Un appelant qui balaie mois par mois
  sans s'arrêter au premier refus la produisait en masse.
- **Mauvais routage** : la personne a plusieurs rattachements, parfois
  sur plusieurs caisses, et API-SECU interroge une caisse qui n'a rien
  pour elle. Anomalie en cours d'investigation côté MSA, restituée
  comme erreur interne du fournisseur.

Le détail des codes du guichet et leur restitution côté API
Particulier est dans `siade/app/interactors/cnav/`.

## Ce qu'API-SECU ne fait pas

API-SECU ne filtre pas les données renvoyées par les caisses : c'est un
passe-plat. Le filtrage par âge des enfants sur la participation
familiale EAJE (moins de 7 ans pour les crèches) est appliqué par API
Particulier, pas par le guichet ni par les caisses. L'évolution
envisagée pour les garderies scolaires est un paramètre d'intervalle
d'âge porté par l'habilitation ; la CNAF et la MSA doivent confirmer
qu'elles peuvent le prendre en charge.

## Endpoints concernés

Tous les endpoints ci-dessous passent par API-SECU. Chacun existe en
deux modalités d'appel, `/identite` (identité pivot) et
`/france_connect`.

### Données CAF / MSA

| Prestation | Route v3 |
|---|---|
| Quotient familial et composition familiale | `/v3/dss/quotient_familial/{identite,france_connect}` |
| Participation familiale EAJE (prestation de service unique) | `/v3/dss/participation_familiale_eaje/{identite,france_connect}` |

### Statuts de prestation, données CAF / MSA via le RNCPS

| Prestation | Route v3 |
|---|---|
| Revenu de solidarité active | `/v3/dss/revenu_solidarite_active/{identite,france_connect}` |
| Prime d'activité | `/v3/dss/prime_activite/{identite,france_connect}` |
| Allocation aux adultes handicapés | `/v3/dss/allocation_adulte_handicape/{identite,france_connect}` |
| Allocation de soutien familial | `/v3/dss/allocation_soutien_familial/{identite,france_connect}` |
| Allocation de rentrée scolaire | `/v3/dss/allocation_rentree_scolaire/{identite,france_connect}` |
| Allocation d'éducation de l'enfant handicapé | `/v3/dss/allocation_enfant_handicape/{identite,france_connect}` |

Les fiches publiques de ces endpoints disent les données « issues du
RNCPS ». C'est un raccourci : le RNCPS donne le rattachement, la
prestation vient de la caisse.

### Statut de prestation, données RNCPS

| Prestation | Route v3 |
|---|---|
| Complémentaire santé solidaire | `/v3/dss/complementaire_sante_solidaire/{identite,france_connect}` |

Le RNCPS répond directement, alimenté par la CNAM pour le régime
général et la MSA pour le régime agricole. Une API distincte
d'éligibilité à la C2S, fondée sur les ressources, figure par ailleurs
dans la feuille de route CNAV.
