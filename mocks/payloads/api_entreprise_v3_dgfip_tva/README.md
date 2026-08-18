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
* [404.yaml](404.yaml)

  Status `404`

  Payload DGFIP Numéro de TVA intracommunautaire - not found 404

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
        "code": "43003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "DGFIP - TVA"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/000000000/numero_tva"
  ```

  </p>
  </details>
