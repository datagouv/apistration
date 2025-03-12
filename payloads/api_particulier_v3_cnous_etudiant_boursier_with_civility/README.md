# [Identité] Status étudiant boursier
* [404.yaml](404.yaml)

  Status `404`

  Dossier non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "NOEL"
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
        "code": "26003",
        "title": "Entité non trouvée",
        "detail": "Aucun étudiant boursier n'a pu être trouvé avec les critères de recherche fournis.",
        "source": null,
        "meta": {
          "provider": "CNOUS"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=NOEL' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/identite"
  ```

  </p>
  </details>
* [civility.yml](civility.yml)

  Status `200`

  Boursier échelon 5

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Pagnol",
    "prenoms": [
      "Marcel"
    ],
    "anneeDateNaissance": 1998,
    "moisDateNaissance": 7,
    "jourDateNaissance": 12,
    "codeCogInseeCommuneNaissance": "75000",
    "sexeEtatCivil": "M"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "est_boursier": true,
      "periode_versement_bourse": {
        "date_rentree": "2020-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Evry",
        "nom_etablissement": "ENSIIE"
      },
      "echelon_bourse": {
        "echelon": "5",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "marcel@pagnol.fr",
      "identite": {
        "nom": "PAGNOL",
        "prenoms": [
          "MARCEL"
        ],
        "date_naissance": "1998-07-12",
        "nom_commune_naissance": "Paris",
        "sexe": "M"
      }
    },
    "links": {
    },
    "meta": {
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Pagnol' -d 'prenoms[]=Marcel' -d 'anneeDateNaissance=1998' -d 'moisDateNaissance=7' -d 'jourDateNaissance=12' -d 'codeCogInseeCommuneNaissance=75000' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/identite"
  ```

  </p>
  </details>
