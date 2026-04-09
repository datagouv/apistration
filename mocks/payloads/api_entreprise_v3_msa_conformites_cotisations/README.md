# Conformité cotisations de sécurité sociale agricole
* [200.yaml](200.yaml)

  Status `200`

  Succès 200 - La conformité de l'entreprise est à jour

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "20005379100014"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "status": "up_to_date"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/msa/etablissements/20005379100014/conformite_cotisations"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Erreur 404 - Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500013"
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
        "code": "10003",
        "title": "Entité non trouvée",
        "detail": "Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "meta": {
          "provider": "MSA"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/msa/etablissements/13002526500013/conformite_cotisations"
  ```

  </p>
  </details>
