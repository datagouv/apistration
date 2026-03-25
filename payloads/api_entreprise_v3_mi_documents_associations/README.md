# Divers documents d'une association
* [200.yaml](200.yaml)

  Status `200`

  Documents association trouvés

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret_or_rna": "W751234567"
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
          "timestamp": "1631182730",
          "type": "Statuts",
          "url": "https://storage.entreprise.api.gouv.fr/siade/1635505765-5cd08405e4163c9f7713447829aeef7284c3283d-document_asso.pdf",
          "expires_in": 86400,
          "errors": []
        },
        "links": {},
        "meta": {}
      },
      {
        "data": {
          "timestamp": "1687269600",
          "type": "Récépissé de modification",
          "url": "https://storage.entreprise.api.gouv.fr/siade/1635505765-modif-document_asso.pdf",
          "expires_in": 86400,
          "errors": []
        },
        "links": {},
        "meta": {}
      }
    ],
    "meta": {
      "nombre_documents": 2,
      "nombre_documents_deficients": 0
    },
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/rna/associations/W751234567/documents"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Association non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret_or_rna": "W000000000"
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
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Ministère de l'Intérieur"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/rna/associations/W000000000/documents"
  ```

  </p>
  </details>
