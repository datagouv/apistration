# Qualiopi & habilitations France compétences
* [200.yaml](200.yaml)

  Status `200`

  Certifications Qualiopi trouvées

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
      "siret": "30613890001294",
      "code_uai": null,
      "unite_legale_avec_plusieurs_nda": false,
      "declarations_activites_etablissement": [
        {
          "numero_de_declaration": "11910843391",
          "actif": true,
          "date_derniere_declaration": "2021-01-30",
          "date_debut_exercice": "2021-01-30",
          "date_fin_exercice": "2021-12-31",
          "certification_qualiopi": {
            "action_formation": true,
            "bilan_competences": false,
            "validation_acquis_experience": false,
            "apprentissage": false,
            "obtention_via_unite_legale": true
          },
          "specialites": {
            "specialite_1": {
              "code": "313",
              "libelle": "Finances, banque, assurances"
            },
            "specialite_2": {
              "code": "326",
              "libelle": "Informatique, traitement de l'information, réseaux de transmission des données"
            },
            "specialite_3": {
              "code": null,
              "libelle": null
            }
          }
        }
      ],
      "habilitations_france_competence": [
        {
          "code": "RNCP10013",
          "actif": true,
          "date_actif": "2020-01-30",
          "date_fin_enregistrement": "2030-01-30",
          "date_decision": "2020-01-30",
          "habilitation_pour_former": true,
          "habilitation_pour_organiser_l_evaluation": true,
          "sirets_organismes_certificateurs": [
            "12345678901234"
          ]
        }
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/carif_oref/etablissements/30613890001294/certifications_qualiopi_france_competences"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Établissement non trouvé

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
        "code": "36003",
        "title": "Entité non trouvée",
        "detail": "Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "CARIF-OREF"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/carif_oref/etablissements/00000000000000/certifications_qualiopi_france_competences"
  ```

  </p>
  </details>
