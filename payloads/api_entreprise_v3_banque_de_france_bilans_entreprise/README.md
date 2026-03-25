# 3 derniers bilans annuels
* [200.yaml](200.yaml)

  Status `200`

  Bilans entreprise trouvés

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
          "annee": "2022",
          "date_arrete_exercice": "202212",
          "valeurs_calculees": [
            {
              "disponibilites": {
                "valeur": "9001",
                "evolution": 12.34
              },
              "total_dettes_stables": {
                "valeur": "15000",
                "evolution": 5.67
              },
              "valeur_ajoutee_bdf": {
                "valeur": "35000",
                "evolution": 8.12
              },
              "besoin_en_fonds_de_roulement": {
                "valeur": "12000",
                "evolution": -3.45
              },
              "excedent_brut_exploitation": {
                "valeur": "18000",
                "evolution": 6.78
              },
              "capacite_autofinancement": {
                "valeur": "14000",
                "evolution": 4.56
              },
              "fonds_roulement_net_global": {
                "valeur": "22000",
                "evolution": 7.89
              },
              "ratio_fonds_roulement_net_global_sur_besoin_en_fonds_de_roulement": {
                "valeur": 23.45,
                "evolution": 12.34
              },
              "dettes4_maturite_a_un_an_au_plus": {
                "valeur": "8000",
                "evolution": -2.34
              }
            }
          ],
          "declarations": [
            {
              "numero_imprime": "2051",
              "donnees": [
                {
                  "code": "GR",
                  "code_EDI": "GR:C889:7111:1:TBX",
                  "evolution": 4.56,
                  "code_absolu": "2006744",
                  "code_type_donnee": "CCI",
                  "intitule": "Déposé néant",
                  "code_nref": "304651",
                  "valeurs": [
                    "4245"
                  ]
                }
              ]
            }
          ]
        },
        "links": {},
        "meta": {}
      }
    ],
    "links": {},
    "meta": {
      "count": 1
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
    --url "https://staging.entreprise.api.gouv.fr/v3/banque_de_france/unites_legales/552049447/bilans"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Entreprise non trouvée

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
        "code": "04003",
        "title": "Entité non trouvée",
        "detail": "Le siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Banque de France"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/banque_de_france/unites_legales/000000000/bilans"
  ```

  </p>
  </details>
