# [INE] Statut étudiant boursier
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
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567890B' \
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567890C' \
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567890D' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [ine_1234567891A_level_6_toulouse_2025.yml](ine_1234567891A_level_6_toulouse_2025.yml)

  Status `200`

  Boursier échelon 6, année scolaire 2025 (appel par INE: 1234567891A)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567891A"
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
        "date_rentree": "2025-09-01",
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
      "email": "lilian.simon@fake.fr",
      "identite": {
        "nom": "Simon",
        "prenoms": [
          "Lilian"
        ],
        "date_naissance": "2005-01-03",
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567891A' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [ine_1234567891B_level_6_toulouse_2025.yml](ine_1234567891B_level_6_toulouse_2025.yml)

  Status `200`

  Boursier échelon 6, année scolaire 2025 (appel par INE: 1234567891B)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567891B"
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
        "date_rentree": "2025-09-01",
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
      "email": "sahra.bel.aalian@fake.fr",
      "identite": {
        "nom": "Bel Aalia",
        "prenoms": [
          "Sahra"
        ],
        "date_naissance": "2005-01-03",
        "nom_commune_naissance": "Paris",
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567891B' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [ine_1234567891C_level_7_toulouse_2025.yml](ine_1234567891C_level_7_toulouse_2025.yml)

  Status `200`

  Boursier échelon 7, année scolaire 2025 (appel par INE: 1234567891C)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567891C"
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
        "date_rentree": "2025-09-01",
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
      "email": "gael.vaillancourt@fake.fr",
      "identite": {
        "nom": "Vaillancourt",
        "prenoms": [
          "Gael"
        ],
        "date_naissance": "1999-06-21",
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567891C' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [ine_1234567891D_level_7_toulouse_2025.yml](ine_1234567891D_level_7_toulouse_2025.yml)

  Status `200`

  Boursier échelon 7, année scolaire 2025 (appel par INE: 1234567891D)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567891D"
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
        "date_rentree": "2025-09-01",
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
      "email": "aurelie.puges@fake.fr",
      "identite": {
        "nom": "Puges",
        "prenoms": [
          "Aurelie"
        ],
        "date_naissance": "1999-06-21",
        "nom_commune_naissance": "Paris",
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567891D' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
