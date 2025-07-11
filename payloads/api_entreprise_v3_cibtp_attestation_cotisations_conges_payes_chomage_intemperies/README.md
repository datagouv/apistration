# Certificat cotisations CIBTP
* [200.yaml](200.yaml)

  Status `200`

  Appel réussi

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500013"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://storage.entreprise.api.gouv.fr/siade/1569139162-b99824d9c764aae19a862a0af-certificat_cibtp.pdf",
      "expires_in": 600
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cibtp/etablissements/13002526500013/attestation_cotisations_conges_payes_chomage_intemperies"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Établissement non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "84445156452589"
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
        "code": "38003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que l'identifiant correspond au périmètre couvert par l'API.",
        "meta": {
          "provider": "CIBTP"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cibtp/etablissements/84445156452589/attestation_cotisations_conges_payes_chomage_intemperies"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  Intermédiaire hors-délai

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "20459446201414"
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
        "code": "38002",
        "title": "Intermédiaire hors-délai",
        "detail": "Temps d’attente d’une réponse du fournisseur de données écoulé.",
        "meta": {
          "provider": "CIBTP"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cibtp/etablissements/20459446201414/attestation_cotisations_conges_payes_chomage_intemperies"
  ```

  </p>
  </details>
