# [FranceConnect] Statut étudiant boursier
* [200_boursier_campagne_anterieure.yaml](200_boursier_campagne_anterieure.yaml)

  Status `200`

  Cas de test avec jeton FranceConnect - Boursier sur une campagne antérieure ciblée via campaignYear

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Angela",
      "Claire",
      "Louise"
    ],
    "nomNaissance": "DUBOIS",
    "anneeDateNaissance": 1962,
    "moisDateNaissance": 8,
    "jourDateNaissance": 24,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75107",
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
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Paris",
        "nom_etablissement": "Sorbonne Université"
      },
      "echelon_bourse": {
        "echelon": "4",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "angela.dubois@sorbonne.fr",
      "ine": "0000000005F"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v5/cnous/etudiant_boursier/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect.yaml](fake_france_connect.yaml)

  Status `200`

  Cas de test avec jeton FranceConnect de test - Non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Georges"
    ],
    "nomNaissance": "CNAF",
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
        "nom_commune": "Marseille",
        "nom_etablissement": "Aix-Marseille Université"
      },
      "echelon_bourse": {
        "echelon": "0bis",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "georges.martin@univ-amu.fr",
      "ine": "0000000006G"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v5/cnous/etudiant_boursier/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect.yaml](france_connect.yaml)

  Status `200`

  Cas de test avec jeton FranceConnect - Boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Angela",
      "Claire",
      "Louise"
    ],
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
        "nom_commune": "Paris",
        "nom_etablissement": "Sorbonne Université"
      },
      "echelon_bourse": {
        "echelon": "3",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "angela.dubois@sorbonne.fr",
      "ine": "0000000007H"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v5/cnous/etudiant_boursier/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
