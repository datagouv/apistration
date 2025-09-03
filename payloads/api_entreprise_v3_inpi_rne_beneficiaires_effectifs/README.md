# Bénéficiaires effectifs
* [200.yaml](200.yaml)

  Status `200`

  Entreprise avec bénéficiaires effectifs

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
    "data": [
      {
        "data": {
          "beneficiaire_uuid": "c5c28655-4dd1-4246-a23b-bcb6cccc628b",
          "nom": "DUPONT",
          "nom_usage": "DUBOIS",
          "prenoms": [
            "JEAN",
            "MARC"
          ],
          "date_naissance": {
            "annee": "1989",
            "mois": "01"
          },
          "nationalite": "FRANCE",
          "pays_residence": "FRANCE",
          "modalites": {
            "detention_de_capital": {
              "parts_totale": 49.0,
              "parts_directes": {
                "detention": true,
                "pleine_propriete": 49.0,
                "nue_propriete": 0.0
              },
              "parts_indirectes": {
                "detention": false,
                "par_indivision": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                },
                "via_personnes_morales": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                }
              }
            },
            "vocation_a_devenir_titulaire_de_parts": {
              "parts_directes": {
                "pleine_propriete": 0.0,
                "nue_propriete": 0.0
              },
              "parts_indirectes": {
                "par_indivision": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                },
                "via_personnes_morales": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                }
              }
            },
            "droits_de_vote": {
              "total": 0.0,
              "directes": {
                "detention": true,
                "pleine_propriete": 49.0,
                "nue_propriete": 0.0,
                "usufruit": 0.0
              },
              "indirectes": {
                "detention": false,
                "par_indivision": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0,
                  "usufruit": 0.0
                },
                "via_personnes_morales": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0,
                  "usufruit": 0.0
                }
              }
            },
            "pouvoirs_de_controle": {
              "decision_ag": false,
              "nommage_membres_conseil_administratif": false,
              "autres": false
            },
            "representant_legal": false,
            "representant_legal_placement_sans_gestion_deleguee": false
          }
        },
        "links": {
        },
        "meta": {
        }
      },
      {
        "data": {
          "beneficiaire_uuid": "fce4cefc-ff15-43f9-824f-7f782d65f8d5",
          "nom": "MARTIN",
          "nom_usage": null,
          "prenoms": [
            "JULES",
            "ANDRE"
          ],
          "date_naissance": {
            "annee": "1990",
            "mois": "01"
          },
          "nationalite": "FRANCE",
          "pays_residence": "FRANCE",
          "modalites": {
            "detention_de_capital": {
              "parts_totale": 51.0,
              "parts_directes": {
                "detention": true,
                "pleine_propriete": 51.0,
                "nue_propriete": 0.0
              },
              "parts_indirectes": {
                "detention": false,
                "par_indivision": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                },
                "via_personnes_morales": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                }
              }
            },
            "vocation_a_devenir_titulaire_de_parts": {
              "parts_directes": {
                "pleine_propriete": 0.0,
                "nue_propriete": 0.0
              },
              "parts_indirectes": {
                "par_indivision": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                },
                "via_personnes_morales": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0
                }
              }
            },
            "droits_de_vote": {
              "total": 0.0,
              "directes": {
                "detention": true,
                "pleine_propriete": 51.0,
                "nue_propriete": 0.0,
                "usufruit": 0.0
              },
              "indirectes": {
                "detention": false,
                "par_indivision": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0,
                  "usufruit": 0.0
                },
                "via_personnes_morales": {
                  "total": 0.0,
                  "pleine_propriete": 0.0,
                  "nue_propriete": 0.0,
                  "usufruit": 0.0
                }
              }
            },
            "pouvoirs_de_controle": {
              "decision_ag": false,
              "nommage_membres_conseil_administratif": false,
              "autres": false
            },
            "representant_legal": false,
            "representant_legal_placement_sans_gestion_deleguee": false
          }
        },
        "links": {
        },
        "meta": {
        }
      }
    ],
    "meta": {
      "count": 2,
      "beneficiaires_sans_modalites_uuids": [
  
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/inpi/rne/unites_legales/552049447/beneficiaires_effectifs"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Bénéficiaires non trouvés

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "813914819"
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
        "code": "34003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "meta": {
          "provider": "INPI - RNE"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/inpi/rne/unites_legales/813914819/beneficiaires_effectifs"
  ```

  </p>
  </details>
