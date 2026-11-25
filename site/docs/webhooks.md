# Gestion des webhooks DataPass

## Introduction / contexte

DataPass intègre un système de webhooks qui envoie des payloads à une URL cible
en fonction du service, ceci à chaque changement d'état d'une demande associé à
ce dit service. Dans le cadre d'API Entreprise, ceux-ci nous servent à gérer
intégralement la communication envoyée aux utilisateurs, ainsi que la création
du jeton associé en cas de validation.

Pour le contexte, les emails étaient précédemment géré par DataPass, tandis que
la création du jeton était géré par un " bridge " custom côté DataPass.

A noter que certains emails (relatifs aux contacts RGPD) sont encore gérés côté
DataPass.

Pour plus d'infos sur les webhooks:

- [Documentation DataPass sur les
  webhooks](https://github.com/betagouv/datapass/blob/master/backend/docs/webhooks.md)
- [Implémentation technique pour API
  Entreprise](https://github.com/betagouv/datapass/blob/master/backend/app/notifiers/api_entreprise_notifier.rb)

## Implémentation technique

L'intégralité du traitement s'effectue à travers le controller
`DatapassWebhooksController`, où l'organizer `DatapassWebhook` est appelé.

Celui-ci effectue les tâches suivantes de manière séquentielle:

1. Trouve ou crée l'utilisateur (le demandeur)
1. Trouve ou crée la demande, en affectant les dernières valeurs (intitule,
   contacts etc...)
1. Si l'événement est une validation, crée le jeton associé
1. Mets à jour les contacts (demandeur, technique et métier) sur Brevo
1. Planifie l'ensemble des emails associés à la demande, en fonction de
   l'événement

Cette dernière étape s'appuie sur un fichier de configuration, expliqué
ci-dessous.

## Fichier de configuration

Les fichiers de configuration
[`config/datapass_webhooks_entreprise.yml`](../config/datapass_webhooks_entreprise.yml)
et
[`config/datapass_webhooks_particulier.yml`](../config/datapass_webhooks_particulier.yml)
planifient les emails aux divers contacts associés à la demande. Les emails
sont des vues Rails (MJML) de `APIEntreprise::AuthorizationRequestMailer` et
`APIParticulier::AuthorizationRequestMailer`, envoyées en SMTP par Brevo.

Ci-dessous un exemple avec les explications de chaque entrée:

```yaml
# L'environnement associé à la configuration
production:
  # Chaque clé à ce niveau correspond à un événement associé à la demande. La liste exhaustive se trouve dans la documentation DataPass
  # Une clé vide ou absente n'effectue aucun envoi d'email.
  created: {}
  send_application:
    emails:
      # Chaque entrée correspond à un email. Le champ 'template' est le nom de la méthode du mailer, donc de la vue, et doit être présent (il s'agit du seul champ obligatoire)
      - template: 'send_application'
  refuse_application:
    emails:
      - template: 'review_application'
        # La clé 'condition_on_authorization' permet d'appliquer une condition sur l'envoi de l'email. Cette condition est évaluée au moment de la réception du webhook et non lors de l'envoi. Cette condition doit être une méthode définie sur la classe AuthorizationRequestConditionFacade
        # Par défaut condition est évalué à true
        condition_on_authorization: 'demandeur_first_name_is_run?'
      - template: 'review_application_2'
        # Tableau des destinataires, doit être soit un modèle User soit un modèle Contact
        to:
          - 'authorization_request.contact_metier'
        # Tableau des destinataires en copie
        cc:
          - 'authorization_request.contact_technique'
          - 'authorization_request.demandeur'
```

Un test d'acceptance vérifie le format du fichier: si il y a une typo les tests
ne passeront pas.

Pour les conditions évaluées, vous trouverez le fichier ici:
[AuthorizationRequestConditionFacade](../app/lib/authorization_request_condition_facade.rb)

## Mise à jour des attributs des contacts

A chaque réception d'un webhook, les contacts (demandeur, contact technique et
contact métier, dédoublonnés par email) sont ajoutés à la liste Brevo de l'API
(`BrevoSettings`, `config/initializers/brevo.rb`) et leurs attributs
mis à jour. Le statut de blocklist n'est jamais envoyé : qu'un contact
blocklisté le reste est à vérifier en staging (cf. [brevo.md](./brevo.md),
étape 7). Les attributs, à créer au préalable dans Brevo, sont les suivants:

1. `PRENOM`, `string`, le prénom du contact
1. `NOM`, `string`, le nom du contact
1. `CONTACT_DEMANDEUR`, `boolean`, indique si le contact est le demandeur
1. `CONTACT_METIER`, `boolean`, indique si le contact est le contact métier
   (API Entreprise seulement)
1. `CONTACT_TECHNIQUE`, `boolean`, indique si le contact est le contact
   technique

Une erreur de l'API Brevo fait échouer le webhook.
