# [Identité] Statut étudiant boursier
* [200_boursier.yaml](200_boursier.yaml)

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
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Pagnol' -d 'prenoms[]=Marcel' -d 'anneeDateNaissance=1998' -d 'moisDateNaissance=7' -d 'jourDateNaissance=12' -d 'codeCogInseeCommuneNaissance=75000' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/identite"
  ```

  </p>
  </details>
* [200_non_boursier.yaml](200_non_boursier.yaml)

  Status `200`

  Non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Durand",
    "prenoms": [
      "Sophie"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 3,
    "jourDateNaissance": 25,
    "codeCogInseeCommuneNaissance": "69123",
    "sexeEtatCivil": "F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": false,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2021-09-01",
        "duree": 0
      },
      "etablissement_etudes": {
        "nom_commune": "Lyon",
        "nom_etablissement": "Université Claude Bernard Lyon 1"
      },
      "echelon_bourse": {
        "echelon": "0bis",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "sophie.durand@univ-lyon1.fr",
      "identite": {
        "nom": "DURAND",
        "prenoms": [
          "SOPHIE"
        ],
        "date_naissance": "2000-03-25",
        "nom_commune_naissance": "Lyon",
        "sexe": "F"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Durand' -d 'prenoms[]=Sophie' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=3' -d 'jourDateNaissance=25' -d 'codeCogInseeCommuneNaissance=69123' -d 'sexeEtatCivil=F' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/identite"
  ```

  </p>
  </details>
