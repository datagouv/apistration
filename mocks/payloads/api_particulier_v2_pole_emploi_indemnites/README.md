# Paiements versés par France Travail
* [200.yaml](200.yaml)

  Status `200`

  Avec allocations

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "default"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "default",
    "paiements": [
      {
        "date": "2021-01-01",
        "montant": 123.4,
        "allocations": 123.4,
        "aides": 0.0,
        "autres": 0.0
      },
      {
        "date": "2021-02-01",
        "montant": 345.1,
        "allocations": 345.1,
        "aides": 0.0,
        "autres": 0.0
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=default' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/paiements-pole-emploi"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Identifiant non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "inconnu"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "not_found",
    "reason": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
    "message": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel."
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=inconnu' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/paiements-pole-emploi"
  ```

  </p>
  </details>
