# France Connect

Les payloads renvoyées par FranceConnect ici ne sont jamais directement
renvoyées par l'API Particulier: celles-ci sont utilisées pour appeler les
fournisseurs de données dans le cadre des API FranceConnectés.

Plus d'infos dans le [README du projet](../../#cas-de-franceconnect)

* [cnous.yaml](cnous.yaml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/etudiants-boursiers` suivante](../api_particulier_v2_cnous_student_scholarship/france_connect_cnous.yml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "cnous"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "cnous_statut_boursier",
      "cnous_echelon_bourse",
      "cnous_email",
      "cnous_periode_versement",
      "cnous_statut_bourse",
      "cnous_ville_etudes",
      "cnous_identite"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Jean",
      "family_name": "MARTIN",
      "birthdate": "2001-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "jmartin_cnous"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer cnous" \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants-boursiers"
  ```

  </p>
  </details>
* [cnous_with_less_scopes.yaml](cnous_with_less_scopes.yaml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/etudiants-boursiers` suivante](../api_particulier_v2_cnous_student_scholarship/france_connect_cnous_with_less_scopes.yml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "cnous_with_less_scopes"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "cnous_statut_boursier",
      "cnous_echelon_bourse",
      "cnous_email",
      "cnous_periode_versement",
      "cnous_statut_bourse",
      "cnous_ville_etudes"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Jean",
      "family_name": "MARTIN",
      "birthdate": "2001-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "jmartin_cnous_with_less_scopes"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer cnous_with_less_scopes" \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants-boursiers"
  ```

  </p>
  </details>
* [default.yaml](default.yaml)

  Status `200`

  Réponse FranceConnect par défaut

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "default"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Jean Martin",
      "family_name": "DUPONT",
      "birthdate": "2000-01-01",
      "gender": "male",
      "birthplace": "75001",
      "birthcountry": "99100",
      "preferred_username": "jdupont"
    }
  }
  ```

  </p>
  </details>
* [mesri.yml](mesri.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/etudiants` suivante](../api_particulier_v2_mesri_student_status/france_connect.yml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "mesri"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "mesri_identifiant",
      "mesri_identite",
      "mesri_inscription_etudiant",
      "mesri_inscription_autre",
      "mesri_admission",
      "mesri_etablissements"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Jean",
      "family_name": "MESRI",
      "birthdate": "2002-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "jean_mesri"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer mesri" \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
