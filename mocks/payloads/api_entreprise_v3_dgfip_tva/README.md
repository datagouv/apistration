# Numéros de TVA intracommunautaire français
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
    "data": {
      "numero_tva": "FR72217500016"
    },
    "links": {},
    "meta": {
      "date_derniere_mise_a_jour": "2026-06-11"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/217500016/numero_tva"
  ```

  </p>
  </details>
