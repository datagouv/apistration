# N°TVA intracommunautaire français
* [200.yaml](200.yaml)

  Status `200`

  Numéro TVA trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "552049447"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "tva_number": "FR82552049447"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/european_commission/unites_legales/552049447/numero_tva"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Entreprise non trouvée

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
        "code": "32003",
        "title": "Entité non trouvée",
        "detail": "Le siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Commission Européenne"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/european_commission/unites_legales/000000000/numero_tva"
  ```

  </p>
  </details>
