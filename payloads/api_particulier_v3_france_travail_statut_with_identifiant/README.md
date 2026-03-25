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
    "data": {
      "identifiant": "default",
      "identite": {
        "civilite": "M.",
        "nom_naissance": "DUPONT",
        "nom_usage": null,
        "prenom": "JEAN",
        "sexe": "Masculin",
        "date_naissance": "1990-01-01"
      },
      "contact": {
        "email": "jean.dupont@france.fr",
        "telephone": "0636656565",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "75107",
        "code_postal": "75007",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "DUPONT",
        "ligne_voie": "42 RUE DE LA PAIX",
        "localite": "75001 PARIS"
      },
      "inscription": {
        "date_debut": "2020-01-01",
        "date_fin": null,
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=default' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "errors": [
      {
        "code": "24003",
        "title": "Entité non trouvée",
        "detail": "Aucune situation France Travail n'a pu être trouvée avec les critères de recherche fournis.",
        "source": null,
        "meta": {
          "provider": "France Travail"
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
    -G -d 'recipient=13002526500013' -d 'identifiant=not_found' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "data": {
      "identifiant": "123456A",
      "identite": {
        "civilite": "MME",
        "nom_naissance": "Courtet",
        "nom_usage": null,
        "prenom": "Martine",
        "sexe": "Féminin",
        "date_naissance": "1990-01-06"
      },
      "contact": {
        "email": "martine.courtet@fake.fr",
        "telephone": "0601020304",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "31555",
        "code_postal": "31400",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "Courtet",
        "ligne_voie": "11 Rue Capus",
        "localite": "31400 TOULOUSE"
      },
      "inscription": {
        "date_debut": "2024-01-01",
        "date_fin": null,
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=123456A' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "identifiant": "123457A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identifiant": "123457A",
      "identite": {
        "civilite": "MME",
        "nom_naissance": "Desnoyer",
        "nom_usage": null,
        "prenom": "Daniel",
        "sexe": "Masculin",
        "date_naissance": "1989-01-18"
      },
      "contact": {
        "email": "daniel.desnoyers@fake.fr",
        "telephone": "0601020304",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "31555",
        "code_postal": "31400",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "Desnoyer",
        "ligne_voie": "11 Rue Capus",
        "localite": "31400 TOULOUSE"
      },
      "inscription": {
        "date_debut": "2025-09-01",
        "date_fin": null,
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=123457A' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "data": {
      "identifiant": "123458A",
      "identite": {
        "civilite": "MME",
        "nom_naissance": "Gallois",
        "nom_usage": null,
        "prenom": "Anais",
        "sexe": "Féminin",
        "date_naissance": "1989-01-18"
      },
      "contact": {
        "email": "anais.gallois@fake.fr",
        "telephone": "0601020304",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "31555",
        "code_postal": "31400",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "Gallois",
        "ligne_voie": "11 Rue Capus",
        "localite": "31400 TOULOUSE"
      },
      "inscription": {
        "date_debut": "2025-09-01",
        "date_fin": null,
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=123458A' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "data": {
      "identifiant": "123459A",
      "identite": {
        "civilite": "M.",
        "nom_naissance": "Genest",
        "nom_usage": null,
        "prenom": "Ludovic",
        "sexe": "Masculin",
        "date_naissance": "1992-08-15"
      },
      "contact": {
        "email": "ludovic.genest@fake.fr",
        "telephone": "0601020304",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "31555",
        "code_postal": "31400",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "Genest",
        "ligne_voie": "11 Rue Capus",
        "localite": "31400 TOULOUSE"
      },
      "inscription": {
        "date_debut": "2025-09-01",
        "date_fin": null,
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=123459A' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "data": {
      "identifiant": "123460A",
      "identite": {
        "civilite": "MME",
        "nom_naissance": "Vega",
        "nom_usage": null,
        "prenom": "Tiphaine",
        "sexe": "Féminin",
        "date_naissance": "1992-08-15"
      },
      "contact": {
        "email": "tifaine.vega@fake.fr",
        "telephone": "0601020304",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "31555",
        "code_postal": "31400",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "Vega",
        "ligne_voie": "11 Rue Capus",
        "localite": "31400 TOULOUSE"
      },
      "inscription": {
        "date_debut": "2025-09-01",
        "date_fin": null,
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=123460A' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "data": {
      "identifiant": "123461A",
      "identite": {
        "civilite": "M.",
        "nom_naissance": "Mallette",
        "nom_usage": null,
        "prenom": "Alex",
        "sexe": "Féminin",
        "date_naissance": "1992-08-15"
      },
      "contact": {
        "email": "alex.mallette@fake.fr",
        "telephone": "0601020304",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "31555",
        "code_postal": "31400",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "Vega",
        "ligne_voie": "11 Rue Capus",
        "localite": "31400 TOULOUSE"
      },
      "inscription": {
        "date_debut": "2024-09-01",
        "date_fin": "2025-09-01",
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=123461A' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
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
    "data": {
      "identifiant": "123462A",
      "identite": {
        "civilite": "M.",
        "nom_naissance": "Fornaro",
        "nom_usage": null,
        "prenom": "Yoann",
        "sexe": "Masculin",
        "date_naissance": "1992-08-15"
      },
      "contact": {
        "email": "yoann.fornano@fake.fr",
        "telephone": "0601020304",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "31555",
        "code_postal": "31400",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "Vega",
        "ligne_voie": "11 Rue Capus",
        "localite": "31400 TOULOUSE"
      },
      "inscription": {
        "date_debut": "2024-09-01",
        "date_fin": "2025-09-01",
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
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
    -G -d 'recipient=13002526500013' -d 'identifiant=123462A' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
  ```

  </p>
  </details>
