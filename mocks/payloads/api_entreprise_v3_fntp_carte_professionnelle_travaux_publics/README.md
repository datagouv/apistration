# Carte professionnelle travaux publics
* [200.yml](200.yml)

  Status `200`

  Appel réussi

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
      "document_url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_fntp_carte_professionnelle_travaux_publics/carte_professionnelle_tp_test.pdf",
      "expires_in": 7889238
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
    --url "https://staging.entreprise.api.gouv.fr/v3/fntp/unites_legales/130025265/carte_professionnelle_travaux_publics"
  ```

  </p>
  </details>
* [404.yml](404.yml)

  Status `404`

  Établissement non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "844451564"
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
        "code": "12003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "FNTP"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/fntp/unites_legales/844451564/carte_professionnelle_travaux_publics"
  ```

  </p>
  </details>
