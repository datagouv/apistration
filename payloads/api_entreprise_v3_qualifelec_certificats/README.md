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
          "document_url": "https://github.com/etalab/siade_staging_data/blob/develop/payloads/api_entreprise_v3_qualifelec_certificats/exemple-certificat-qualifelec-bac-a-sable.jpg",
          "numero": 5430,
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
    },
    "links": {
    }
  }
  ```

  </p>
  </details>

* [200-certification-qualifelec_2-certificats_sans-domaine.yaml](200-certification-qualifelec_2-certificats_sans-domaine.yaml)

  Status `200`

  ## 200 - Deux certifications Qualifelec, sans mention RGE

Ce cas permet de tester :
- Réponse 200 ;
- Deux certificats disponibles ;
- Pas de mention RGE ;
- Indices, mentions et classifications sont complétés ;
- Sans domaine ;
- Tableaux de plusieurs mentions.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "77567227221138"
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
          "document_url": "https://github.com/etalab/siade_staging_data/blob/develop/payloads/api_entreprise_v3_qualifelec_certificats/exemple-certificat-qualifelec-bac-a-sable.jpg",
          "numero": 2840,
          "rge": false,
          "date_debut": "2023-02-01",
          "date_fin": "2024-01-31",
          "qualification": {
            "label": "COURANTS FAIBLES LOGEMENT COMMERCE PETIT TERTIAIRE (CFLCP)",
            "date_debut": "2023-02-01",
            "date_fin": "2027-01-31",
            "indices": [
              {
                "code": "CFLCPT1",
                "label": "CFLCPT - indice 1"
              }
            ],
            "mentions": [
              {
                "code": "MA",
                "label": "Maintenance"
              },
              {
                "code": "CMO",
                "label": "Colonnes Montantes"
              }
            ],
            "domaines": [
  
            ],
            "classification": {
              "code": 1,
              "label": "Classe 12 - de 4 à 8 exécutants"
            }
          },
          "assurance_decennale": {
            "nom": "AXA",
            "date_debut": "2023-02-01",
            "date_fin": "2024-01-31"
          },
          "assurance_civile": {
            "nom": "ALLIANZ IARD",
            "date_debut": "2023-02-01",
            "date_fin": "2024-01-31"
          }
        },
        "links": {
        },
        "meta": {
        }
      },
      {
        "data": {
          "document_url": "https://github.com/etalab/siade_staging_data/blob/develop/payloads/api_entreprise_v3_qualifelec_certificats/exemple-certificat-qualifelec-bac-a-sable.jpg",
          "numero": 2841,
          "rge": false,
          "date_debut": "2023-08-01",
          "date_fin": "2024-07-31",
          "qualification": {
            "label": "Installations Électriques Logement Commerce Petit Tertiaire - LCPT",
            "date_debut": "2023-02-01",
            "date_fin": "2027-01-31",
            "indices": [
              {
                "code": "LCPT",
                "label": "Logement Commerce Petit Tertiaire"
              }
            ],
            "mentions": [
              {
                "code": "ATC",
                "label": "Autocontrôle"
              },
              {
                "code": "IRVE2",
                "label": "Infrastructures de Recharge des Véhicules Électriques - niveau de formation 2"
              }
            ],
            "domaines": [
  
            ],
            "classification": {
              "code": 1,
              "label": "Classe 1 - de 1 à 3 exécutants"
            }
          },
          "assurance_decennale": {
            "nom": "AXA",
            "date_debut": "2023-08-01",
            "date_fin": "2024-07-31"
          },
          "assurance_civile": {
            "nom": "ALLIANZ IARD",
            "date_debut": "2023-08-01",
            "date_fin": "2024-07-31"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/qualifelec/etablissements/77567227221138/certificats"
  ```

  </p>
  </details>
* [200-certification-qualifelec_probatoire_rge.yaml](200-certification-qualifelec_probatoire_rge.yaml)

  Status `200`

  ## 200 - Certification probatoire Qualifelec PRGE

