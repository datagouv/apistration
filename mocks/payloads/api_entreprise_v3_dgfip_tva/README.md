# Numéros de TVA
* [200-multiple.yaml](200-multiple.yaml)

  Status `200`

  Plusieurs numéros de TVA pour le SIREN (historique)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "552032534"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": [
      {
        "data": {
          "numero_tva": "FR27552032534"
        },
        "links": {},
        "meta": {}
      },
      {
        "data": {
          "numero_tva": "FR89552032534"
        },
        "links": {},
        "meta": {}
      }
    ],
    "meta": {},
    "links": {}
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/numero_tva/552032534"
  ```

  </p>
  </details>
* [200-single.yaml](200-single.yaml)

  Status `200`

  Numéro de TVA trouvé pour le SIREN

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "217500016"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": [
      {
        "data": {
          "numero_tva": "FR72217500016"
        },
        "links": {},
        "meta": {}
      }
    ],
    "meta": {},
    "links": {}
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/numero_tva/217500016"
  ```

  </p>
  </details>
