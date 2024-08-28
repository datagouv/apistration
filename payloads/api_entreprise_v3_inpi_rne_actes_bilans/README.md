# Actes et bilans
* [200.yaml](200.yaml)

  Status `200`

  Unité légale trouvée

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
      "actes": [
        {
          "updated_at": "2023-11-01",
          "date_depot": "2023-08-08",
          "nom_document": "X9wvz5eKvKQv_C0022A1001L257081D20230902H180411TPIJTES003PDBOR",
          "id": "65419234a1f7d1f2ba09bd8c",
          "link": "https://entreprise.api.gouv.fr/proxy/inpi/download/%2FV+svyVVJGVCJroamyqjOrECaXHorkxJ39vZH1IMHz4N+6gvit9zgoQ=--rJ1ss+Brc7oVhloH--huyvWA83YgMFqOnjyKDmXQ==",
          "types": [
            {
              "acte": "Acte",
              "decision": "Augmentation du capital social"
            }
          ]
        }
      ],
      "bilans": [
        {
          "updated_at": "2023-11-01",
          "date_depot": "2023-08-08",
          "nom_document": "X9wvz5eKvKQv_C0022A1001L257081D20230902H180411TPIJTES003PDBOR",
          "id": "65419234a1f7d1f2ba09bd8c",
          "link": "https://entreprise.api.gouv.fr/proxy/inpi/download/%2FV+svyVVJGVCJroamyqjOrECaXHorkxJ39vZH1IMHz4N+6gvit9zgoQ=--rJ1ss+Brc7oVhloH--huyvWA83YgMFqOnjyKDmXQ==",
          "date_cloture": "2023-08-08",
          "type": "K"
        }
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/inpi/rne/unites_legales/open_data/130025265/actes_bilans"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Unité légale non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "754508695"
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
        "code": "34003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que l'identifiant correspond au périmètre couvert par l'API.",
        "meta": {
          "provider": "INPI - RNE"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/inpi/rne/unites_legales/open_data/754508695/actes_bilans"
  ```

  </p>
  </details>
