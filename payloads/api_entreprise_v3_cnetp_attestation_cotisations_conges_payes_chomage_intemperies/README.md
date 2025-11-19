# Certificat cotisations CNETP
* [200.yaml](200.yaml)

  Status `200`

  Appel réussi

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "130025265"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_cnetp_attestation_cotisations_conges_payes_chomage_intemperies/test_cnetp_certificat.pdf",
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cnetp/unites_legales/130025265/attestation_cotisations_conges_payes_chomage_intemperies"
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
    "siren": "844451564"
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
          "provider": "CNETP"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cnetp/unites_legales/844451564/attestation_cotisations_conges_payes_chomage_intemperies"
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
    "siren": "204594462"
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
          "provider": "CNETP"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cnetp/unites_legales/204594462/attestation_cotisations_conges_payes_chomage_intemperies"
  ```

  </p>
  </details>
