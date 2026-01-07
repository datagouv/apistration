# Chiffre d'affaires
* [200-2022.yaml](200-2022.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500001",
    "year": "2022"
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
          "chiffre_affaires": 900001,
          "date_fin_exercice": "2022-12-01"
        },
        "links": {
        },
        "meta": {
        }
      }
    ],
    "meta": {
    },
    "links": {
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/etablissements/13002526500001/chiffres_affaires"
  ```

  </p>
  </details>
* [200-2023.yaml](200-2023.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500001",
    "year": "2023"
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
          "chiffre_affaires": 900001,
          "date_fin_exercice": "2023-12-01"
        },
        "links": {
        },
        "meta": {
        }
      }
    ],
    "meta": {
    },
    "links": {
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/etablissements/13002526500001/chiffres_affaires"
  ```

  </p>
  </details>
* [200-2024.yaml](200-2024.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500001",
    "year": "2024"
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
          "chiffre_affaires": 900001,
          "date_fin_exercice": "2024-12-01"
        },
        "links": {
        },
        "meta": {
        }
      }
    ],
    "meta": {
    },
    "links": {
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/etablissements/13002526500001/chiffres_affaires"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Entreprise non trouvée ou non à jour

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "00000000000000"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/dgfip/etablissements/00000000000000/chiffres_affaires"
  ```

  </p>
  </details>
