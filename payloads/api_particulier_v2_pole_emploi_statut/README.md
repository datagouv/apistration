# Statut demandeur d'emploi
* [200.yaml](200.yaml)

  Status `200`

  Personne insrite

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "default"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "default",
    "civilite": "M.",
    "nom": "DUPONT",
    "nomUsage": null,
    "prenom": "JEAN",
    "sexe": "Masculin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "jean.dupont@france.fr",
    "telephone": "0636656565",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "75107",
      "codePostal": "75007",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "DUPONT",
      "ligneVoie": "42 RUE DE LA PAIX",
      "localite": "75001 PARIS"
    },
    "dateNaissance": "1990-01-01",
    "dateInscription": "2020-01-01",
    "dateCessationInscription": null,
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=default' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Personne non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "not_found"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "not_found",
    "reason": "Situation not found",
    "message": "Aucune situation Pôle Emploi n'a pu être trouvée avec les critères de recherche fournis"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=not_found' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
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
    "identifiant": "internal_error"
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
    -G -d 'identifiant=internal_error' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
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
    "identifiant": "timeout"
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
    -G -d 'identifiant=timeout' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [id_123456A_inscrit_toulouse.yaml](id_123456A_inscrit_toulouse.yaml)

  Status `200`

  Identifiant 123456A, inscrite, toulouse

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "123456A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "123456A",
    "civilite": "MME",
    "nom": "Courtet",
    "nomUsage": null,
    "prenom": "Martine",
    "sexe": "Féminin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "martine.courtet@fake.fr",
    "telephone": "0601020304",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "31555",
      "codePostal": "31400",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "Courtet",
      "ligneVoie": "11 Rue Capus",
      "localite": "31400 TOULOUSE"
    },
    "dateNaissance": "1990-01-06",
    "dateInscription": "2024-01-01",
    "dateCessationInscription": null,
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=123456A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [id_123457A_inscrit_toulouse_2025.yaml](id_123457A_inscrit_toulouse_2025.yaml)

  Status `200`

  Identifiant 123457A, inscrite, toulouse 2025

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "1234567"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "123457A",
    "civilite": "M.",
    "nom": "Desnoyer",
    "nomUsage": null,
    "prenom": "Daniel",
    "sexe": "Masculin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "daniel.desnoyers@fake.fr",
    "telephone": "0601020304",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "31555",
      "codePostal": "31400",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "Courtet",
      "ligneVoie": "11 Rue Capus",
      "localite": "31400 TOULOUSE"
    },
    "dateNaissance": "1989-01-18",
    "dateInscription": "2025-09-01",
    "dateCessationInscription": null,
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=1234567' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [id_123458A_inscrit_toulouse_2025.yaml](id_123458A_inscrit_toulouse_2025.yaml)

  Status `200`

  Identifiant 123458A, inscrite, toulouse, 2025

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "123458A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "123458A",
    "civilite": "MME",
    "nom": "Gallois",
    "nomUsage": null,
    "prenom": "Anais",
    "sexe": "Féminin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "anais.gallois@fake.fr",
    "telephone": "0601020304",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "31555",
      "codePostal": "31400",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "Courtet",
      "ligneVoie": "11 Rue Capus",
      "localite": "31400 TOULOUSE"
    },
    "dateNaissance": "1989-01-18",
    "dateInscription": "2025-09-01",
    "dateCessationInscription": null,
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=123458A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [id_123459A_inscrit_toulouse_2025.yaml](id_123459A_inscrit_toulouse_2025.yaml)

  Status `200`

  Identifiant 123459A, inscrite, toulouse, 2025

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "123459A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "123459A",
    "civilite": "M.",
    "nom": "Genest",
    "nomUsage": null,
    "prenom": "Ludovic",
    "sexe": "Féminin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "ludovic.genest@fake.fr",
    "telephone": "0601020304",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "31555",
      "codePostal": "31400",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "Courtet",
      "ligneVoie": "11 Rue Capus",
      "localite": "31400 TOULOUSE"
    },
    "dateNaissance": "1992-08-15",
    "dateInscription": "2025-09-01",
    "dateCessationInscription": null,
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=123459A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [id_123460A_inscrit_toulouse_2025.yaml](id_123460A_inscrit_toulouse_2025.yaml)

  Status `200`

  Identifiant 123460A, inscrite, toulouse, 2025

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "123460A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "123460A",
    "civilite": "MME",
    "nom": "Vega",
    "nomUsage": null,
    "prenom": "Tiphaine",
    "sexe": "Féminin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "tifaine.vega@fake.fr",
    "telephone": "0601020304",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "31555",
      "codePostal": "31400",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "Courtet",
      "ligneVoie": "11 Rue Capus",
      "localite": "31400 TOULOUSE"
    },
    "dateNaissance": "1992-08-15",
    "dateInscription": "2025-09-01",
    "dateCessationInscription": null,
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=123460A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [id_123461A_desinscrit_toulouse_2025.yaml](id_123461A_desinscrit_toulouse_2025.yaml)

  Status `200`

  Identifiant 123461A, desinscrit, toulouse, 2025

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "123461A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "123461A",
    "civilite": "M.",
    "nom": "Mallette",
    "nomUsage": null,
    "prenom": "Alex",
    "sexe": "Féminin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "alex.mallette@fake.fr",
    "telephone": "0601020304",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "31555",
      "codePostal": "31400",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "Courtet",
      "ligneVoie": "11 Rue Capus",
      "localite": "31400 TOULOUSE"
    },
    "dateNaissance": "1992-08-15",
    "dateInscription": "2024-09-01",
    "dateCessationInscription": "2025-09-01",
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=123461A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
* [id_123462A_desinscrit_toulouse_2025.yaml](id_123462A_desinscrit_toulouse_2025.yaml)

  Status `200`

  Identifiant 123462A, desinscrit, toulouse, 2025

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "123462A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "123462A",
    "civilite": "M.",
    "nom": "Fornaro",
    "nomUsage": null,
    "prenom": "Yoann",
    "sexe": "Féminin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "yoann.fornano@fake.fr",
    "telephone": "0601020304",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "31555",
      "codePostal": "31400",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "Courtet",
      "ligneVoie": "11 Rue Capus",
      "localite": "31400 TOULOUSE"
    },
    "dateNaissance": "1992-08-15",
    "dateInscription": "2024-09-01",
    "dateCessationInscription": "2025-09-01",
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=123462A' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
