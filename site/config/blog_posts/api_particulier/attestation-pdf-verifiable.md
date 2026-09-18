Vendredi 18 septembre 2026 - Publication

# Participation familiale EAJE : une attestation PDF vérifiable pour les contrôles CAF

{:.fr-text--lead}
Les gestionnaires d'établissements d'accueil du jeune enfant (EAJE) qui récupèrent les données de participation familiale via API Particulier peuvent désormais obtenir, dans le même appel, **une attestation PDF vérifiable**. Elle remplace la capture d'écran de l'espace partenaire CAF et peut être contrôlée en quelques secondes par n'importe quel agent, avec un simple navigateur.

<nav class="fr-summary" role="navigation" aria-labelledby="fr-summary-title">
 <p class="fr-summary__title" id="fr-summary-title">Sommaire</p>
 <ol class="fr-summary__list">
  <li><a class="fr-summary__link" href="#pourquoi">Pourquoi une attestation vérifiable ?</a></li>
  <li><a class="fr-summary__link" href="#en-bref">Le fonctionnement en bref</a></li>
  <li><a class="fr-summary__link" href="#demander-une-preuve">Demander une preuve avec l'en-tête X-Generate-Proof</a></li>
  <li><a class="fr-summary__link" href="#contenu-pdf">Le contenu de l'attestation PDF</a></li>
  <li><a class="fr-summary__link" href="#verifier">Vérifier une attestation</a></li>
  <li><a class="fr-summary__link" href="#durees">Durées de validité</a></li>
  <li><a class="fr-summary__link" href="#securite">Sécurité et données personnelles</a></li>
  <li><a class="fr-summary__link" href="#pourquoi-qr-code">Pourquoi un QR code plutôt qu'une signature électronique ?</a></li>
  <li><a class="fr-summary__link" href="#tester">Tester en environnement de test</a></li>
 </ol>
</nav>

<br/>

## <a name="pourquoi"></a>Pourquoi une attestation vérifiable ?

Le montant de la prestation de service unique (PSU) versée par la CNAF à un EAJE dépend de la participation facturée aux familles, elle-même calculée selon un barème à partir de la base de ressources du foyer et du nombre d'enfants à charge. La CAF contrôle régulièrement que le tarif appliqué correspond bien à ce barème, y compris sur les exercices passés.

Jusqu'ici, pour justifier le tarif appliqué, les gestionnaires consultaient les données de la famille sur l'espace partenaire de la CAF, puis en faisaient une capture d'écran qu'ils imprimaient ou archivaient.

