# Certification Qualibat
* [200.yml](200.yml)

  Status `200`

  Entreprise trouvée QUALIBAT

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "30613890001294"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v4_qualibat_certifications_batiment/exemple-qualibat.pdf",
      "document_url_expires_in": 86400,
      "date_emission": "2023-01-01",
      "date_fin_validite": "2024-02-02",
      "entity": {
        "assurance_responsabilite_travaux": {
          "nom": "GROUPAMA",
          "identifiant": "1234567890"
        },
        "assurance_responsabilite_civile": {
          "nom": "GROUPAMA",
          "identifiant": "1234567890"
        },
        "certifications": [
          {
            "code": "4322",
            "libelle": "Fabrication et pose de menuiserie intérieure en bois",
            "rge": false,
            "date_attribution": "2022-03-03"
          }
        ]
      }
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
    --url "https://staging.entreprise.api.gouv.fr/v4/qualibat/etablissements/30613890001294/certification_batiment"
  ```

  </p>
  </details>
* [404.yml](404.yml)

  Status `404`

  Entité non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "55203253400001"
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
        "code": "06003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "Qualibat"
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
    --url "https://staging.entreprise.api.gouv.fr/v4/qualibat/etablissements/55203253400001/certification_batiment"
  ```

  </p>
  </details>
