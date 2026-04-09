# Certification Qualibat (PDF seulement)
* [200.yaml](200.yaml)

  Status `200`

  Certification Qualibat trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "30613890001294"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://raw.githubusercontent.com/datagouv/apistration/refs/heads/develop/mocks/payloads/api_entreprise_v4_qualibat_certifications_batiment/exemple-qualibat.pdf",
      "expires_in": 7889238
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
    --url "https://staging.entreprise.api.gouv.fr/v3/qualibat/etablissements/30613890001294/certification_batiment"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Établissement non trouvé Qualibat

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "00000000000000"
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
        "code": "10003",
        "title": "Entité non trouvée",
        "detail": "Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Qualibat"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/qualibat/etablissements/00000000000000/certification_batiment"
  ```

  </p>
  </details>