Avec [l'API Participation familiale EAJE](<%= endpoint_path(uid: 'cnav/psu') %>), les données arrivent directement dans le logiciel de gestion : il n'y a plus d'écran à capturer. Il fallait donc un justificatif auquel le contrôleur puisse se fier **sans avoir accès au logiciel de la structure**, et qu'il puisse vérifier plusieurs années après son émission.

<br/>

## <a name="en-bref"></a>Le fonctionnement en bref

1. Le logiciel de gestion appelle l'API en ajoutant l'en-tête `X-Generate-Proof: pdf`.
2. La réponse contient les données habituelles, plus un **lien de vérification**, un **code de vérification** et un **lien de téléchargement de l'attestation PDF**.
3. Le logiciel télécharge le PDF et l'archive dans le dossier de la famille.
4. Lors d'un contrôle, l'agent scanne le QR code du PDF, arrive sur une page hébergée par `particulier.api.gouv.fr`, et compare le code et les données affichés avec ceux du document.

<br/>

## <a name="demander-une-preuve"></a>Demander une preuve avec l'en-tête X-Generate-Proof

La preuve est **optionnelle** et se demande par un en-tête HTTP sur l'appel habituel `GET /v3/dss/participation_familiale_eaje/identite`. Les paramètres d'appel et l'habilitation sont les mêmes, aucun scope supplémentaire n'est nécessaire. Sans l'en-tête, la réponse est strictement inchangée.

{:.fr-table}
| **Valeur de l'en-tête** | **Ce que la réponse contient en plus** |
|-------------------------|----------------------------------------|
| *(absent)* | Rien, la réponse est identique à l'appel habituel. |
| `proof-only` | `meta.verification_url` : le lien de la page de vérification<br/>`meta.verification_code` : le code de vérification, 10 caractères au format `XXXX-XXXX-XX` |
| `pdf` | Les deux clés ci-dessus, plus :<br/>`links.attestation_pdf` : le lien de téléchargement du PDF<br/>`meta.attestation_pdf_url_expires_at` : l'expiration de ce lien (timestamp Unix, en secondes) |

Toute autre valeur de l'en-tête renvoie une erreur `400`.

{:.fr-h5}
### Exemple d'appel

```sh
curl -H "Authorization: Bearer $TOKEN" \
  -H "X-Generate-Proof: pdf" \
  -G "https://particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite" \
  --data-urlencode "nomNaissance=LEFEBVRE" \
  --data-urlencode "prenoms[]=ALEXIS" \
  --data-urlencode "sexeEtatCivil=F" \
  --data-urlencode "anneeDateNaissance=1982" \
  --data-urlencode "moisDateNaissance=12" \
  --data-urlencode "jourDateNaissance=27" \
  --data-urlencode "codeCogInseePaysNaissance=99100" \
  --data-urlencode "codeCogInseeCommuneNaissance=08480" \
  --data-urlencode "recipient=13002526500013"
```

Le bloc `data` est identique à l'appel habituel, seuls `links` et `meta` s'enrichissent (jetons raccourcis) :

```json
{
  "data": { "...": "identique à l'appel sans en-tête" },
  "links": {
    "attestation_pdf": "https://particulier.api.gouv.fr/api/attestations/gG6jYUuN…zT_Zvc6A.pdf"
  },
  "meta": {
    "verification_url": "https://particulier.api.gouv.fr/attestations/verification/ziNgXNNf…z8GkJg",
    "verification_code": "0FB6-AAF0-EE",
    "attestation_pdf_url_expires_at": 1789722067
  }
}
```

{:.fr-h5}
### Quel mode choisir ?

- **`proof-only`** suffit si vous voulez seulement archiver la preuve dans votre base : le lien et le code de vérification forment à eux seuls un justificatif, contrôlable pendant 5 ans. Aucun PDF n'est produit.
- **`pdf`** si vous avez besoin du document mis en forme, pour l'imprimer, le joindre à un dossier ou le transmettre.

{:.fr-h5}
### Télécharger le PDF

Il suffit de suivre `links.attestation_pdf`, **sans jeton d'accès** : le lien porte sa propre autorisation. Il est valable **5 minutes** et peut être téléchargé plusieurs fois pendant ce délai. Passé ce délai, il renvoie `410 Gone` : relancez simplement l'appel pour en obtenir un nouveau. Ne transmettez ce lien qu'à des personnes habilitées à voir les données, et ne le stockez pas.

{:.fr-highlight}
> **À savoir pour votre intégration**
> - **Chaque appel avec l'en-tête interroge la CNAF en direct** : le cache de réponses d'API Particulier n'est pas utilisé, pour que l'attestation reflète les données au moment de son émission. Chaque appel compte dans votre volumétrie et produit une nouvelle preuve, avec son propre code.
> - **Les liens sont longs** : de l'ordre de 800 caractères pour le lien de vérification (davantage pour une famille nombreuse), plus de 2 000 pour le lien de téléchargement. Prévoyez un champ texte sans limite de taille (pas de `VARCHAR(255)`) pour stocker `verification_url`.
> - **Le téléchargement est limité à 60 requêtes par minute et par IP**, ce qui laisse de la marge pour un traitement par lot.
> - La preuve n'est disponible que pour l'appel par identité pivot, pas pour l'appel via FranceConnect.

<br/>

## <a name="contenu-pdf"></a>Le contenu de l'attestation PDF

L'attestation reprend l'ensemble des données délivrées par l'API :

- **Allocataires** et **enfants** : nom de naissance, nom d'usage, prénoms, date de naissance, sexe, code INSEE de la commune de naissance ;
- **Adresse** ;
- **Paramètres de calcul de la participation familiale** : nombre d'enfants à charge, nombre d'enfants bénéficiaires de l'AEEH, base de ressources annuelles et année de calcul.

Seules les sections couvertes par votre habilitation apparaissent : sans le scope adresse, par exemple, l'attestation ne contient pas de section adresse. Les champs vides sont omis.

Le pied de page porte le **QR code**, également cliquable, le **code de vérification** et, à titre de traçabilité, le **SIRET de la structure** pour le compte de laquelle l'attestation a été émise, avec son numéro d'habilitation. Les documents produits en environnement de test portent le bandeau « Données de test — document sans valeur ».

<div class="fr-container--fluid">
 <div class="fr-grid-row fr-grid-row--gutters">
  <div class="fr-col-md-6 fr-col-12">
   <img src="<%= image_path('api_particulier/blog/attestation-pdf-verifiable-page-1.png') %>" class="fr-responsive-img" alt="Première page d'une attestation de test : en-tête République française, titre, code de vérification, sections allocataires, enfants et adresse"/>
  </div>
  <div class="fr-col-md-6 fr-col-12">
   <img src="<%= image_path('api_particulier/blog/attestation-pdf-verifiable-page-2.png') %>" class="fr-responsive-img" alt="Seconde page de l'attestation de test : paramètres de calcul, puis QR code, code de vérification et SIRET du demandeur en pied de page"/>
  </div>
 </div>
</div>

<div class="fr-download fr-mt-4w fr-mb-1v fr-ml-2w">
 <p>
  <a href="/files/exemple-cnaf-attestation-participation-familiale-eaje.pdf" download class="fr-download__link">Télécharger l'attestation d'exemple (données de test)
   <span class="fr-download__detail">PDF – 18 ko</span>
  </a>
 </p>
</div>

{:.fr-highlight}
Le **jeu de champs de l'attestation est figé pour une version d'API donnée**. Ajouter, retirer ou renommer un champ passe par une nouvelle version de l'API : deux attestations émises avec la même version ne peuvent pas présenter des champs différents. Seule la mise en page peut évoluer.

<br/>

## <a name="verifier"></a>Vérifier une attestation

La vérification ne demande aucune application ni aucun compte :

1. **Scannez le QR code** avec un smartphone, ou cliquez dessus si vous consultez le PDF sur un ordinateur.
2. **Vérifiez que l'adresse de la page est bien `particulier.api.gouv.fr`.**
3. La page affiche « Attestation authentique et valide », le code de vérification, le SIRET du demandeur, les dates d'émission et de fin de validité, et une partie des données.
4. **Comparez le code affiché avec celui imprimé sur le PDF**, puis les données : `LEF•••` avec `LEFEBVRE`, `12/1982` avec `27/12/1982`, et la base de ressources à l'identique.

Si le code ou les données ne correspondent pas, le document a été modifié. Si la page indique « Lien de vérification invalide ou expiré », le QR code a été altéré ou l'attestation a dépassé sa durée de validité.

<div class="fr-container--fluid">
 <div class="fr-grid-row fr-grid-row--gutters">
  <div class="fr-col-md-6 fr-col-12">
   <img src="<%= image_path('api_particulier/blog/attestation-pdf-verifiable-verification-valide.png') %>" class="fr-responsive-img" alt="Page de vérification d'une attestation valide : code de vérification, SIRET, dates, données minimisées des allocataires, nombre d'enfants et paramètres de calcul"/>
  </div>
  <div class="fr-col-md-6 fr-col-12">
   <img src="<%= image_path('api_particulier/blog/attestation-pdf-verifiable-verification-invalide.png') %>" class="fr-responsive-img" alt="Page de vérification d'un lien altéré : message « Lien de vérification invalide ou expiré »"/>
  </div>
 </div>
</div>

{:.fr-h5}
### Pourquoi la page n'affiche-t-elle pas tout ?

La page de vérification n'affiche volontairement qu'une **version minimisée** des données, suffisante pour comparer avec le PDF mais insuffisante pour reconstituer l'identité d'une personne :

- pour les allocataires, les **3 premières lettres du nom de naissance** et le **mois et l'année de naissance** ;
- pour les enfants, **leur nombre** uniquement ;
- ni prénoms, ni adresse ;
- les **paramètres de calcul en entier**, puisque ce sont précisément les données que le contrôle porte à vérifier.

Le PDF, lui, contient toutes les données.

<br/>

## <a name="durees"></a>Durées de validité

{:.fr-table}
| **Élément** | **Durée de validité** | **À expiration** |
|-------------|-----------------------|------------------|
| Lien de téléchargement du PDF | 5 minutes | `410 Gone` : relancez l'appel à l'API |
| Lien et code de vérification | 5 ans | la page indique « Lien de vérification invalide ou expiré » |

La durée de 5 ans couvre les contrôles de la CAF, qui peuvent porter sur plusieurs exercices passés. Elle ne peut pas être prolongée : au-delà, il faut émettre une nouvelle attestation.

<br/>

## <a name="securite"></a>Sécurité et données personnelles

**API Particulier ne stocke ni les attestations, ni les données qu'elles contiennent.** Chacun des deux liens transporte son contenu dans un jeton chiffré et authentifié (AES-256-GCM) : le serveur le déchiffre à la volée pour produire le PDF ou afficher la page de vérification. La moindre modification du lien le rend invalide, et sans la clé détenue par la plateforme, il est impossible de lire son contenu ou d'en fabriquer un faux.

Les deux liens n'ont pas le même profil de risque, et ne transportent donc pas les mêmes données :

- le **lien de téléchargement** contient toutes les données, mais n'est valable que 5 minutes ;
- le **lien de vérification** reste valable 5 ans, mais ne contient que les données minimisées.

La page de vérification ne dépose aucun cookie, ne charge aucun traceur, n'est ni indexée par les moteurs de recherche ni mise en cache, et est limitée à 5 consultations par minute et par IP.

{:.fr-h5}
### Limites

- **Ce n'est pas une signature électronique** au sens du règlement eIDAS : l'authenticité s'établit en comparant le document avec la page de vérification, pas dans un lecteur PDF.
- **La vérification se fait en ligne**, sur `particulier.api.gouv.fr`.
- **Le lien de vérification donne accès aux données minimisées pendant 5 ans** à quiconque le possède : traitez-le avec le même soin que le document lui-même.
- **Une page imitant la nôtre sur un autre domaine** peut afficher n'importe quoi : c'est pourquoi l'adresse de la page doit toujours être contrôlée.

<br/>

## <a name="pourquoi-qr-code"></a>Pourquoi un QR code plutôt qu'une signature électronique ?

Nous avons étudié plusieurs solutions avant de retenir celle-ci :

- **Une signature électronique du PDF avec un certificat qualifié** : elle suppose un certificat, une infrastructure de gestion de clés et leur renouvellement. Surtout, elle est rarement vérifiée en pratique par les destinataires, et disparaît dès que le document est imprimé.
- **Une signature des données sans chiffrement** : plus simple, mais les données personnelles seraient lisibles en clair dans l'URL, donc dans les historiques de navigation et les journaux des serveurs traversés.

Le QR code avec un jeton chiffré combine les avantages recherchés : une vérification en moins de 30 secondes avec un simple navigateur, qui fonctionne aussi sur papier, sans infrastructure supplémentaire ni stockage de données personnelles.

<br/>

## <a name="tester"></a>Tester en environnement de test

L'[environnement de test](<%= developers_path(anchor: 'tester-api-preproduction') %>) renvoie des données fictives et permet de tester la génération de bout en bout, avec le jeton de test public :

```sh
TOKEN=$(curl -s https://raw.githubusercontent.com/datagouv/apistration/develop/mocks/tokens/default)

curl -H "Authorization: Bearer $TOKEN" \
  -H "X-Generate-Proof: pdf" \
  -G "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite" \
  --data-urlencode "nomNaissance=LEFEBVRE" \
  --data-urlencode "prenoms[]=ALEXIS" \
  --data-urlencode "sexeEtatCivil=F" \
  --data-urlencode "anneeDateNaissance=1982" \
  --data-urlencode "moisDateNaissance=12" \
  --data-urlencode "jourDateNaissance=27" \
  --data-urlencode "codeCogInseePaysNaissance=99100" \
  --data-urlencode "codeCogInseeCommuneNaissance=08480" \
  --data-urlencode "recipient=13002526500013" > reponse.json

curl -o attestation.pdf "$(jq -r '.links.attestation_pdf' reponse.json)"
```

L'attestation d'exemple présentée dans cet article a été produite de cette manière. Sa page de vérification reste consultable jusqu'au 18/09/2031 : [ouvrir la page de vérification de l'exemple](https://staging.particulier.api.gouv.fr/attestations/verification/ziNgXNNf0LilP2LWameqeocSYfWVUuHEG7B7WC4NGtx8w6ZA2_9rCEtmPl0CVh66pUcG1zzL2Ugq71FrueTfcnx1XilNTSEIjvQ_6ufbKX-oN2iWFt_kLJnPGEcWC_snzS8iyp2xTKbEfODJIlZVPP2s3Oljz9QrOSQPJDzBuF0N30O2Kc_6YaVnMwyFuyvyX1HHbwhA2EHDDTLaKHOoOfJnkim75UFxI2zeL3y0Kl7od0yBwzQSQ5MZnZvE4x6A2YIRKpX7q5MSo4N65iGt5lkMXnLHWdPJhB5BXw8YpXtx6r5X96TNLfv_IVDwJHaLi4rK0UOGIfs4yi8VTfOjjw-kKRe1bBuNbcGEIsxOGmmy5Ndz7XV9UvyYRFb_SzY2mQnIAbKOaqfdslfrj0AW14bvy7pwprx282jcCT0piEDXHMd24Sl7zEQtDT2vaVgaK_HhfS6E7MitAzD-PUJe9o2rqKfS-Ofd3ov4f3hK7sUYiROs_2Ygc_5fo0QR7dA6mjLzAf0RE5M_pSjiwTCpJXGrR3vFFgzDUHQH0SUvJqkeCbM0f3JSdUGENixjmM9HQNlMnrQSLsP_KCS6BKOy_ukyuPmfjW3QNT16C1aYGD5jEeXwWjWD78g8oyvA5rrygO1G-g6sXkYma89ZpfHx--20aFrRvj4GcDWVhy--iM_Zqsn4RaLFqQA_z8GkJg){:target="_blank"}. Vous pouvez aussi scanner le QR code du PDF d'exemple.

Pour le détail des paramètres et des réponses, consultez [la fiche de l'API Participation familiale EAJE](<%= endpoint_path(uid: 'cnav/psu') %>).
