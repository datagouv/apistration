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
    "errors": [
      {
        "code": "25003",
        "title": "Entité non trouvée",
        "detail": "Aucun étudiant n'a pu être trouvé avec les critères de recherche fournis.",
        "source": null,
        "meta": {
          "provider": "MESRI"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567404G' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Dupont",
        "prenom": "Jean",
        "date_naissance": "2002-02-01"
      },
      "admissions": [
        {
          "date_debut": "2020-09-01",
          "date_fin": "2021-06-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "33199",
          "etablissement_etudes": {
            "uai": "0332870R",
            "nom": "LPO LYCEE DES METIERS DE LA MER"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890A' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "MARTIN",
        "prenom": "Jeanne",
        "date_naissance": "2001-11-10"
      },
      "admissions": [
        {
          "date_debut": "2022-08-01",
          "date_fin": "2023-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75020",
          "etablissement_etudes": {
            "uai": "0750106H",
            "nom": "ECOLE TECHNOLOGIQUE PRIVEE"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=0100007108D' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Petit",
        "prenom": "Thomas",
        "date_naissance": "2000-02-12"
      },
      "admissions": [
        {
          "date_debut": "2019-02-16",
          "date_fin": "2021-05-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75020",
          "etablissement_etudes": {
            "uai": "0750106H",
            "nom": "ECOLE TECHNOLOGIQUE PRIVEE"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=0100008010J' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "DUBOIS",
        "prenom": "Jean",
        "date_naissance": "2003-01-10"
      },
      "admissions": [
        {
          "date_debut": "2020-09-11",
          "date_fin": "2022-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75020",
          "etablissement_etudes": {
            "uai": "0750106H",
            "nom": "ECOLE TECHNOLOGIQUE PRIVEE"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=012345678AA' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Longchambon",
        "prenom": "Thomas",
        "date_naissance": "2001-01-01"
      },
      "admissions": [
        {
          "date_debut": "2022-09-01",
          "date_fin": "2023-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "31555",
          "etablissement_etudes": {
            "uai": "0313124C",
            "nom": "Université Toulouse Capitole"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890B' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Charbonneau",
        "prenom": "Axelle",
        "date_naissance": "2001-01-02"
      },
      "admissions": [
        {
          "date_debut": "2023-09-01",
          "date_fin": "2024-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "31555",
          "etablissement_etudes": {
            "uai": "0313124C",
            "nom": "Université Toulouse Capitole"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890C' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Montgomery",
        "prenom": "Marie",
        "date_naissance": "2001-01-03"
      },
      "admissions": [
        {
          "date_debut": "2023-09-01",
          "date_fin": "2024-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "31555",
          "etablissement_etudes": {
            "uai": "0313124C",
            "nom": "Université Toulouse Capitole"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890D' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Granet",
        "prenom": "Cyril",
        "date_naissance": "2001-01-04"
      },
      "admissions": [
        {
          "date_debut": "2023-09-01",
          "date_fin": "2024-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75020",
          "etablissement_etudes": {
            "uai": "0750106H",
            "nom": "ECOLE TECHNOLOGIQUE PRIVEE"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890E' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Le Tonnelier",
        "prenom": "Pierre-Marie",
        "date_naissance": "2001-01-03"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "31555",
          "etablissement_etudes": {
            "uai": "0313124C",
            "nom": "Université Toulouse Capitole"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=1234567890F' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "KOSAKAMI",
        "prenom": "Korako",
        "date_naissance": "2002-10-13"
      },
      "admissions": [
        {
          "date_debut": "2023-09-01",
          "date_fin": "2024-06-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75020",
          "etablissement_etudes": {
            "uai": "0750106H",
            "nom": "ECOLE TECHNOLOGIQUE PRIVEE"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=655888578AE' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "LEBRETON",
        "prenom": "Arnaud",
        "date_naissance": "1988-09-10"
      },
      "admissions": [
        {
          "date_debut": "2021-09-16",
          "date_fin": "2023-07-25",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75020",
          "etablissement_etudes": {
            "uai": "0750106H",
            "nom": "ECOLE TECHNOLOGIQUE PRIVEE"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=660309901AG' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
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
    "data": {
      "identite": {
        "nom_naissance": "Moreau",
        "prenom": "Aurélie",
        "date_naissance": "2002-01-02"
      },
      "admissions": [
        {
          "date_debut": "2022-09-05",
          "date_fin": "2023-05-29",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75020",
          "etablissement_etudes": {
            "uai": "0750106H",
            "nom": "ECOLE TECHNOLOGIQUE PRIVEE"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'ine=675773666AD' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/ine"
  ```

  </p>
  </details>
