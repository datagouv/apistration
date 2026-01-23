# Actes et bilans
* [200.yaml](200.yaml)

  Status `200`

  Unité légale trouvée avec bilans

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
          "id": "65419234a1f7d1f2ba09bd8c",
          "nom_document": "X9wvz5eKvKQv_C0022A1001L257081D20230902H180411TPIJTES003PDBOR",
          "date_depot": "2023-08-08",
          "date_mise_a_jour": "2023-11-01",
          "types_actes": [
            {
              "type_acte": "Procès-verbal",
              "type_decision": "Augmentation du capital social"
            }
          ],
          "url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_inpi_rne_actes_bilans/exemple-bilan-inpi.pdf"
        }
      ],
      "bilans": [
        {
          "id": "65419234a1f7d1f2ba09bd8c",
          "nom_document": "Bilan_2022_complet",
          "date_depot": "2023-08-08",
          "date_cloture": "2022-12-31",
          "date_mise_a_jour": "2023-11-01",
          "type": "bilan complet",
          "url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_inpi_rne_actes_bilans/exemple-bilan-inpi.pdf"
        },
        {
          "id": "65419234a1f7d1f2ba09bd8d",
          "nom_document": "Bilan_2021_complet",
          "date_depot": "2022-08-10",
          "date_cloture": "2021-12-31",
          "date_mise_a_jour": "2022-11-05",
          "type": "bilan complet",
          "url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_inpi_rne_actes_bilans/exemple-bilan-inpi.pdf"
        },
        {
          "id": "65419234a1f7d1f2ba09bd8e",
          "nom_document": "Bilan_2020_simplifie",
          "date_depot": "2021-08-15",
          "date_cloture": "2020-12-31",
          "date_mise_a_jour": "2021-11-10",
          "type": "bilan simplifié",
          "url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_inpi_rne_actes_bilans/exemple-bilan-inpi.pdf"
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
