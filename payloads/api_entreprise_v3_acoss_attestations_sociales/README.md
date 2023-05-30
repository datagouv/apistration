# Attestation de vigilance
* __Retour par défaut de l'API__

  Lors d'un appel avec des paramètres valides ne correspondant à aucun des examples dans ce dossier, l'API renvoie systématiquement cette réponse :


  <details><summary>Réponse par défault de l'API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://storage.entreprise.api.gouv.fr/siade/1569139162-b99824d9c764aae19a862a0af-attestation_vigilance_acoss.pdf",
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

* [200.yaml](200.yaml)

  Status `200`

  Payload ACOSS Attestations sociales - succès 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "418166096"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://entreprise.api.gouv.fr/files/attestation-sociale-urssaf-exemple.pdf",
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
    --url "https://staging.entreprise.api.gouv.fr/v3/urssaf/unites_legales/418166096/attestation_vigilance"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Payload ACOSS Attestations sociales - not found 404

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000000"
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
        "detail": "Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel",
        "meta": {
          "provider": "ACOSS",
          "provider_errors": [
            {
              "code": "FUNC517",
              "message": "Le Siren est inconnu",
              "description": "Le siren est inconnu du SI Attestations, radié ou hors périmètre"
            }
          ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/urssaf/unites_legales/000000000/attestation_vigilance"
  ```

  </p>
  </details>
