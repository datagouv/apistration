# [INE] Status étudiant boursier
* [ine.yml](ine.yml)

  Status `200`

  Boursier échelon 6 (appel par INE)

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
      "est_boursier": true,
      "periode_versement_bourse": {
        "date_rentree": "2018-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Marseille",
        "nom_etablissement": "Pagnol"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "geraldine@@durand.fr",
      "identite": {
        "nom": "Durand",
        "prenoms": [
          "GERALDINE"
        ],
        "date_naissance": "1990-01-01",
        "nom_commune_naissance": "Paris",
        "sexe": "F"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890A' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [ine_1234567890B_expired.yml](ine_1234567890B_expired.yml)

  Status `200`

  Boursier échelon 6, année scolaire antérieure (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890B"
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
        "date_rentree": "2022-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Jean Jaurès"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "thomas.longchambon@fake.fr",
      "identite": {
        "nom": "Longchambon",
        "prenoms": [
          "THOMAS"
        ],
        "date_naissance": "2001-01-01",
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890B' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [ine_1234567890C_level_6.yml](ine_1234567890C_level_6.yml)

  Status `200`

  Boursier échelon 6, année scolaire en cours (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890C"
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
        "date_rentree": "2023-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Jean Jaurès"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "axelle.charbonneau@fake.fr",
      "identite": {
        "nom": "Charbonneau",
        "prenoms": [
          "AXELLE"
        ],
        "date_naissance": "2001-01-01",
        "nom_commune_naissance": "Paris",
        "sexe": "F"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890C' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [ine_1234567890D_level_7.yml](ine_1234567890D_level_7.yml)

  Status `200`

  Boursier échelon 7, année scolaire en cours (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890D"
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
        "date_rentree": "2023-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Jean Jaurès"
      },
      "echelon_bourse": {
        "echelon": "7",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "marie.montgomery@fake.fr",
      "identite": {
        "nom": "Montgomery",
        "prenoms": [
          "MARIE"
        ],
        "date_naissance": "2001-01-03",
        "nom_commune_naissance": "Paris",
        "sexe": "F"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890D' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
