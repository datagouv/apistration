# Données du RNM d'une entreprise artisanale
* [200.yaml](200.yaml)

  Status `200`

  Entreprise artisanale trouvée

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
      "modalite_exercice": "P",
      "non_sedentaire": "0"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cma_france/rnm/unites_legales/552049447"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Entreprise non trouvée au RNM

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
        "code": "31003",
        "title": "Entité non trouvée",
        "detail": "Le siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "CMA France"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cma_france/rnm/unites_legales/000000000"
  ```

  </p>
  </details>
* [422.yaml](422.yaml)

  Status `422`

  Paramètres invalides

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "invalid"
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
        "code": "31001",
        "title": "Paramètre invalide",
        "detail": "Le paramètre siren n'est pas au bon format.",
        "source": null,
        "meta": {
          "provider": "CMA France"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/cma_france/rnm/unites_legales/invalid"
  ```

  </p>
  </details>
