# Liasses fiscales
* [200.yml](200.yml)

  Status `200`

  Entreprise trouvée liasses fiscales

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "306138900",
    "year": 2024
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "obligations_fiscales": [
        {
          "id": "100209489259",
          "code": "IS",
          "libelle": "Impôt sur les sociétés",
          "reference": "IS1",
          "regime": "string"
        }
      ],
      "declarations": [
        {
          "numero_imprime": "2033A",
          "regime": {
            "code": "RN",
            "libelle": "Réel simplifié"
          },
          "date_declaration": "2012-12-26",
          "date_fin_exercice": "2012-12-31",
          "duree_exercice": 365,
          "millesime": "201701",
          "donnees": [
            {
              "code": "GR",
              "code_EDI": "GR:C889:7111:1:TBX",
              "code_absolu": "2006744",
              "code_type_donnee": "CCI",
              "intitule": "Déposé néant",
              "code_nref": "304651",
              "valeurs": [
                "4245",
                "5672"
              ]
            }
          ]
        }
      ]
    },
    "links": {
    },
    "meta": {
      "internal_id_itip": "100004763104"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/306138900/liasses_fiscales/2024"
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
    "siren": "552032534",
    "year": 2024
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
        "code": "03003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "DGFIP - Adélie"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/unites_legales/552032534/liasses_fiscales/2024"
  ```

  </p>
  </details>
