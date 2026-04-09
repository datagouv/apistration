# Liens de succession
* [200.yaml](200.yaml)

  Status `200`

  INSEE Liens de successions - Réponse 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "30613890001286"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "predecesseurs": [
        {
          "siret": "30613890001278",
          "date_succession": "2021-10-15",
          "transfert_siege": true,
          "continuite_economique": true
        }
      ],
      "successeurs": [
        {
          "siret": "30613890001294",
          "date_succession": "2022-12-15",
          "transfert_siege": true,
          "continuite_economique": true
        }
      ]
    },
    "links": {},
    "meta": {}
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/30613890001286/successions"
  ```

  </p>
  </details>
* [403.yaml](403.yaml)

  Status `403`

  INSEE Liens de successions - Exemple 403

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "32682221625251"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "errors": [
      {
        "title": "Privilèges insuffisants",
        "detail": "Votre token est valide mais vos privilèges sont insuffisants. Listez vos privilèges sur /v2/privileges",
        "code": "0100"
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/32682221625251/successions"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Payload INSEE Successions - not found 404

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "37449707591810"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "errors": [
      {
        "code": "04003",
        "title": "Entité non trouvée",
        "detail": "Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel",
        "meta": {
          "provider": "INSEE"
        }
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/37449707591810/successions"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  INSEE Liens de successions - Exemple 502

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "61229628734734"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "errors": [
      {
        "title": "Erreur inconnue du fournisseur de données",
        "detail": "La réponse retournée par le fournisseur de données est invalide et inconnue de notre service. L'équipe technique a été notifiée de cette erreur pour investigation.",
        "code": "01999"
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/61229628734734/successions"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  INSEE Liens de successions - Exemple 504

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "39197770100914"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "errors": [
      {
        "title": "Service non disponible",
        "detail": "Service du fournisseur de données temporairement indisponible ou en maintenance.",
        "code": "01001"
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/39197770100914/successions"
  ```

  </p>
  </details>
