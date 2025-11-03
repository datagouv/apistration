# Conformité cotisations retraite bâtiment
* [200.yml](200.yml)

  Status `200`

  Entreprise trouvée QUALIBAT

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
      "document_url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_probtp_attestations_cotisation_retraite/test_probtp_attestation.pdf",
      "expires_in": 7889238
    },
    "links": {
    },
    "meta": {
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/probtp/etablissements/30613890001294/attestation_cotisations_retraite"
  ```

  </p>
  </details>
* [404.yml](404.yml)

  Status `404`

  Entité non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "55203253400001"
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
        "code": "09003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "ProBTP"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/probtp/etablissements/55203253400001/attestation_cotisations_retraite"
  ```

  </p>
  </details>
