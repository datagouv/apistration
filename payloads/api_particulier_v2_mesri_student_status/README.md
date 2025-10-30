# Statut étudiant
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
* [cicility_etudiant_formation_continue.yml](cicility_etudiant_formation_continue.yml)

  Status `200`

  Étudiant inscrit formation continue

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "SOULI",
    "prenom": "Walid",
    "dateDeNaissance": "1998-01-01",
    "sexe": "m",
    "lieuDeNaissance": "78000"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": " SOULI ",
    "prenom": "Walid",
    "dateNaissance": "1998-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2023-07-01",
        "dateFinInscription": "2024-08-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Paris Saclay"
        },
        "regime": "formation continue"
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
    -G -d 'nom=SOULI' -d 'prenom=Walid' -d 'dateDeNaissance=1998-01-01' -d 'sexe=m' -d 'lieuDeNaissance=78000' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_admis.yml](civility_etudiant_admis.yml)

  Status `200`

  Étudiant ADMIS

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "MELINARD",
    "prenom": "PATRICK",
    "dateDeNaissance": "1990-01-01",
    "sexe": "m",
    "lieuDeNaissance": "78000"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": " MELINARD ",
    "prenom": " PATRICK ",
    "dateNaissance": "1990-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2023-07-01",
        "dateFinInscription": "2024-08-31",
        "statut": "admis",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Paris Saclay"
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
    -G -d 'nom=MELINARD' -d 'prenom=PATRICK' -d 'dateDeNaissance=1990-01-01' -d 'sexe=m' -d 'lieuDeNaissance=78000' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_admis_averone_denis.yml](civility_etudiant_admis_averone_denis.yml)

  Status `200`

  Étudiant admis

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Avérone",
    "prenom": "Denis",
    "dateDeNaissance": "2005-08-01",
    "sexe": "m",
    "lieuDeNaissance": "78646"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234522890Y",
    "nomFamille": "Avérone",
    "prenom": "Denis",
    "dateNaissance": "2005-08-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-07-31",
        "statut": "admis",
        "codeCommune": "93430",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Sorbonne Paris Nord"
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
    -G -d 'nom=Av%C3%A9rone' -d 'prenom=Denis' -d 'dateDeNaissance=2005-08-01' -d 'sexe=m' -d 'lieuDeNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit-calidone-lola.yml](civility_etudiant_inscrit-calidone-lola.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "CALIDONE",
    "prenom": "Lola",
    "dateDeNaissance": "2005-01-01",
    "sexe": "f",
    "lieuDeNaissance": "75109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567811Y",
    "nomFamille": "CALIDONE",
    "prenom": "Lola",
    "dateNaissance": "2005-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-07-31",
        "statut": "inscrit",
        "codeCommune": "92000",
        "etablissement": {
          "uai": "0334523W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=CALIDONE' -d 'prenom=Lola' -d 'dateDeNaissance=2005-01-01' -d 'sexe=f' -d 'lieuDeNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit.yml](civility_etudiant_inscrit.yml)

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
    "lieuDeNaissance": "75102"
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
        "dateDebutInscription": "2024-10-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "92000",
        "etablissement": {
          "uai": "0330023W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=MARTIN' -d 'prenom=Jacques' -d 'dateDeNaissance=2004-01-01' -d 'sexe=m' -d 'lieuDeNaissance=75102' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_2022.yml](civility_etudiant_inscrit_2022.yml)

  Status `200`

  Étudiant inscrit 2022

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "SOULI",
    "prenom": "Asma",
    "dateDeNaissance": "2002-01-01",
    "sexe": "m",
    "lieuDeNaissance": "75002"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": " SOULI ",
    "prenom": "Asma",
    "dateNaissance": "2002-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2022-07-01",
        "dateFinInscription": "2023-08-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Paris Saclay"
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
    -G -d 'nom=SOULI' -d 'prenom=Asma' -d 'dateDeNaissance=2002-01-01' -d 'sexe=m' -d 'lieuDeNaissance=75002' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_2023_bretagne_lisa.yml](civility_etudiant_inscrit_2023_bretagne_lisa.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "BRETAGNE",
    "prenom": "Lisa",
    "dateDeNaissance": "2005-06-01",
    "sexe": "f",
    "lieuDeNaissance": "93008"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1296522890Y",
    "nomFamille": "BRETAGNE",
    "prenom": "Lisa",
    "dateNaissance": "2005-06-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2023-09-01",
        "dateFinInscription": "2024-07-31",
        "statut": "inscrit",
        "codeCommune": "93430",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": " Université Sorbonne Paris Nord"
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
    -G -d 'nom=BRETAGNE' -d 'prenom=Lisa' -d 'dateDeNaissance=2005-06-01' -d 'sexe=f' -d 'lieuDeNaissance=93008' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_a.yml](civility_etudiant_inscrit_a.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "JUIN",
    "prenom": "Romuald",
    "dateDeNaissance": "2005-06-15",
    "sexe": "m",
    "lieuDeNaissance": "75115"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Juin",
    "prenom": "Romuald",
    "dateNaissance": "2005-06-15",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "92000",
        "etablissement": {
          "uai": "0330023W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=JUIN' -d 'prenom=Romuald' -d 'dateDeNaissance=2005-06-15' -d 'sexe=m' -d 'lieuDeNaissance=75115' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_auverne_luc.yml](civility_etudiant_inscrit_auverne_luc.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "AUVERNE",
    "prenom": "Luc",
    "dateDeNaissance": "2006-02-01",
    "sexe": "m",
    "lieuDeNaissance": "95018"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234227890Y",
    "nomFamille": " AUVERNE",
    "prenom": "Luc",
    "dateNaissance": "2006-02-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-01-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "78000",
        "etablissement": {
          "uai": "0331034W",
          "nomEtablissement": " Université de Versailles"
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
    -G -d 'nom=AUVERNE' -d 'prenom=Luc' -d 'dateDeNaissance=2006-02-01' -d 'sexe=m' -d 'lieuDeNaissance=95018' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_b.yml](civility_etudiant_inscrit_b.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "JUIN",
    "prenom": "Esmeralda",
    "dateDeNaissance": "2000-12-24",
    "sexe": "f",
    "lieuDeNaissance": "75113"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Juin",
    "prenom": "Esmeralda",
    "dateNaissance": "2000-12-24",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-10-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "92000",
        "etablissement": {
          "uai": "0330023W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=JUIN' -d 'prenom=Esmeralda' -d 'dateDeNaissance=2000-12-24' -d 'sexe=f' -d 'lieuDeNaissance=75113' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_becker_valirianne.yml](civility_etudiant_inscrit_becker_valirianne.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "BECKER",
    "prenom": "VALIRIANNE",
    "dateDeNaissance": "2000-01-01",
    "sexe": "f",
    "lieuDeNaissance": "75109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1274451233Y",
    "nomFamille": "BECKER",
    "prenom": "VALIRIANNE",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-01-01",
        "dateFinInscription": "2025-11-30",
        "statut": "inscrit",
        "codeCommune": "75006",
        "etablissement": {
          "uai": "0292973W",
          "nomEtablissement": "Université Paris Cité"
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
    -G -d 'nom=BECKER' -d 'prenom=VALIRIANNE' -d 'dateDeNaissance=2000-01-01' -d 'sexe=f' -d 'lieuDeNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_clermont_louis.yml](civility_etudiant_inscrit_clermont_louis.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "CLERMONT",
    "prenom": "Louis",
    "dateDeNaissance": "2000-01-01",
    "sexe": "m",
    "lieuDeNaissance": "78646"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1884567890Y",
    "nomFamille": "CLERMONT",
    "prenom": "Louis",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-10-01",
        "dateFinInscription": "2025-09-30",
        "statut": "inscrit",
        "codeCommune": "78100",
        "etablissement": {
          "uai": "0309023W",
          "nomEtablissement": " Sciences Po"
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
    -G -d 'nom=CLERMONT' -d 'prenom=Louis' -d 'dateDeNaissance=2000-01-01' -d 'sexe=m' -d 'lieuDeNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_ibarra_jennyfer.yml](civility_etudiant_inscrit_ibarra_jennyfer.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "IBARRA",
    "prenom": "JENNYFER",
    "dateDeNaissance": "2004-01-01",
    "sexe": "f",
    "lieuDeNaissance": "75109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1279955890Y",
    "nomFamille": "IBARRA",
    "prenom": "JENNYFER",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-01-01",
        "dateFinInscription": "2025-12-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0361113W",
          "nomEtablissement": "ESCG"
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
    -G -d 'nom=IBARRA' -d 'prenom=JENNYFER' -d 'dateDeNaissance=2004-01-01' -d 'sexe=f' -d 'lieuDeNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_izak_john.yml](civility_etudiant_inscrit_izak_john.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "IZAK",
    "prenom": "John",
    "dateDeNaissance": "2000-01-01",
    "sexe": "m",
    "lieuDeNaissance": "75109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1277533890Y",
    "nomFamille": "IZAK",
    "prenom": "John",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-07-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331313W",
          "nomEtablissement": "ESCG"
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
    -G -d 'nom=IZAK' -d 'prenom=John' -d 'dateDeNaissance=2000-01-01' -d 'sexe=m' -d 'lieuDeNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_leterien_clementine.yml](civility_etudiant_inscrit_leterien_clementine.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "LETERIEN",
    "prenom": "Clémentine",
    "dateDeNaissance": "2000-01-01",
    "sexe": "f",
    "lieuDeNaissance": " 99404"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1274451233Y",
    "nomFamille": "LETERIEN",
    "prenom": "Clémentine",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-01-01",
        "dateFinInscription": "2025-11-30",
        "statut": "inscrit",
        "codeCommune": "75006",
        "etablissement": {
          "uai": "0292973W",
          "nomEtablissement": "Université Paris Cité"
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
    -G -d 'nom=LETERIEN' -d 'prenom=Cl%C3%A9mentine' -d 'dateDeNaissance=2000-01-01' -d 'sexe=f' -d 'lieuDeNaissance=+99404' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_luc_de_jean.yml](civility_etudiant_inscrit_luc_de_jean.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "DE JEAN",
    "prenom": "LUC",
    "dateDeNaissance": "2000-01-01",
    "sexe": "m",
    "lieuDeNaissance": "99352"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1274451233Y",
    "nomFamille": "DE JEAN",
    "prenom": "LUC",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-01-01",
        "dateFinInscription": "2025-11-30",
        "statut": "inscrit",
        "codeCommune": "75006",
        "etablissement": {
          "uai": "0292973W",
          "nomEtablissement": "Université Paris Cité"
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
    -G -d 'nom=DE+JEAN' -d 'prenom=LUC' -d 'dateDeNaissance=2000-01-01' -d 'sexe=m' -d 'lieuDeNaissance=99352' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_mayville_tina.yml](civility_etudiant_inscrit_mayville_tina.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "MAYVILLE",
    "prenom": "TINA",
    "dateDeNaissance": "2000-01-01",
    "sexe": "f",
    "lieuDeNaissance": "75109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1277555890Y",
    "nomFamille": "MAYVILLE",
    "prenom": "Tina",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-07-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0366313W",
          "nomEtablissement": "ESCG"
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
    -G -d 'nom=MAYVILLE' -d 'prenom=TINA' -d 'dateDeNaissance=2000-01-01' -d 'sexe=f' -d 'lieuDeNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_mediz_louis.yml](civility_etudiant_inscrit_mediz_louis.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "MEDIZ",
    "prenom": "Louis",
    "dateDeNaissance": "2000-01-01",
    "sexe": "m",
    "lieuDeNaissance": "75109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1274451290Y",
    "nomFamille": "MEDIZ",
    "prenom": "Louis",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-07-31",
        "statut": "inscrit",
        "codeCommune": "75006",
        "etablissement": {
          "uai": "0292613W",
          "nomEtablissement": "Université Paris Cité"
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
    -G -d 'nom=MEDIZ' -d 'prenom=Louis' -d 'dateDeNaissance=2000-01-01' -d 'sexe=m' -d 'lieuDeNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_mont-parrain-lisa.yml](civility_etudiant_inscrit_mont-parrain-lisa.yml)

  Status `200`

  Etudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "MONT-PARRAIN",
    "prenom": "Lisa",
    "dateDeNaissance": "2000-01-01",
    "sexe": "f",
    "lieuDeNaissance": " 99109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1274451233Y",
    "nomFamille": "MONT-PARRAIN",
    "prenom": "Lisa",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-01-01",
        "dateFinInscription": "2025-11-30",
        "statut": "inscrit",
        "codeCommune": "75006",
        "etablissement": {
          "uai": "0292973W",
          "nomEtablissement": "Université Paris Cité"
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
    -G -d 'nom=MONT-PARRAIN' -d 'prenom=Lisa' -d 'dateDeNaissance=2000-01-01' -d 'sexe=f' -d 'lieuDeNaissance=+99109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_yolan_john.yml](civility_etudiant_inscrit_yolan_john.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "YOLAN",
    "prenom": "JOHN",
    "dateDeNaissance": "2007-01-01",
    "sexe": "f",
    "lieuDeNaissance": "75109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1274455891Y",
    "nomFamille": "YOLAN",
    "prenom": "JOHN",
    "dateNaissance": "2007-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-10-01",
        "dateFinInscription": "2025-09-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0320613W",
          "nomEtablissement": "ESCG"
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
    -G -d 'nom=YOLAN' -d 'prenom=JOHN' -d 'dateDeNaissance=2007-01-01' -d 'sexe=f' -d 'lieuDeNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_formation_continue_colonel_jean.yml](civility_formation_continue_colonel_jean.yml)

  Status `200`

  Étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "COLONEL",
    "prenom": "Jean",
    "dateDeNaissance": "2005-08-01",
    "sexe": "m",
    "lieuDeNaissance": "78646"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1296522890Y",
    "nomFamille": "COLONEL",
    "prenom": "Jean",
    "dateNaissance": "2005-08-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-07-31",
        "statut": "inscrit",
        "codeCommune": "93430",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": " Université Sorbonne Paris Nord"
        },
        "regime": "formation continue"
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
    -G -d 'nom=COLONEL' -d 'prenom=Jean' -d 'dateDeNaissance=2005-08-01' -d 'sexe=m' -d 'lieuDeNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [fake_france_connect_mesri.yml](fake_france_connect_mesri.yml)

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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_mesri_2.yml](fake_france_connect_mesri_2.yml)

  Status `200`

  FranceConnect: étudiant inscrit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "given_name": "Thomas",
    "family_name": "Delatour",
    "birthdate": "1994-04-16",
    "gender": "male",
    "birthplace": "75111",
    "prenoms": [
      "Thomas"
    ],
    "nomNaissance": "Delatour",
    "nomUsage": "Delamouette",
    "anneeDateDeNaissance": 1994,
    "moisDateDeNaissance": 4,
    "jourDateDeNaissance": 16,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "75111",
    "codePaysLieuDeNaissance": "99100"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants?recipient=13002526500013"
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
    "given_name": "Angela",
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants?recipient=13002526500013"
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
* [ine_0100007108D.yaml](ine_0100007108D.yaml)

  Status `200`

  Étudiant 0100007108D inscrit (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0100007108D"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "0100007108D",
    "nom": "MARTIN",
    "prenom": "Jeanne",
    "dateNaissance": "2001-11-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-08-01",
        "dateFinInscription": "2025-09-30",
        "statut": "inscrit",
        "codeCommune": "75020",
        "etablissement": {
          "uai": "0750106H",
          "nomEtablissement": "ECOLE TECHNOLOGIQUE PRIVEE"
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
    -G -d 'ine=0100007108D' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_0100008010J.yaml](ine_0100008010J.yaml)

  Status `200`

  Étudiant 0100008010J inscrit (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0100008010J"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "0100008010J",
    "nom": "Petit",
    "prenom": "Thomas",
    "dateNaissance": "2000-02-12",
    "inscriptions": [
      {
        "dateDebutInscription": "2019-02-16",
        "dateFinInscription": "2021-05-30",
        "statut": "inscrit",
        "codeCommune": "75020",
        "etablissement": {
          "uai": "0750106H",
          "nomEtablissement": "ECOLE TECHNOLOGIQUE PRIVEE"
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
    -G -d 'ine=0100008010J' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_012345678AA.yaml](ine_012345678AA.yaml)

  Status `200`

  Étudiant 012345678AA inscrit (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "012345678AA"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "012345678AA",
    "nom": "DUBOIS",
    "prenom": "Jean",
    "dateNaissance": "2003-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2020-09-11",
        "dateFinInscription": "2022-06-30",
        "statut": "inscrit",
        "codeCommune": "75020",
        "etablissement": {
          "uai": "0750106H",
          "nomEtablissement": "ECOLE TECHNOLOGIQUE PRIVEE"
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
    -G -d 'ine=012345678AA' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567890B_expired.yaml](ine_1234567890B_expired.yaml)

  Status `200`

  Étudiant 1234567890B inscrit (appel par INE), année scolaire 2022 à Toulouse

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
    "ine": "1234567890B",
    "nom": "Longchambon",
    "prenom": "Thomas",
    "dateNaissance": "2001-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2022-09-01",
        "dateFinInscription": "2023-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567890B' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567890C_2023_toulouse.yaml](ine_1234567890C_2023_toulouse.yaml)

  Status `200`

  Étudiant 1234567890C inscrit (appel par INE), année scolaire 2023 à Toulouse

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
    "ine": "1234567890C",
    "nom": "Charbonneau",
    "prenom": "Axelle",
    "dateNaissance": "2001-01-02",
    "inscriptions": [
      {
        "dateDebutInscription": "2023-09-01",
        "dateFinInscription": "2024-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567890C' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567890D_2023_toulouse.yaml](ine_1234567890D_2023_toulouse.yaml)

  Status `200`

  Étudiant 1234567890D inscrit (appel par INE), année scolaire 2023 à Toulouse

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
    "ine": "1234567890D",
    "nom": "Montgomery",
    "prenom": "Marie",
    "dateNaissance": "2001-01-03",
    "inscriptions": [
      {
        "dateDebutInscription": "2023-09-01",
        "dateFinInscription": "2024-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567890D' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567890E_2023_paris.yaml](ine_1234567890E_2023_paris.yaml)

  Status `200`

  Étudiant 1234567890E inscrit (appel par INE), année scolaire 2023 à Paris

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890E"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890E",
    "nom": "Granet",
    "prenom": "Cyril",
    "dateNaissance": "2001-01-04",
    "inscriptions": [
      {
        "dateDebutInscription": "2023-09-01",
        "dateFinInscription": "2024-08-31",
        "statut": "inscrit",
        "codeCommune": "75020",
        "etablissement": {
          "uai": "0750106H",
          "nomEtablissement": "ECOLE TECHNOLOGIQUE PRIVEE"
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
    -G -d 'ine=1234567890E' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567890F_2024_toulouse.yaml](ine_1234567890F_2024_toulouse.yaml)

  Status `200`

  Étudiant 1234567890F inscrit (appel par INE), année scolaire 2024 à Toulouse

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890F",
    "nom": "Le Tonnelier",
    "prenom": "Pierre-Marie",
    "dateNaissance": "2001-01-03",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567890F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567891A_2025_toulouse.yaml](ine_1234567891A_2025_toulouse.yaml)

  Status `200`

  Étudiant 1234567891A inscrit (appel par INE), année scolaire 2025 à Toulouse

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
    "ine": "1234567891A",
    "nom": "Simon",
    "prenom": "Lilian",
    "dateNaissance": "2005-01-03",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567891A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567891B_2025_toulouse.yaml](ine_1234567891B_2025_toulouse.yaml)

  Status `200`

  Étudiant 1234567891B inscrit (appel par INE), année scolaire 2025 à Toulouse

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
    "ine": "1234567891B",
    "nom": "Bel aalia",
    "prenom": "Sahra",
    "dateNaissance": "2005-01-03",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567891B' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567891C_2025_toulouse.yaml](ine_1234567891C_2025_toulouse.yaml)

  Status `200`

  Étudiant 1234567891C inscrit (appel par INE), année scolaire 2025 à Toulouse

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
    "ine": "1234567891C",
    "nom": "Vaillancourt",
    "prenom": "Gael",
    "dateNaissance": "1999-06-21",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567891C' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_1234567891D_2025_toulouse.yaml](ine_1234567891D_2025_toulouse.yaml)

  Status `200`

  Étudiant 1234567891D inscrit (appel par INE), année scolaire 2025 à Toulouse

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
    "ine": "1234567891D",
    "nom": "Puges",
    "prenom": "Aurelie",
    "dateNaissance": "1999-06-21",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-08-31",
        "statut": "inscrit",
        "codeCommune": "31555",
        "etablissement": {
          "uai": "0313124C",
          "nomEtablissement": "Université Toulouse Capitole"
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
    -G -d 'ine=1234567891D' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_655888578AE.yaml](ine_655888578AE.yaml)

  Status `200`

  Étudiant 655888578AE inscrit (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "655888578AE"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "655888578AE",
    "nom": "KOSAKAMI",
    "prenom": "Korako",
    "dateNaissance": "2002-10-13",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-06-31",
        "statut": "inscrit",
        "codeCommune": "75020",
        "etablissement": {
          "uai": "0750106H",
          "nomEtablissement": "ECOLE TECHNOLOGIQUE PRIVEE"
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
    -G -d 'ine=655888578AE' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_660309901AG.yaml](ine_660309901AG.yaml)

  Status `200`

  Étudiant 660309901AG inscrit (appel par INE), ne renvoie pas d'INE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "660309901AG"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "nom": "LEBRETON",
    "prenom": "Arnaud",
    "dateNaissance": "1988-09-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-06-31",
        "statut": "inscrit",
        "codeCommune": "75020",
        "etablissement": {
          "uai": "0750106H",
          "nomEtablissement": "ECOLE TECHNOLOGIQUE PRIVEE"
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
    -G -d 'ine=660309901AG' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_675773666AD.yaml](ine_675773666AD.yaml)

  Status `200`

  Étudiant 675773666AD inscrit (appel par INE)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "675773666AD"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "675773666AD",
    "nom": "Moreau",
    "prenom": "Aurélie",
    "dateNaissance": "2002-01-02",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-06-31",
        "statut": "inscrit",
        "codeCommune": "75020",
        "etablissement": {
          "uai": "0750106H",
          "nomEtablissement": "ECOLE TECHNOLOGIQUE PRIVEE"
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
    -G -d 'ine=675773666AD' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_697720085AL.yaml](ine_697720085AL.yaml)

  Status `500`

  Étudiant 697720085AL inscrit (appel par INE) : erreur interne serveur

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "697720085AL"
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
    -G -d 'ine=697720085AL' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [ine_697720085AO.yaml](ine_697720085AO.yaml)

  Status `404`

  Étudiant 697720085AO (appel par INE) : Étudiant non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "697720085AO"
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
    -G -d 'ine=697720085AO' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
