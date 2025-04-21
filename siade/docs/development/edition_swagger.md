# Édition du Swagger / OpenAPI

## Fonctionnement de la génération du fichier OpenAPI

Le fichier OpenAPI est généré de la façon suivante :

1. Un fichier par provider doit être crée dans le dossier `config/swagger_data/` au format `provider-name.yml`.

Ce fichier sert à définir la payload de sortie de nos endpoints.

Exemple simple avec le fichier dsnj.yml :

```yaml
# Nom du provider
dsnj:
  # Nom de l'endpoint tel que dans le code (en snake_case)
  # Correspond aux valeurs `SwaggerData` dans le fichier de spec `spec/requests/api_particulier/v3_and_more/<provider>/<resource>_spec.rb`
  service_national:
    # Nom de l'endpoint
    title: "API Service National"
    # Pour les tags, toujours uniquement "Prochainement" pour les APIs en développement.
    # Pour les APIs finalisées, choisir le tag correspondant (voir le swagger sur la page https://entreprise.api.gouv.fr/developpeurs/openapi ou son équivalent particulier, colonne de gauche)
    tags:
      - "Prochainement"
    # Description de l'endpoint
    description: "Cet endpoint renseigne le statut de la personne vis à vis de ses obligations de service national."
    # Description de la payload de retour. Si la payload de retour est un élément unique (un seul record), on utilise 'attributes'. Si on renvoie une liste, on utilise 'items' puisqu'on renvoie un tableau (cf examples suivants, ou l'endpoint v3/document_association dans mi.yml).
    attributes:
      # Premier champ de la payload
      # Toujours donner un title, type, description et example.
      # Si la liste de valeurs possibles est connue, il faut ajouter un enum.
      # Si le champs peut être null, il faut ajouter `nullable: true`.
      statut_service_national:
        title: Statut service national
        # Les types possibles sont : string, integer, boolean, array, object
        # En général, on ne renvoie pas d'integer, mais des strings contenant des nombres
        # Pour les objets, il faut ajouter un `properties` avec la liste des champs de l'objet (voir exemples suivants)
        # Pour les tableaux (array), il faut ajouter un `items` avec le type de l'élément du tableau (voir exemples suivants)
        # Le champs le plus souvent utilisé est `string`
        type: string
        description: Indique si la personne est en règle de ses obligations de service national. "en_regle" si la personne est en règle, "pas_en_regle" si la personne n'est pas en règle, "indetermine" si l'information n'est pas connue, "non_concerne" si la personne n'est pas concernée par les obligations de service national.
        example: en_regle
        enum:
          - en_regle
          - pas_en_regle
          - indetermine
          - non_concerne
      commentaires:
        title: Commentaires
        type: string
        description: Commentaires sur la situation de la personne
        example: Commentaire sur la situation
```

Exemple pour un attribute de type "object":

```yaml
sportif:
   title: "whatever API"
   tags:
    - "Whatever"
    description: "Whatever"
    attributes:
        date_naissance:
          type: "object"
          title: "Date de naissance du bénéficiaire effectif"
          # toujours ajouter additionalProperties: false pour bien préciser que nous ne renverrons pas d'autres champs (on ne rajoutera jamais de nouvelles clefs à la payload)
          additionalProperties: false
          properties:
            annee:
              title: "Année de la date de naissance"
              type: "string"
              example: "1990"
              nullable: true
            mois:
              title: "Mois de la date de naissance"
              type: "string"
              example: "01"
              nullable: true
              enum:
                - "01"
                - "02"
                - "03"
                - "04"
                - "05"
                - "06"
                - "07"
                - "08"
                - "09"
                - "10"
                - "11"
                - "12"
```

Exemple pour un attribute de type "array" :

```yaml
conventions:
   title: "whatever API"
   tags:
    - "Whatever"
    description: "Whatever"
    attributes:
        synonymes:
          type: "array"
          description: "Liste de synonymes connus de la convention"
          items:
            type: "string"
          example:
            - "syntec"
```

Le plus souvent, les arrays contiennent cependant des objects :

```yaml
subventions:
   title: "whatever API"
   tags:
    - "Whatever"
    description: "Whatever"
    attributes:
        paiements:
          title: "Liste des paiements versés"
          description: "Liste des paiements versés par FranceTravail au particulier."
          type: array
          # Si on connait le nombe minimum d'items, il faut le préciser
          minItems: 1
          items:
            title: "Paiement"
            type: object
            properties:
              date_versement:
                title: Date du paiement
                type: string
                example: "2021-01-01"
              montant_total:
                title: Montant total versé
                description: Montant total du paiement. Il s'agit de la somme des allocations, aides et autres paiements, moins le prélèvement de l'impôt à la source.
                type: number
                example: 123.4
```

2. Les données du fichier `config/swagger_data/provider.yml` sont utilisées dans le fichier de spec `spec/requests/api_particulier/v3_and_more/provider/endpoint_spec.rb`

Ce fichier de spec a plusieurs rôles :

- Il permet de tester le code de l'endpoint
- Il définit les paramètres d'entrée de l'endpoint
- Il définit les données de sortie de l'endpoint à travers le fichier `config/swagger_data/provider.yml`
- Il génère le fichier OpenAPI à l'aide de la commande `bin/generate_swagger.sh`

## Génération du fichier OpenAPI et push sur Github

Si vous éditez un fichier `config/swagger_data/*.yml` il faut régénerer le fichier swagger (et le commit avec le changement) ou le CI échouera lors du push sur Github.

Les tests vérifient que le fichier Swagger est valide, le CI/CD vérifie que la version du Swagger est à jour.

Si le fichier OpenAPI n'est pas à jour, il peut être régénéré avec la commande: `bin/generate_swagger.sh`

Si le fichier OpenAPI est invalide, vous pouvez tester votre fichier Swagger à l'aide de l'éditeur disponible en
ligne à l'adresse suivante: [Swagger Editor](https://editor.swagger.io/)

## Génération du fichier OpenAPI par action Github

Si vous ne pouvez/voulez pas lancer la commande `bin/generate_swagger.sh` en local, vous pouvez le faire via une action Github. Suivre les étapes suivantes:

1. Ouvrez votre Pull-Request avec vos changements

2. Relevez le numéro de la PR. Il se trouve notamment dans l'URL de la PR: https://github.com/etalab/siade/pull/6666 => Le numéro est 6666

3. Ouvrez la Github Action [regenerate swagger](https://github.com/etalab/siade/actions/workflows/regenerate_swagger.yaml)

4. Cliquez sur le bouton "Run workflow" en haut à droite

5. Pas la peine de changer la branche, renseignez juste le numéro de la PR dans le champ correspondant et cliquez sur "Run workflow"

6. La PR devrait être mise à jour automatiquement.
