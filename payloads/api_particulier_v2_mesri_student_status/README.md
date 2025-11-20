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
    "nomFamille": "MELINARD",
    "prenom": "PATRICK",
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
* [civility_etudiant_admis_autorbb_lance.yml](civility_etudiant_admis_autorbb_lance.yml)

  Status `200`

  Étudiant admis AUTORBB LANCE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "AUTORBB",
    "prenom": "LANCE",
    "dateDeNaissance": "2005-02-05",
    "sexe": "m",
    "lieuDeNaissance": "99138"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "AUTORBB",
    "prenom": "LANCE",
    "dateNaissance": "2005-02-05",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-12-31",
        "statut": "admis",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=AUTORBB' -d 'prenom=LANCE' -d 'dateDeNaissance=2005-02-05' -d 'sexe=m' -d 'lieuDeNaissance=99138' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_admis_autorbb_pierre.yml](civility_etudiant_admis_autorbb_pierre.yml)

  Status `200`

  Étudiant admis AUTORBB PIERRE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "AUTORBB",
    "prenom": "PIERRE",
    "dateDeNaissance": "2001-02-05",
    "sexe": "m",
    "lieuDeNaissance": "99424"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "AUTORBB",
    "prenom": "PIERRE",
    "dateNaissance": "2001-02-05",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-12-31",
        "statut": "admis",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=AUTORBB' -d 'prenom=PIERRE' -d 'dateDeNaissance=2001-02-05' -d 'sexe=m' -d 'lieuDeNaissance=99424' \
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
    "ine": "1234567890Y",
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
* [civility_etudiant_admis_figo_luis.yml](civility_etudiant_admis_figo_luis.yml)

  Status `200`

  Étudiant admis Figo Luis

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Figo",
    "prenom": "Luis",
    "dateDeNaissance": "2003-06-27",
    "sexe": "m",
    "lieuDeNaissance": "59350"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Figo",
    "prenom": "Luis",
    "dateNaissance": "2003-06-27",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-12-31",
        "statut": "admis",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=Figo' -d 'prenom=Luis' -d 'dateDeNaissance=2003-06-27' -d 'sexe=m' -d 'lieuDeNaissance=59350' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_admis_nani_luis.yml](civility_etudiant_admis_nani_luis.yml)

  Status `200`

  Étudiant admis Nani Luis

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Nani",
    "prenom": "Luis",
    "dateDeNaissance": "2002-04-25",
    "sexe": "m",
    "lieuDeNaissance": "99331"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Nani",
    "prenom": "Luis",
    "dateNaissance": "2002-04-25",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-12-31",
        "statut": "admis",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Nani' -d 'prenom=Luis' -d 'dateDeNaissance=2002-04-25' -d 'sexe=m' -d 'lieuDeNaissance=99331' \
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
    "ine": "1234567890Y",
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
    "nomFamille": "SOULI",
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
    "ine": "1234567890Y",
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
    "ine": "1234567890Y",
    "nomFamille": "AUVERNE",
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
    "ine": "1234567890Y",
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
* [civility_etudiant_inscrit_bispo_antoinette_hanan.yml](civility_etudiant_inscrit_bispo_antoinette_hanan.yml)

  Status `200`

  Étudiant inscrit Bispo-Antoinette Hanan

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Bispo-Antoinette",
    "prenom": "Hanan",
    "dateDeNaissance": "1999-12-24",
    "sexe": "f",
    "lieuDeNaissance": "93010"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Bispo-Antoinette",
    "prenom": "Hanan",
    "dateNaissance": "1999-12-24",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Bispo-Antoinette' -d 'prenom=Hanan' -d 'dateDeNaissance=1999-12-24' -d 'sexe=f' -d 'lieuDeNaissance=93010' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_blobla_lina.yml](civility_etudiant_inscrit_blobla_lina.yml)

  Status `200`

  Étudiant inscrit blobla Lina

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "blobla",
    "prenom": "Lina",
    "dateDeNaissance": "2002-07-25",
    "sexe": "f",
    "lieuDeNaissance": "67482"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "blobla",
    "prenom": "Lina",
    "dateNaissance": "2002-07-25",
    "inscriptions": [
      {
        "dateDebutInscription": "2027-01-01",
        "dateFinInscription": "2027-12-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=blobla' -d 'prenom=Lina' -d 'dateDeNaissance=2002-07-25' -d 'sexe=f' -d 'lieuDeNaissance=67482' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_bob_nassima.yml](civility_etudiant_inscrit_bob_nassima.yml)

  Status `200`

  Étudiant inscrit Bob Nassima

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Bob",
    "prenom": "Nassima",
    "dateDeNaissance": "2004-12-04",
    "sexe": "f",
    "lieuDeNaissance": "99335"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Bob",
    "prenom": "Nassima",
    "dateNaissance": "2004-12-04",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-09-01",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Bob' -d 'prenom=Nassima' -d 'dateDeNaissance=2004-12-04' -d 'sexe=f' -d 'lieuDeNaissance=99335' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_caravelle_marc_antoine.yml](civility_etudiant_inscrit_caravelle_marc_antoine.yml)

  Status `200`

  Étudiant inscrit Caravelle Marc-Antoine

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Caravelle",
    "prenom": "Marc-Antoine",
    "dateDeNaissance": "2002-04-15",
    "sexe": "m",
    "lieuDeNaissance": "75110"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Caravelle",
    "prenom": "Marc-Antoine",
    "dateNaissance": "2002-04-15",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Caravelle' -d 'prenom=Marc-Antoine' -d 'dateDeNaissance=2002-04-15' -d 'sexe=m' -d 'lieuDeNaissance=75110' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_carey_abdelhay.yml](civility_etudiant_inscrit_carey_abdelhay.yml)

  Status `200`

  Étudiant inscrit Carey Abdelhay

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Carey",
    "prenom": "Abdelhay",
    "dateDeNaissance": "2003-07-11",
    "sexe": "m",
    "lieuDeNaissance": "77373"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Carey",
    "prenom": "Abdelhay",
    "dateNaissance": "2003-07-11",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Carey' -d 'prenom=Abdelhay' -d 'dateDeNaissance=2003-07-11' -d 'sexe=m' -d 'lieuDeNaissance=77373' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_chateau_elyes.yml](civility_etudiant_inscrit_chateau_elyes.yml)

  Status `200`

  Étudiant inscrit Chateau Elyes

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Chateau",
    "prenom": "Elyes",
    "dateDeNaissance": "2006-07-25",
    "sexe": "m",
    "lieuDeNaissance": "75105"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Chateau",
    "prenom": "Elyes",
    "dateNaissance": "2006-07-25",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Chateau' -d 'prenom=Elyes' -d 'dateDeNaissance=2006-07-25' -d 'sexe=m' -d 'lieuDeNaissance=75105' \
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
    "ine": "1234567890Y",
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
* [civility_etudiant_inscrit_de_carvalho_alexandra.yml](civility_etudiant_inscrit_de_carvalho_alexandra.yml)

  Status `200`

  Étudiant inscrit De Carvalho Alexandra

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "De Carvalho",
    "prenom": "Alexandra",
    "dateDeNaissance": "2000-03-14",
    "sexe": "f",
    "lieuDeNaissance": "69123"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "De Carvalho",
    "prenom": "Alexandra",
    "dateNaissance": "2000-03-14",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-11-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=De+Carvalho' -d 'prenom=Alexandra' -d 'dateDeNaissance=2000-03-14' -d 'sexe=f' -d 'lieuDeNaissance=69123' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_delin_antoine.yml](civility_etudiant_inscrit_delin_antoine.yml)

  Status `200`

  Étudiant inscrit Delin Antoine

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Delin",
    "prenom": "Antoine",
    "dateDeNaissance": "2000-12-03",
    "sexe": "m",
    "lieuDeNaissance": "99139"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Delin",
    "prenom": "Antoine",
    "dateNaissance": "2000-12-03",
    "inscriptions": [
      {
        "dateDebutInscription": "2026-12-31",
        "dateFinInscription": "2027-06-12",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Delin' -d 'prenom=Antoine' -d 'dateDeNaissance=2000-12-03' -d 'sexe=m' -d 'lieuDeNaissance=99139' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_duper_louise.yml](civility_etudiant_inscrit_duper_louise.yml)

  Status `200`

  Étudiant inscrit Duper Louise

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Duper",
    "prenom": "Louise",
    "dateDeNaissance": "2001-01-10",
    "sexe": "f",
    "lieuDeNaissance": "99208"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Duper",
    "prenom": "Louise",
    "dateNaissance": "2001-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Duper' -d 'prenom=Louise' -d 'dateDeNaissance=2001-01-10' -d 'sexe=f' -d 'lieuDeNaissance=99208' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_dupont_nouhe.yml](civility_etudiant_inscrit_dupont_nouhe.yml)

  Status `200`

  Étudiant inscrit Dupont Nouhe

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Dupont",
    "prenom": "Nouhe",
    "dateDeNaissance": "2007-12-09",
    "sexe": "m",
    "lieuDeNaissance": "92073"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Dupont",
    "prenom": "Nouhe",
    "dateNaissance": "2007-12-09",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-12-01",
        "dateFinInscription": "2026-12-10",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Dupont' -d 'prenom=Nouhe' -d 'dateDeNaissance=2007-12-09' -d 'sexe=m' -d 'lieuDeNaissance=92073' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_dupr__hind.yml](civility_etudiant_inscrit_dupr__hind.yml)

  Status `200`

  Étudiant inscrit Dupré Hind

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Dupré",
    "prenom": "Hind",
    "dateDeNaissance": "2000-12-08",
    "sexe": "f",
    "lieuDeNaissance": "99138"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Dupré",
    "prenom": "Hind",
    "dateNaissance": "2000-12-08",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Dupr%C3%A9' -d 'prenom=Hind' -d 'dateDeNaissance=2000-12-08' -d 'sexe=f' -d 'lieuDeNaissance=99138' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_garuba_feryel.yml](civility_etudiant_inscrit_garuba_feryel.yml)

  Status `200`

  Étudiant inscrit Garuba Feryel

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Garuba",
    "prenom": "Feryel",
    "dateDeNaissance": "2001-01-11",
    "sexe": "f",
    "lieuDeNaissance": "99331"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Garuba",
    "prenom": "Feryel",
    "dateNaissance": "2001-01-11",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-10-01",
        "dateFinInscription": "2025-09-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Garuba' -d 'prenom=Feryel' -d 'dateDeNaissance=2001-01-11' -d 'sexe=f' -d 'lieuDeNaissance=99331' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_hamilton_nicole.yml](civility_etudiant_inscrit_hamilton_nicole.yml)

  Status `200`

  Étudiant inscrit Hamilton Nicole

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Hamilton",
    "prenom": "Nicole",
    "dateDeNaissance": "2002-07-18",
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
    "nomFamille": "Hamilton",
    "prenom": "Nicole",
    "dateNaissance": "2002-07-18",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Hamilton' -d 'prenom=Nicole' -d 'dateDeNaissance=2002-07-18' -d 'sexe=f' -d 'lieuDeNaissance=75113' \
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
    "ine": "1234567890Y",
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
    "ine": "1234567890Y",
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
* [civility_etudiant_inscrit_lenovo_charles.yml](civility_etudiant_inscrit_lenovo_charles.yml)

  Status `200`

  Étudiant inscrit Lenovo Charles

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Lenovo",
    "prenom": "Charles",
    "dateDeNaissance": "2001-01-10",
    "sexe": "m",
    "lieuDeNaissance": "67482"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Lenovo",
    "prenom": "Charles",
    "dateNaissance": "2001-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Lenovo' -d 'prenom=Charles' -d 'dateDeNaissance=2001-01-10' -d 'sexe=m' -d 'lieuDeNaissance=67482' \
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
    "lieuDeNaissance": "99404"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
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
    -G -d 'nom=LETERIEN' -d 'prenom=Cl%C3%A9mentine' -d 'dateDeNaissance=2000-01-01' -d 'sexe=f' -d 'lieuDeNaissance=99404' \
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
    "ine": "1234567890Y",
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
* [civility_etudiant_inscrit_lunette_zahid.yml](civility_etudiant_inscrit_lunette_zahid.yml)

  Status `200`

  Étudiant inscrit Lunette Zahid

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Lunette",
    "prenom": "Zahid",
    "dateDeNaissance": "2000-12-07",
    "sexe": "m",
    "lieuDeNaissance": "99241"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Lunette",
    "prenom": "Zahid",
    "dateNaissance": "2000-12-07",
    "inscriptions": [
      {
        "dateDebutInscription": "2026-12-01",
        "dateFinInscription": "2027-03-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Lunette' -d 'prenom=Zahid' -d 'dateDeNaissance=2000-12-07' -d 'sexe=m' -d 'lieuDeNaissance=99241' \
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
    "ine": "1234567890Y",
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
    "ine": "1234567890Y",
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
    "lieuDeNaissance": "99109"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
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
    -G -d 'nom=MONT-PARRAIN' -d 'prenom=Lisa' -d 'dateDeNaissance=2000-01-01' -d 'sexe=f' -d 'lieuDeNaissance=99109' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_nom_narjes.yml](civility_etudiant_inscrit_nom_narjes.yml)

  Status `200`

  Étudiant inscrit Nom Narjes

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Nom",
    "prenom": "Narjes",
    "dateDeNaissance": "2006-01-06",
    "sexe": "f",
    "lieuDeNaissance": "99424"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Nom",
    "prenom": "Narjes",
    "dateNaissance": "2006-01-06",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-12-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Nom' -d 'prenom=Narjes' -d 'dateDeNaissance=2006-01-06' -d 'sexe=f' -d 'lieuDeNaissance=99424' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_pereira_maoris.yml](civility_etudiant_inscrit_pereira_maoris.yml)

  Status `200`

  Étudiant inscrit Pereira Maoris

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Pereira",
    "prenom": "Maoris",
    "dateDeNaissance": "2002-08-05",
    "sexe": "m",
    "lieuDeNaissance": "99131"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Pereira",
    "prenom": "Maoris",
    "dateNaissance": "2002-08-05",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-10-10",
        "dateFinInscription": "2025-10-10",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Pereira' -d 'prenom=Maoris' -d 'dateDeNaissance=2002-08-05' -d 'sexe=m' -d 'lieuDeNaissance=99131' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_ramson_assya.yml](civility_etudiant_inscrit_ramson_assya.yml)

  Status `200`

  Étudiant inscrit RAMSON ASSYA

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RAMSON",
    "prenom": "ASSYA",
    "dateDeNaissance": "2001-03-12",
    "sexe": "f",
    "lieuDeNaissance": "75112"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RAMSON",
    "prenom": "ASSYA",
    "dateNaissance": "2001-03-12",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RAMSON' -d 'prenom=ASSYA' -d 'dateDeNaissance=2001-03-12' -d 'sexe=f' -d 'lieuDeNaissance=75112' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_randri_ishan.yml](civility_etudiant_inscrit_randri_ishan.yml)

  Status `200`

  Étudiant inscrit Randri Ishan

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Randri",
    "prenom": "Ishan",
    "dateDeNaissance": "2003-06-17",
    "sexe": "m",
    "lieuDeNaissance": "75112"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Randri",
    "prenom": "Ishan",
    "dateNaissance": "2003-06-17",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Randri' -d 'prenom=Ishan' -d 'dateDeNaissance=2003-06-17' -d 'sexe=m' -d 'lieuDeNaissance=75112' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_arnaud.yml](civility_etudiant_inscrit_rluhdefkwr_arnaud.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR ARNAUD

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "ARNAUD",
    "dateDeNaissance": "2001-01-10",
    "sexe": "m",
    "lieuDeNaissance": "97206"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "ARNAUD",
    "dateNaissance": "2001-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=ARNAUD' -d 'dateDeNaissance=2001-01-10' -d 'sexe=m' -d 'lieuDeNaissance=97206' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_aude.yml](civility_etudiant_inscrit_rluhdefkwr_aude.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR AUDE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "AUDE",
    "dateDeNaissance": "2001-01-10",
    "sexe": "f",
    "lieuDeNaissance": "92073"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "AUDE",
    "dateNaissance": "2001-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2027-01-01",
        "dateFinInscription": "2027-12-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=AUDE' -d 'dateDeNaissance=2001-01-10' -d 'sexe=f' -d 'lieuDeNaissance=92073' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_corentin.yml](civility_etudiant_inscrit_rluhdefkwr_corentin.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR CORENTIN

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "CORENTIN",
    "dateDeNaissance": "2001-01-10",
    "sexe": "m",
    "lieuDeNaissance": "97120"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "CORENTIN",
    "dateNaissance": "2001-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=CORENTIN' -d 'dateDeNaissance=2001-01-10' -d 'sexe=m' -d 'lieuDeNaissance=97120' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_elise.yml](civility_etudiant_inscrit_rluhdefkwr_elise.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR ELISE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "ELISE",
    "dateDeNaissance": "2001-01-10",
    "sexe": "f",
    "lieuDeNaissance": "75105"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "ELISE",
    "dateNaissance": "2001-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=ELISE' -d 'dateDeNaissance=2001-01-10' -d 'sexe=f' -d 'lieuDeNaissance=75105' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_flavien.yml](civility_etudiant_inscrit_rluhdefkwr_flavien.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR FLAVIEN

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "FLAVIEN",
    "dateDeNaissance": "2001-01-15",
    "sexe": "m",
    "lieuDeNaissance": "75110"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "FLAVIEN",
    "dateNaissance": "2001-01-15",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=FLAVIEN' -d 'dateDeNaissance=2001-01-15' -d 'sexe=m' -d 'lieuDeNaissance=75110' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_isabelle.yml](civility_etudiant_inscrit_rluhdefkwr_isabelle.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR ISABELLE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "ISABELLE",
    "dateDeNaissance": "2001-01-13",
    "sexe": "f",
    "lieuDeNaissance": "69123"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "ISABELLE",
    "dateNaissance": "2001-01-13",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=ISABELLE' -d 'dateDeNaissance=2001-01-13' -d 'sexe=f' -d 'lieuDeNaissance=69123' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_nathanael.yml](civility_etudiant_inscrit_rluhdefkwr_nathanael.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR NATHANAEL

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "NATHANAEL",
    "dateDeNaissance": "2000-01-01",
    "sexe": "m",
    "lieuDeNaissance": "75111"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "NATHANAEL",
    "dateNaissance": "2000-01-01",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-09-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=NATHANAEL' -d 'dateDeNaissance=2000-01-01' -d 'sexe=m' -d 'lieuDeNaissance=75111' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_nolan.yml](civility_etudiant_inscrit_rluhdefkwr_nolan.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR NOLAN

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "NOLAN",
    "dateDeNaissance": "2001-06-11",
    "sexe": "m",
    "lieuDeNaissance": "93010"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "NOLAN",
    "dateNaissance": "2001-06-11",
    "inscriptions": [
      {
        "dateDebutInscription": "2024-10-01",
        "dateFinInscription": "2025-08-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=NOLAN' -d 'dateDeNaissance=2001-06-11' -d 'sexe=m' -d 'lieuDeNaissance=93010' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_paul.yml](civility_etudiant_inscrit_rluhdefkwr_paul.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR PAUL

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "PAUL",
    "dateDeNaissance": "2000-09-20",
    "sexe": "m",
    "lieuDeNaissance": "93010"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "PAUL",
    "dateNaissance": "2000-09-20",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=PAUL' -d 'dateDeNaissance=2000-09-20' -d 'sexe=m' -d 'lieuDeNaissance=93010' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_pauline.yml](civility_etudiant_inscrit_rluhdefkwr_pauline.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR PAULINE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "PAULINE",
    "dateDeNaissance": "2001-01-20",
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
    "nomFamille": "RLUHDEFKWR",
    "prenom": "PAULINE",
    "dateNaissance": "2001-01-20",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=PAULINE' -d 'dateDeNaissance=2001-01-20' -d 'sexe=f' -d 'lieuDeNaissance=75113' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_rluhdefkwr_terrence.yml](civility_etudiant_inscrit_rluhdefkwr_terrence.yml)

  Status `200`

  Étudiant inscrit RLUHDEFKWR TERRENCE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "RLUHDEFKWR",
    "prenom": "TERRENCE",
    "dateDeNaissance": "2001-01-10",
    "sexe": "m",
    "lieuDeNaissance": "59350"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "RLUHDEFKWR",
    "prenom": "TERRENCE",
    "dateNaissance": "2001-01-10",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=RLUHDEFKWR' -d 'prenom=TERRENCE' -d 'dateDeNaissance=2001-01-10' -d 'sexe=m' -d 'lieuDeNaissance=59350' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_robinho_baptiste.yml](civility_etudiant_inscrit_robinho_baptiste.yml)

  Status `200`

  Étudiant inscrit ROBINHO BAPTISTE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "ROBINHO",
    "prenom": "BAPTISTE",
    "dateDeNaissance": "2001-01-12",
    "sexe": "m",
    "lieuDeNaissance": "99139"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "ROBINHO",
    "prenom": "BAPTISTE",
    "dateNaissance": "2001-01-12",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-06-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=ROBINHO' -d 'prenom=BAPTISTE' -d 'dateDeNaissance=2001-01-12' -d 'sexe=m' -d 'lieuDeNaissance=99139' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_ronaldo_marie_davida.yml](civility_etudiant_inscrit_ronaldo_marie_davida.yml)

  Status `200`

  Étudiant inscrit Ronaldo Marie Davida

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Ronaldo",
    "prenom": "Marie Davida",
    "dateDeNaissance": "2001-05-16",
    "sexe": "f",
    "lieuDeNaissance": "75111"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Ronaldo",
    "prenom": "Marie Davida",
    "dateNaissance": "2001-05-16",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Ronaldo' -d 'prenom=Marie+Davida' -d 'dateDeNaissance=2001-05-16' -d 'sexe=f' -d 'lieuDeNaissance=75111' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_etudiant_inscrit_sales_lisa.yml](civility_etudiant_inscrit_sales_lisa.yml)

  Status `200`

  Étudiant inscrit Sales Lisa

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Sales",
    "prenom": "Lisa",
    "dateDeNaissance": "2000-02-12",
    "sexe": "f",
    "lieuDeNaissance": "97120"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Sales",
    "prenom": "Lisa",
    "dateNaissance": "2000-02-12",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Sales' -d 'prenom=Lisa' -d 'dateDeNaissance=2000-02-12' -d 'sexe=f' -d 'lieuDeNaissance=97120' \
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
    "ine": "1234567890Y",
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
* [civility_etudiant_inscrit_zidane_hamid.yml](civility_etudiant_inscrit_zidane_hamid.yml)

  Status `200`

  Étudiant inscrit Zidane Hamid

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Zidane",
    "prenom": "Hamid",
    "dateDeNaissance": "2005-12-13",
    "sexe": "m",
    "lieuDeNaissance": "97206"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Zidane",
    "prenom": "Hamid",
    "dateNaissance": "2005-12-13",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-10-01",
        "dateFinInscription": "2026-07-30",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
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
    -G -d 'nom=Zidane' -d 'prenom=Hamid' -d 'dateDeNaissance=2005-12-13' -d 'sexe=m' -d 'lieuDeNaissance=97206' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_formation_continue_autorbb_david.yml](civility_formation_continue_autorbb_david.yml)

  Status `200`

  Étudiant formation continue AUTORBB DAVID

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "AUTORBB",
    "prenom": "DAVID",
    "dateDeNaissance": "2001-02-05",
    "sexe": "m",
    "lieuDeNaissance": "99241"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "AUTORBB",
    "prenom": "DAVID",
    "dateNaissance": "2001-02-05",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-12-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=AUTORBB' -d 'prenom=DAVID' -d 'dateDeNaissance=2001-02-05' -d 'sexe=m' -d 'lieuDeNaissance=99241' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/etudiants"
  ```

  </p>
  </details>
* [civility_formation_continue_capeta_ana.yml](civility_formation_continue_capeta_ana.yml)

  Status `200`

  Étudiant formation continue Capeta Ana

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Capeta",
    "prenom": "Ana",
    "dateDeNaissance": "2001-05-30",
    "sexe": "f",
    "lieuDeNaissance": "99208"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "ine": "1234567890Y",
    "nomFamille": "Capeta",
    "prenom": "Ana",
    "dateNaissance": "2001-05-30",
    "inscriptions": [
      {
        "dateDebutInscription": "2025-09-01",
        "dateFinInscription": "2026-12-31",
        "statut": "inscrit",
        "codeCommune": "75009",
        "etablissement": {
          "uai": "0331023W",
          "nomEtablissement": "Université Paris Nanterre"
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
    -G -d 'nom=Capeta' -d 'prenom=Ana' -d 'dateDeNaissance=2001-05-30' -d 'sexe=f' -d 'lieuDeNaissance=99208' \
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
    "ine": "1234567890Y",
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
