# Statut étudiant
* [fake_france_connect_mesri_with.yml](fake_france_connect_mesri_with.yml)

  Status `200`

  FranceConnect: étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenom": "Jean",
    "nomNaissance": "MESRI",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75002"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "admissions": [
        {
          "date_debut": "2020-07-01",
          "date_fin": "2021-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "33063",
          "etablissement_etudes": {
            "uai": "0330023W",
            "nom": "LYCEE GENERAL ET TECHNOLOGIQUE CAMILLE JULLIAN"
          }
        }
      ]
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_mesri.yml](france_connect_mesri.yml)

  Status `200`

  FranceConnect: étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenom": "Angela",
    "nomNaissance": "DUBOIS",
    "anneeDateNaissance": 1962,
    "moisDateNaissance": 8,
    "jourDateNaissance": 24,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75107"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "admissions": [
        {
          "date_debut": "2020-07-01",
          "date_fin": "2021-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "33063",
          "etablissement_etudes": {
            "uai": "0330023W",
            "nom": "LYCEE GENERAL ET TECHNOLOGIQUE CAMILLE JULLIAN"
          }
        }
      ]
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
