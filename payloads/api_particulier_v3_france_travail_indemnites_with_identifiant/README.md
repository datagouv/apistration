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
    "data": {
      "identifiant": "default",
      "paiements": [
        {
          "date_versement": "2021-01-01",
          "montant_total": 123.4,
          "montant_allocations": 123.4,
          "montant_aides": 0.0,
          "montant_autres": 0.0
        },
        {
          "date_versement": "2021-02-01",
          "montant_total": 345.1,
          "montant_allocations": 345.1,
          "montant_aides": 0.0,
          "montant_autres": 0.0
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
    -G -d 'recipient=13002526500013' -d 'identifiant=default' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/indemnites/identifiant"
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
    "errors": [
      {
        "code": "24003",
        "title": "Entité non trouvée",
        "detail": "Aucune situation France Travail n'a pu être trouvée avec les critères de recherche fournis.",
        "source": null,
        "meta": {
          "provider": "France Travail"
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
    -G -d 'recipient=13002526500013' -d 'identifiant=inconnu' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/indemnites/identifiant"
  ```

  </p>
  </details>
