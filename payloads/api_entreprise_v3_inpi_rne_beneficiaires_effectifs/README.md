# Bénéficiaires effectifs
* __Retour par défaut de l'API__

  Lors d'un appel avec des paramètres valides ne correspondant à aucun des examples dans ce dossier, l'API renvoie systématiquement cette réponse :


  <details><summary>Réponse par défault de l'API</summary>
  <p>

  ```json
  {
    "data": [
      {
        "data": {
          "nom": "MARTIN",
          "nom_usage": "DUBOIS",
          "prenoms": [
            "dummy"
          ],
          "date_naissance": {
            "annee": "1990",
            "mois": "01"
          },
          "modalites": {
            "detention_part_directe": true,
            "parts_directes_pleine_propriete": 42.0,
            "parts_directes_nue_propriete": 9.0,
            "detention_part_indirecte": true,
            "parts_indirectes_indivision": 0.0,
            "parts_indirectes_indivision_pleine_propriete": 0.0,
            "parts_indirectes_indivision_nue_propriete": 0.0,
            "parts_indirectes_personnes_morales": 0.0,
            "parts_indirectes_personnes_morales_pleine_propriete": 0.0,
            "parts_indirectes_personnes_morales_nue_propriete": 0.0,
            "detention_part_totale": 51.0,
            "detention_vote_directe": true,
            "vote_directe_pleine_propriete": 51.0,
            "vote_directe_nue_propriete": 0.0,
            "vote_directe_usufruit": 0.0,
            "detention_vote_indirecte": true,
            "vote_indirecte_indivision": 0.0,
            "vote_indirecte_indivision_pleine_propriete": 0.0,
            "vote_indirecte_indivision_nue_propriete": 0.0,
            "vote_indirecte_indivision_usufruit": 0.0,
            "vote_indirecte_personnes_morales": 0.0,
            "vote_indirecte_personnes_morales_pleine_propriete": 0.0,
            "vote_indirecte_personnes_morales_nue_propriete": 0.0,
            "vote_indirecte_personnes_morales_usufruit": 0.0,
            "vocation_titulaire_directe_pleine_propriete": 0.0,
            "vocation_titulaire_directe_nue_propriete": 0.0,
            "vocation_titulaire_indirecte_indivision": 0.0,
            "vocation_titulaire_indirecte_pleine_propriete": 0.0,
            "vocation_titulaire_indirecte_nue_propriete": 0.0,
            "vocation_titulaire_indirecte_personnes_morales": 0.0,
            "vocation_titulaire_indirecte_personnes_morales_pleine_propriete": 0.0,
            "vocation_titulaire_indirecte_personnes_morales_nue_propriete": 0.0,
            "detention_vote_total": 0.0,
            "detention_pouvoir_decision_ag": true,
            "detention_pouvoir_nommage_membres_conseil_admin": true,
            "detention_autres_moyens_controle": true,
            "representant_legal": true,
            "representant_legal_placement_sans_gestion_delegue": true
          }
        },
        "links": {
        },
        "meta": {
        }
      }
    ],
    "meta": {
      "count": 1
    },
    "links": {
    }
  }
  ```

  </p>
  </details>

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
      "count": 2
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
    --url "https://staging.entreprise.api.gouv.fr/v3/inpi/rne/unites_legales/open_data/552049447/beneficiaires_effectifs"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/inpi/rne/unites_legales/open_data/813914819/beneficiaires_effectifs"
  ```

  </p>
  </details>
