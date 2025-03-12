# [Identité] Statut étudiant
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'ine=1234567404G' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "MELINARD",
    "prenom": "PATRICK",
    "anneeDateNaissance": 1990,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "78000"
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
        "nom_naissance": "MELINARD",
        "prenom": "PATRICK",
        "date_naissance": "1990-01-01"
      },
      "admissions": [
        {
          "date_debut": "2023-07-01",
          "date_fin": "2024-08-31",
          "est_inscrit": false,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
            "nom": "Université Paris Saclay"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MELINARD' -d 'prenom=PATRICK' -d 'anneeDateNaissance=1990' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78000' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Avérone",
    "prenom": "Denis",
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 8,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "78646"
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
        "nom_naissance": "Avérone",
        "prenom": "Denis",
        "date_naissance": "2005-08-01"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-07-31",
          "est_inscrit": false,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "93430",
          "etablissement_etudes": {
            "uai": "0331023W",
            "nom": "Université Sorbonne Paris Nord"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Av%C3%A9rone' -d 'prenom=Denis' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=8' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
  ```

  </p>
  </details>
* [civility_etudiant_formation_continue.yml](civility_etudiant_formation_continue.yml)

  Status `200`

  Étudiant inscrit formation continue

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "SOULI",
    "prenom": "Walid",
    "anneeDateNaissance": 1998,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "78000"
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
        "nom_naissance": "SOULI",
        "prenom": "Walid",
        "date_naissance": "1998-01-01"
      },
      "admissions": [
        {
          "date_debut": "2023-07-01",
          "date_fin": "2024-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation continue",
            "code": "RF5"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
            "nom": "Université Paris Saclay"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SOULI' -d 'prenom=Walid' -d 'anneeDateNaissance=1998' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78000' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "CALIDONE",
    "prenom": "Lola",
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75109"
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
        "nom_naissance": "CALIDONE",
        "prenom": "Lola",
        "date_naissance": "2005-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-07-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "92000",
          "etablissement_etudes": {
            "uai": "0334523W",
            "nom": "Université Paris Nanterre"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=CALIDONE' -d 'prenom=Lola' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "MARTIN",
    "prenom": "Jacques",
    "anneeDateNaissance": 2004,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75102"
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
        "nom_naissance": "Martin",
        "prenom": "Jacques",
        "date_naissance": "2004-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-10-01",
          "date_fin": "2025-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "92000",
          "etablissement_etudes": {
            "uai": "0330023W",
            "nom": "Université Paris Nanterre"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTIN' -d 'prenom=Jacques' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75102' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "SOULI",
    "prenom": "Asma",
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
      "identite": {
        "nom_naissance": "SOULI",
        "prenom": "Asma",
        "date_naissance": "2002-01-01"
      },
      "admissions": [
        {
          "date_debut": "2022-07-01",
          "date_fin": "2023-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
            "nom": "Université Paris Saclay"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SOULI' -d 'prenom=Asma' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75002' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "BRETAGNE",
    "prenom": "Lisa",
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 6,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "93008"
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
        "nom_naissance": "BRETAGNE",
        "prenom": "Lisa",
        "date_naissance": "2005-06-01"
      },
      "admissions": [
        {
          "date_debut": "2023-09-01",
          "date_fin": "2024-07-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "93430",
          "etablissement_etudes": {
            "uai": "0331023W",
            "nom": " Université Sorbonne Paris Nord"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BRETAGNE' -d 'prenom=Lisa' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=6' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=93008' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "JUIN",
    "prenom": "Romuald",
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 6,
    "jourDateNaissance": 15,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75115"
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
        "nom_naissance": "Juin",
        "prenom": "Romuald",
        "date_naissance": "2005-06-15"
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
          "code_cog_insee_commune": "92000",
          "etablissement_etudes": {
            "uai": "0330023W",
            "nom": "Université Paris Nanterre"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=JUIN' -d 'prenom=Romuald' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75115' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "AUVERNE",
    "prenom": "Luc",
    "anneeDateNaissance": 2006,
    "moisDateNaissance": 2,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "95018"
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
        "nom_naissance": "AUVERNE",
        "prenom": "Luc",
        "date_naissance": "2006-02-01"
      },
      "admissions": [
        {
          "date_debut": "2025-01-01",
          "date_fin": "2025-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "78000",
          "etablissement_etudes": {
            "uai": "0331034W",
            "nom": " Université de Versailles"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=AUVERNE' -d 'prenom=Luc' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=2' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=95018' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "JUIN",
    "prenom": "Esmeralda",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 12,
    "jourDateNaissance": 24,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75113"
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
        "nom_naissance": "Juin",
        "prenom": "Esmeralda",
        "date_naissance": "2000-12-24"
      },
      "admissions": [
        {
          "date_debut": "2024-10-01",
          "date_fin": "2025-08-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "92000",
          "etablissement_etudes": {
            "uai": "0330023W",
            "nom": "Université Paris Nanterre"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=JUIN' -d 'prenom=Esmeralda' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=24' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75113' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "BECKER",
    "prenom": "VALIRIANNE",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75109"
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
        "nom_naissance": "BECKER",
        "prenom": "VALIRIANNE",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-01-01",
          "date_fin": "2025-11-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75006",
          "etablissement_etudes": {
            "uai": "0292973W",
            "nom": "Université Paris Cité"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BECKER' -d 'prenom=VALIRIANNE' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "CLERMONT",
    "prenom": "Louis",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "78646"
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
        "nom_naissance": "CLERMONT",
        "prenom": "Louis",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-10-01",
          "date_fin": "2025-09-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "78100",
          "etablissement_etudes": {
            "uai": "0309023W",
            "nom": " Sciences Po"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=CLERMONT' -d 'prenom=Louis' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "IBARRA",
    "prenom": "JENNYFER",
    "anneeDateNaissance": 2004,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75109"
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
        "nom_naissance": "IBARRA",
        "prenom": "JENNYFER",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2025-01-01",
          "date_fin": "2025-12-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0361113W",
            "nom": "ESCG"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=IBARRA' -d 'prenom=JENNYFER' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "IZAK",
    "prenom": "John",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75109"
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
        "nom_naissance": "IZAK",
        "prenom": "John",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-07-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331313W",
            "nom": "ESCG"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=IZAK' -d 'prenom=John' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "LETERIEN",
    "prenom": "Clémentine",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99404"
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
        "nom_naissance": "LETERIEN",
        "prenom": "Clémentine",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-01-01",
          "date_fin": "2025-11-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75006",
          "etablissement_etudes": {
            "uai": "0292973W",
            "nom": "Université Paris Cité"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LETERIEN' -d 'prenom=Cl%C3%A9mentine' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99404' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "DE JEAN",
    "prenom": "LUC",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99352"
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
        "nom_naissance": "DE JEAN",
        "prenom": "LUC",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-01-01",
          "date_fin": "2025-11-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75006",
          "etablissement_etudes": {
            "uai": "0292973W",
            "nom": "Université Paris Cité"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DE+JEAN' -d 'prenom=LUC' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99352' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "MAYVILLE",
    "prenom": "TINA",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75109"
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
        "nom_naissance": "MAYVILLE",
        "prenom": "Tina",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-07-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0366313W",
            "nom": "ESCG"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MAYVILLE' -d 'prenom=TINA' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "MEDIZ",
    "prenom": "Louis",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75109"
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
        "nom_naissance": "MEDIZ",
        "prenom": "Louis",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-07-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75006",
          "etablissement_etudes": {
            "uai": "0292613W",
            "nom": "Université Paris Cité"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MEDIZ' -d 'prenom=Louis' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "MONT-PARRAIN",
    "prenom": "Lisa",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99109"
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
        "nom_naissance": "MONT-PARRAIN",
        "prenom": "Lisa",
        "date_naissance": "2000-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-01-01",
          "date_fin": "2025-11-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75006",
          "etablissement_etudes": {
            "uai": "0292973W",
            "nom": "Université Paris Cité"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MONT-PARRAIN' -d 'prenom=Lisa' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "YOLAN",
    "prenom": "JOHN",
    "anneeDateNaissance": 2007,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75109"
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
        "nom_naissance": "YOLAN",
        "prenom": "JOHN",
        "date_naissance": "2007-01-01"
      },
      "admissions": [
        {
          "date_debut": "2024-10-01",
          "date_fin": "2025-09-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0320613W",
            "nom": "ESCG"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=YOLAN' -d 'prenom=JOHN' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "COLONEL",
    "prenom": "Jean",
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 8,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "78646"
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
        "nom_naissance": "COLONEL",
        "prenom": "Jean",
        "date_naissance": "2005-08-01"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-07-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation continue",
            "code": "RF5"
          },
          "code_cog_insee_commune": "93430",
          "etablissement_etudes": {
            "uai": "0331023W",
            "nom": " Université Sorbonne Paris Nord"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=COLONEL' -d 'prenom=Jean' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=8' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
  ```

  </p>
  </details>
