# [INE] Statut étudiant boursier
* [200_boursier.yaml](200_boursier.yaml)

  Status `200`

  Boursier avec INE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890A"
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
        "date_rentree": "2023-09-01",
        "duree": 10
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Université Toulouse III - Paul Sabatier"
      },
      "echelon_bourse": {
        "echelon": "4",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "etudiant@univ-tlse3.fr",
      "identite": {
        "nom": "LEROY",
        "prenoms": [
          "THOMAS"
        ],
        "date_naissance": "2001-05-18",
        "nom_commune_naissance": "Toulouse",
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567890A' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_campagne_anterieure.yaml](200_boursier_campagne_anterieure.yaml)

  Status `200`

  Boursier sur une campagne antérieure ciblée via campaignYear

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890A",
    "campaignYear": 2022
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
        "date_rentree": "2022-09-01",
        "duree": 10
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Université Toulouse III - Paul Sabatier"
      },
      "echelon_bourse": {
        "echelon": "3",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "etudiant@univ-tlse3.fr",
      "identite": {
        "nom": "LEROY",
        "prenoms": [
          "THOMAS"
        ],
        "date_naissance": "2001-05-18",
        "nom_commune_naissance": "Toulouse",
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567890A' -d 'campaignYear=2022' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_radie.yaml](200_radie.yaml)

  Status `200`

  Boursier radié

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321B"
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
        "est_radie": true,
        "date_radiation": "2023-12-01"
      },
      "periode_versement_bourse": {
        "date_rentree": "2023-09-01",
        "duree": 3
      },
      "etablissement_etudes": {
        "nom_commune": "Bordeaux",
        "nom_etablissement": "Université de Bordeaux"
      },
      "echelon_bourse": {
        "echelon": "2",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "etudiant@u-bordeaux.fr",
      "identite": {
        "nom": "PETIT",
        "prenoms": [
          "CAMILLE"
        ],
        "date_naissance": "2000-11-03",
        "nom_commune_naissance": "Bordeaux",
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321B' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
