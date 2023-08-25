# Statut étudiant
* __Retour par défaut de l'API__

  Lors d'un appel avec des paramètres valides ne correspondant à aucun des examples dans ce dossier, l'API renvoie systématiquement cette réponse :


  <details><summary>Réponse par défault de l'API</summary>
  <p>

  ```json
  {
    "nom": "Moustaki",
    "prenom": "Georges",
    "dateNaissance": "1992-11-29",
    "inscriptions": [
      {
        "dateDebutInscription": "2022-09-01",
        "dateFinInscription": "2023-08-31",
        "statut": "admis",
        "regime": "formation initiale",
        "codeCommune": "29085",
        "etablissement": {
          "uai": "0011402U",
          "nom": "EGC AIN BOURG EN BRESSE EC GESTION ET COMMERCE (01000)"
        }
      }
    ]
  }
  ```

  </p>
  </details>

* [404.yaml](404.yaml)

  Status `404`

  Étudiant non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567404G"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "not_found",
    "reason": "Student not found",
    "message": "Aucun étudiant n'a pu être trouvé avec les critères de recherche fournis"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567404G' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [500.yaml](500.yaml)

  Status `500`

  Erreur interne du serveur

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567500G"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "error",
    "reason": "Internal server error",
    "message": "Une erreur interne s'est produite, l'équipe a été prévenue."
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567500G' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [503.yaml](503.yaml)

  Status `503`

  Timeout - délai d'attente dépassé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567503G"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "network_error",
    "reason": "timeout of 10000 ms exceeded",
    "message": "Une erreur est survenue lors de l'appel au fournisseur de donnée"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567503G' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility.yml](civility.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "MARTIN",
    "prenom": "Jacques",
    "dateDeNaissance": "2004-01-01",
    "sexe": "m",
    "birth_place": "75002"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Martin",
    "prenom": "Jacques",
    "dateNaissance": "2004-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2020-07-01",
        "dateFinInscription": "2021-08-31",
        "statut": "inscrit",
        "codeCommune": "33063",
        "etablissement": {
          "uai": "0330023W",
          "nomEtablissement": "LYCEE GENERAL ET TECHNOLOGIQUE CAMILLE JULLIAN"
        },
        "regime": "formation initiale"
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nom=MARTIN' -d 'prenom=Jacques' -d 'dateDeNaissance=2004-01-01' -d 'sexe=m' -d 'birth_place=75002' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [fake_france_connect_mesri_with.yml](fake_france_connect_mesri_with.yml)

  Status `200`

  FranceConnect: étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "given_name": "Jean",
    "family_name": "MESRI",
    "birthdate": "2002-01-01",
    "gender": "male",
    "birthplace": "75002"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890T",
    "nomFamille": "Mesri",
    "prenom": "Jean",
    "dateNaissance": "2002-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2020-07-01",
        "dateFinInscription": "2021-08-31",
        "statut": "inscrit",
        "codeCommune": "33063",
        "etablissement": {
          "uai": "0330023W",
          "nomEtablissement": "LYCEE GENERAL ET TECHNOLOGIQUE CAMILLE JULLIAN"
        },
        "regime": "formation initiale"
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'given_name=Jean' -d 'family_name=MESRI' -d 'birthdate=2002-01-01' -d 'gender=male' -d 'birthplace=75002' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
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
    "given_name": "Angela Claire Louise",
    "family_name": "DUBOIS",
    "birthdate": "1962-08-24",
    "gender": "female",
    "birthplace": "75107"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890T",
    "nomFamille": "DUBOIS",
    "prenom": "Angela Claire Louise",
    "dateNaissance": "1962-08-24",
    "inscriptions": [
      {
        "dateDebutInscription": "2020-07-01",
        "dateFinInscription": "2021-08-31",
        "statut": "inscrit",
        "codeCommune": "33063",
        "etablissement": {
          "uai": "0330023W",
          "nomEtablissement": "LYCEE GENERAL ET TECHNOLOGIQUE CAMILLE JULLIAN"
        },
        "regime": "formation initiale"
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'given_name=Angela+Claire+Louise' -d 'family_name=DUBOIS' -d 'birthdate=1962-08-24' -d 'gender=female' -d 'birthplace=75107' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine.yaml](ine.yaml)

  Status `200`

  Étudiant inscrit (appel par INE)

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
    "ine": "1234567890A",
    "nomFamille": "Dupont",
    "prenom": "Jean",
    "dateNaissance": "2002-02-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2020-09-01",
        "dateFinInscription": "2021-06-31",
        "statut": "inscrit",
        "codeCommune": "33199",
        "etablissement": {
          "uai": "0332870R",
          "nomEtablissement": "LPO LYCEE DES METIERS DE LA MER"
        },
        "regime": "formation initiale"
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
