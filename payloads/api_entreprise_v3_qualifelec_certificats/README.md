# Certification Qualifelec
* __Retour par défaut de l'API__

  Lors d'un appel avec des paramètres valides ne correspondant à aucun des examples dans ce dossier, l'API renvoie systématiquement cette réponse :


  <details><summary>Réponse par défault de l'API</summary>
  <p>

  ```json
  {
    "data": [
      {
        "data": {
          "document_url": "https://www.qualifelec.fr/certifmoteur/4/3631.pdf",
          "numero": 2840,
          "rge": true,
          "date_debut": "2019-01-01",
          "date_fin": "2021-12-31",
          "qualification": {
            "label": "Installations Électriques Logement Commerce Petit Tertiaire - LCPT",
            "date_debut": "2019-01-01",
            "date_fin": "2024-12-31",
            "indices": [
              {
                "code": "IRVE1",
                "label": "IRVE – indice 1 (station de recharge – puissance maximale appelable inférieure ou égale à 36 kVA)"
              }
            ],
            "mentions": [
              {
                "code": "PRGE",
                "label": "Probatoire Reconnu Garant de l’Environnement"
              }
            ],
            "domaines": [
              {
                "code": "SU",
                "label": "Sûreté"
              }
            ],
            "classification": {
              "code": "1",
              "label": "Classe 1 - de 1 à 3 exécutants"
            }
          },
          "assurance_decennale": {
            "nom": "AXA",
            "date_debut": "2024-01-31",
            "date_fin": "2024-12-31"
          },
          "assurance_civile": {
            "nom": "HISCOX",
            "date_debut": "2024-01-31",
            "date_fin": "2024-12-31"
          }
        },
        "links": {
        },
        "meta": {
        }
      }
    ],
    "meta": {
      "total": 8
    },
    "links": {
    }
  }
  ```

  </p>
  </details>

* [200.yaml](200.yaml)

  Status `200`

  

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "78951073200017"
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
          "document_url": "https://www.qualifelec.fr/certifmoteur/4/3631.pdf",
          "numero": 2840,
          "rge": true,
          "date_debut": "2019-01-01",
          "date_fin": "2021-12-31",
          "qualification": {
            "label": "Installations Électriques Logement Commerce Petit Tertiaire - LCPT",
            "date_debut": "2019-01-01",
            "date_fin": "2024-12-31",
            "indices": [
              {
                "code": "IRVE1",
                "label": "IRVE – indice 1 (station de recharge – puissance maximale appelable inférieure ou égale à 36 kVA)"
              }
            ],
            "mentions": [
              {
                "code": "PRGE",
                "label": "Probatoire Reconnu Garant de l’Environnement"
              }
            ],
            "domaines": [
              {
                "code": "SU",
                "label": "Sûreté"
              }
            ],
            "classification": {
              "code": "1",
              "label": "Classe 1 - de 1 à 3 exécutants"
            }
          },
          "assurance_decennale": {
            "nom": "AXA",
            "date_debut": "2024-01-31",
            "date_fin": "2024-12-31"
          },
          "assurance_civile": {
            "nom": "HISCOX",
            "date_debut": "2024-01-31",
            "date_fin": "2024-12-31"
          }
        },
        "links": {
        },
        "meta": {
        }
      }
    ],
    "meta": {
      "total": 8
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
    --url "https://staging.entreprise.api.gouv.fr/v3/qualifelec/etablissements/78951073200017/certificats"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  

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
        "code": "04003",
        "title": "Entité non trouvée",
        "detail": "Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel",
        "meta": {
          "provider": "Qualifelec"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/qualifelec/etablissements/00000000000000/certificats"
  ```

  </p>
  </details>
