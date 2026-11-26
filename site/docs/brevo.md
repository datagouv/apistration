# Brevo : configuration et bascule depuis Mailjet

Brevo remplace Mailjet pour trois usages du site :

- l'inscription des contacts DataPass aux listes, via l'API Brevo v3
  (`POST /v3/contacts`, cf. [webhooks.md](./webhooks.md)) ;
- le formulaire d'inscription à la lettre d'information, natif, qui
  déclenche le double opt-in Brevo via l'API ;
- l'envoi des e-mails transactionnels, en SMTP relay
  (`smtp-relay.brevo.com:587`, STARTTLS), forcé par
  `config/initializers/smtp.rb` en production, staging et sandbox : le
  `delivery_method` des fichiers d'environnement, réécrits au déploiement,
  ne compte pas. Les templates restent les vues
  MJML locales.

La bascule est big bang : les étapes 1 à 7 sont faites avant le déploiement.

## 1. Domaines expéditeurs

Les mailers envoient depuis `support@entreprise.api.gouv.fr` et
`support@particulier.api.gouv.fr` : authentifier les deux domaines.

1. *Expéditeurs, domaines et IP dédiées > Domaines > Ajouter un domaine*,
   pour `entreprise.api.gouv.fr` puis `particulier.api.gouv.fr`.
2. Publier dans la zone DNS les enregistrements que Brevo affiche : code
   de vérification Brevo (TXT), DKIM, et DMARC
   (`_dmarc`, au minimum `v=DMARC1; p=none; rua=mailto:...`).
3. SPF : ajouter `include:spf.brevo.com` à l'enregistrement SPF existant
   du domaine si Brevo le demande, sans retirer l'include Mailjet avant la
   fin de la bascule (un seul enregistrement SPF par domaine, 10 lookups
   DNS au plus).
4. Attendre que Brevo marque chaque domaine *Authentifié*.
5. *Expéditeurs* : créer les deux expéditeurs `API Entreprise
   <support@entreprise.api.gouv.fr>` et `API Particulier
   <support@particulier.api.gouv.fr>`.

## 2. Clé API et clé SMTP

Deux secrets distincts, dans *SMTP & API* :

- **Clé API** (onglet *Clés API*) : sert aux contacts. Une clé par
  environnement de préférence, pour pouvoir la révoquer seule.
- **Clé SMTP** (onglet *SMTP*) : sert au transactionnel. Utiliser comme
  login celui affiché sur la même page (souvent de la forme
  `xxxx@smtp-brevo.com`, parfois l'e-mail du compte sur les anciens
  comptes).

Dans *Sécurité > IP autorisées* : si la restriction est active, ajouter les
IP sortantes des serveurs production, staging et sandbox, sinon l'API répond 401
et le SMTP refuse la connexion (code 525).

## 3. Listes et attributs

1. *Contacts > Listes* : une liste API Entreprise (ID 3), une liste API
   Particulier (ID 4), et une liste de test (ID 5) pour staging et sandbox.
   Ces IDs sont dans `BrevoSettings` (`config/initializers/brevo.rb`) :
   une liste recréée change d'ID, à reporter. Ils ne sont pas dans
   `config/environments/`, que le déploiement réécrit.
2. *Contacts > Paramètres > Attributs de contact* : créer, s'ils manquent,

   | Attribut | Type |
   |---|---|
   | `PRENOM` | Texte |
   | `NOM` | Texte |
   | `CONTACT_DEMANDEUR` | Booléen |
   | `CONTACT_TECHNIQUE` | Booléen |
   | `CONTACT_METIER` | Booléen |

   `PRENOM` et `NOM` existent souvent déjà par défaut. Un attribut absent peut
   faire échouer l'appel, donc le webhook DataPass.

## 4. Double opt-in de la lettre d'information

Le formulaire des pages infolettre et d'accueil est servi par le site
(`POST /infolettre`). Il appelle `POST /v3/contacts/doubleOptinConfirmation`
avec la liste de l'API et l'ID d'un template de confirmation, tous deux
dans `BrevoSettings` (`config/initializers/brevo.rb`). Le contact n'entre
dans la liste qu'après avoir cliqué le lien de l'e-mail ; il arrive alors
sur `/infolettre/confirmation`, qui le renvoie sur la page infolettre avec
le message « Inscription confirmée ».

Pour chaque API :

1. *Campagnes > Templates > Nouveau template*, expéditeur de l'API.
2. Ajouter le tag `optin` au template : sans lui, Brevo répond
   « An active DOI template does not exist ».
3. Le bouton de confirmation pointe sur `{{ params.DOIurl }}` (et non
   `{{ doubleoptin }}`) : c'est ce qui renvoie sur le site
   (`redirectionUrl`) après confirmation.
4. Activer le template, puis reporter son ID dans `BrevoSettings`
   (staging et sandbox pointent sur un template de test).

