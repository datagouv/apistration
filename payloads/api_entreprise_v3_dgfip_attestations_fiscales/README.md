# Attestation fiscale
* [200.yaml](200.yaml)

  Status `200`

  Entreprise à jour PDF disponible

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
      "document_url": "https://entreprise.api.gouv.fr/files/attestation-fiscale-dgfip-exemple.pdf",
      "expires_in": 1234567
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/418166096/attestation_fiscale"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Entreprise non trouvée ou non à jour

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000003"
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
        "code": "03003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "meta": {
          "provider": "DGFIP - Adélie"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/000000003/attestation_fiscale"
  ```

  </p>
  </details>
* [attestation_delivree.yaml](attestation_delivree.yaml)

  Status `200`

  Entreprise à jour PDF disponible

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000001"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://entreprise.api.gouv.fr/files/attestation-fiscale-dgfip-exemple.pdf",
      "expires_in": 1234567
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/000000001/attestation_fiscale"
  ```

  </p>
  </details>
* [entite_hors_perimetre.yaml](entite_hors_perimetre.yaml)

  Status `404`

  Entreprise non trouvée ou non à jour

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000002"
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
        "code": "03003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "meta": {
          "provider": "DGFIP - Adélie"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/000000002/attestation_fiscale"
  ```

  </p>
  </details>