Ce cas permet de tester :
- Réponse 200 ;
- Mention RGE ;
- Certification probatoire
- Indices, mentions et classifications sont complétés ;
- Avec domaines - peu de qualifications ont des domaines ;
- Tableaux de mentions et de domaines.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "42417936400023"
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
          "document_url": "https://github.com/etalab/siade_staging_data/blob/develop/payloads/api_entreprise_v3_qualifelec_certificats/exemple-certificat-qualifelec-bac-a-sable.jpg",
          "numero": 2840,
          "rge": true,
          "date_debut": "2023-02-01",
          "date_fin": "2024-01-31",
          "qualification": {
            "label": "COURANTS FAIBLES MOYEN GROS TERTIAIRE INDUSTRIE (CFMGTI)",
            "date_debut": "2023-02-01",
            "date_fin": "2025-01-31",
            "indices": [
              {
                "code": "CFMGTI",
                "label": "Indice 2 (avec identification d’au minimum 1 domaine)"
              }
            ],
            "mentions": [
              {
                "code": "PRGE",
                "label": "Probatoire Reconnu Garant de l’Environnement"
              },
              {
                "code": "FO",
                "label": "Fibre Optique"
              }
            ],
            "domaines": [
              {
                "code": "RC",
                "label": "Réseaux de Communications"
              },
              {
                "code": "ST",
                "label": "Sécurité"
              }
            ],
            "classification": {
              "code": 1,
              "label": "Classe 5 - de 50 à 250 exécutants"
            }
          },
          "assurance_decennale": {
            "nom": "AXA",
            "date_debut": "2023-02-01",
            "date_fin": "2024-01-31"
          },
          "assurance_civile": {
            "nom": "ALLIANZ IARD",
            "date_debut": "2023-02-01",
            "date_fin": "2024-01-31"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/qualifelec/etablissements/42417936400023/certificats"
  ```

  </p>
  </details>
* [200-certification-qualifelec_rge_sans-domaine.yaml](200-certification-qualifelec_rge_sans-domaine.yaml)

  Status `200`

  ## 200 - Certification Qualifelec RGE

Ce cas permet de tester :
- Réponse 200 ;
- Mention RGE ;
- Indices, mentions et classifications sont complétés ;
- Sans domaine ;
- Tableaux de plusieurs mentions.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "55204944776279"
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
          "document_url": "https://github.com/etalab/siade_staging_data/blob/develop/payloads/api_entreprise_v3_qualifelec_certificats/exemple-certificat-qualifelec-bac-a-sable.jpg",
          "numero": 2840,
          "rge": true,
          "date_debut": "2023-02-01",
          "date_fin": "2024-01-31",
          "qualification": {
            "label": "Installations Électriques Logement Commerce Petit Tertiaire - LCPT",
            "date_debut": "2023-02-01",
            "date_fin": "2027-01-31",
            "indices": [
              {
                "code": "LCPT",
                "label": "Logement Commerce Petit Tertiaire"
              }
            ],
            "mentions": [
              {
                "code": "RGE",
                "label": "Reconnu Garant de l’Environnement"
              },
              {
                "code": "ATC",
                "label": "Autocontrôle"
              },
              {
                "code": "IRVE2",
                "label": "Infrastructures de Recharge des Véhicules Électriques - niveau de formation 2"
              }
            ],
            "domaines": [
  
            ],
            "classification": {
              "code": 1,
              "label": "Classe 1 - de 1 à 3 exécutants"
            }
          },
          "assurance_decennale": {
            "nom": "AXA",
            "date_debut": "2023-02-01",
            "date_fin": "2024-01-31"
          },
          "assurance_civile": {
            "nom": "ALLIANZ IARD",
            "date_debut": "2023-02-01",
            "date_fin": "2024-01-31"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/qualifelec/etablissements/55204944776279/certificats"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Payload Qualifelec - not found 404

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