Anti-spam, sans captcha :

- un champ caché (`reference`) : rempli, la demande reçoit la même
  confirmation sans appel à Brevo ;
- trois demandes par minute et par IP, toutes API confondues (`rate_limit`,
  compteur dans le Redis du cache sous un namespace fixe, partagé par les
  processus et les serveurs).

L'URL de retour après confirmation est construite sur l'hôte connu de
l'API (`SiteHost`), jamais sur l'en-tête `Host` de la requête.

## 5. Migration des contacts

Faire l'import la veille du déploiement, puis un rattrapage juste après
(étape 9).

1. Mailjet, *Contacts > Listes de contacts* : exporter en CSV chacune des
   deux listes, **désinscrits compris**, avec les propriétés `prénom`, `nom`,
   `contact_demandeur`, `contact_technique`, `contact_métier`.
2. Mailjet : exporter aussi la liste d'exclusion (blocklist) et les
   adresses en bounce dur.
3. Renommer les colonnes du CSV : `EMAIL`, `PRENOM`, `NOM`,
   `CONTACT_DEMANDEUR`, `CONTACT_TECHNIQUE`, `CONTACT_METIER`.
4. Brevo, *Contacts > Importer des contacts* : importer chaque CSV dans la
   liste de son API, en mettant à jour les contacts existants.
5. Désinscrits, exclus et bounces : les importer en blocklist (statut
   *blocklisté* pour l'e-mail à l'import, ou *Contacts > Blocklist*). Les
   contacts désinscrits d'une liste Mailjet mais pas globalement deviennent
   blocklistés globalement chez Brevo, donc pour les deux API : sans cela,
   le prochain webhook DataPass les réinscrirait à la liste.
6. Vérifier les volumes : nombre d'abonnés et de blocklistés par liste,
   Mailjet contre Brevo.

### Désinscription des campagnes

Une désinscription est globale : le contact passe en blocklist et ne
reçoit plus aucune campagne, des deux API. Le webhook DataPass n'envoie
jamais `emailBlacklisted`, il la respecte donc. Dans chaque campagne,
garder le lien de désinscription par défaut de Brevo (`{{ unsubscribe }}`),
jamais un formulaire de préférences par liste : une désinscription d'une
seule liste serait défaite au webhook suivant. En staging, vérifier qu'un
clic sur ce lien blocklist bien le contact.

## 6. Credentials

À ajouter dans les credentials de production, staging et sandbox (staging et
sandbox avec leurs propres clés et listes) :

| Clé | Valeur |
|---|---|
| `brevo_api_key` | clé API (étape 2) |
| `brevo_smtp_login` | login SMTP (étape 2) |
| `brevo_smtp_key` | clé SMTP (étape 2) |

En production une clé absente lève une `KeyError` : au démarrage pour les
clés SMTP, au webhook DataPass et à l'inscription à la lettre
d'information pour la clé API.
Toutes doivent donc être en place avant le déploiement.

Clés Mailjet à retirer une fois la bascule faite : `mj_apikey_public`,
`mj_apikey_private`, `mj_default_from_email`, `mj_list_id_entreprise`,
`mj_list_id_particulier`.

## 7. Test en staging

Avec les credentials de staging déployés :

1. Un webhook DataPass d'approbation ajoute bien les contacts à la liste de
   test, avec leurs attributs.
2. Blocklister un contact dans Brevo, rejouer un webhook qui le concerne :
   il doit rester blocklisté. Faire de même avec un contact retiré de la
   liste seulement : attendu, il y est réinscrit, d'où la désinscription
   globale (section 5, « Désinscription des campagnes »). Noter le
   résultat sur la PR.
3. Un e-mail transactionnel arrive, avec DKIM et DMARC `pass` dans les
   en-têtes.
4. Une inscription depuis la page infolettre envoie l'e-mail de double
   opt-in ; le lien ajoute le contact à la liste de test et ramène sur la
   page infolettre avec le message « Inscription confirmée ».
5. Refaire l'inscription avec une adresse déjà dans la liste, puis avec une
   adresse blocklistée : noter si l'e-mail part et si la confirmation lève
   la blocklist (la doc Brevo ne le dit pas).

## 8. Ordre de bascule

1. Étapes 1 à 4 dans Brevo.
2. Étape 5 (import), étape 6 (credentials des trois environnements).
3. Étape 7 en staging.
4. Merge et déploiement en production.
5. Rattrapage : réexporter de Mailjet les désinscriptions et inscriptions
   survenues depuis l'import, les reporter dans Brevo.
6. Vérifier en production un webhook DataPass et un e-mail transactionnel.
7. Couper Mailjet : désactiver les clés, retirer l'include SPF Mailjet et
   l'enregistrement DNS `redir.entreprise.api.gouv.fr` qui pointait vers
   Mailjet, retirer les clés `mj_*` des credentials.
