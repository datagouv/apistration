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
    "prenoms": [
      "PATRICK"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MELINARD' -d 'prenoms[]=PATRICK' -d 'anneeDateNaissance=1990' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78000' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "AUTORBB",
    "prenoms": [
      "LANCE"
    ],
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 2,
    "jourDateNaissance": 5,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99138"
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
        "nom_naissance": "AUTORBB",
        "prenom": "LANCE",
        "date_naissance": "2005-02-05"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-12-31",
          "est_inscrit": false,
          "regime_formation": {
            "libelle": "formation continue",
            "code": "RF5"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=AUTORBB' -d 'prenoms[]=LANCE' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=2' -d 'jourDateNaissance=5' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99138' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "AUTORBB",
    "prenoms": [
      "PIERRE"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 2,
    "jourDateNaissance": 5,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99424"
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
        "nom_naissance": "AUTORBB",
        "prenom": "PIERRE",
        "date_naissance": "2001-02-05"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-12-31",
          "est_inscrit": false,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=AUTORBB' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=2' -d 'jourDateNaissance=5' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99424' \
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
    "prenoms": [
      "Denis"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Av%C3%A9rone' -d 'prenoms[]=Denis' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=8' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Figo",
    "prenoms": [
      "Luis"
    ],
    "anneeDateNaissance": 2003,
    "moisDateNaissance": 6,
    "jourDateNaissance": 27,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "59350"
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
        "nom_naissance": "Figo",
        "prenom": "Luis",
        "date_naissance": "2003-06-27"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-12-31",
          "est_inscrit": false,
          "regime_formation": {
            "libelle": "formation continue",
            "code": "RF5"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Figo' -d 'prenoms[]=Luis' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=6' -d 'jourDateNaissance=27' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=59350' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Nani",
    "prenoms": [
      "Luis"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 4,
    "jourDateNaissance": 25,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99331"
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
        "nom_naissance": "Nani",
        "prenom": "Luis",
        "date_naissance": "2002-04-25"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-12-31",
          "est_inscrit": false,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Nani' -d 'prenoms[]=Luis' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=4' -d 'jourDateNaissance=25' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99331' \
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
    "prenoms": [
      "Walid"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SOULI' -d 'prenoms[]=Walid' -d 'anneeDateNaissance=1998' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78000' \
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
    "prenoms": [
      "Lola"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=CALIDONE' -d 'prenoms[]=Lola' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
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
    "prenoms": [
      "Jacques"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTIN' -d 'prenoms[]=Jacques' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75102' \
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
    "prenoms": [
      "Asma"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SOULI' -d 'prenoms[]=Asma' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75002' \
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
    "prenoms": [
      "Lisa"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BRETAGNE' -d 'prenoms[]=Lisa' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=6' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=93008' \
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
    "prenoms": [
      "Romuald"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=JUIN' -d 'prenoms[]=Romuald' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75115' \
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
    "prenoms": [
      "Luc"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=AUVERNE' -d 'prenoms[]=Luc' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=2' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=95018' \
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
    "prenoms": [
      "Esmeralda"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=JUIN' -d 'prenoms[]=Esmeralda' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=24' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75113' \
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
    "prenoms": [
      "VALIRIANNE"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BECKER' -d 'prenoms[]=VALIRIANNE' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Bispo-Antoinette",
    "prenoms": [
      "Hanan"
    ],
    "anneeDateNaissance": 1999,
    "moisDateNaissance": 12,
    "jourDateNaissance": 24,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "93010"
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
        "nom_naissance": "Bispo-Antoinette",
        "prenom": "Hanan",
        "date_naissance": "1999-12-24"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bispo-Antoinette' -d 'prenoms[]=Hanan' -d 'anneeDateNaissance=1999' -d 'moisDateNaissance=12' -d 'jourDateNaissance=24' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=93010' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "blobla",
    "prenoms": [
      "Lina"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 7,
    "jourDateNaissance": 25,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "67482"
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
        "nom_naissance": "blobla",
        "prenom": "Lina",
        "date_naissance": "2002-07-25"
      },
      "admissions": [
        {
          "date_debut": "2027-01-01",
          "date_fin": "2027-12-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=blobla' -d 'prenoms[]=Lina' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=7' -d 'jourDateNaissance=25' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=67482' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Bob",
    "prenoms": [
      "Nassima"
    ],
    "anneeDateNaissance": 2004,
    "moisDateNaissance": 12,
    "jourDateNaissance": 4,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99335"
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
        "nom_naissance": "Bob",
        "prenom": "Nassima",
        "date_naissance": "2004-12-04"
      },
      "admissions": [
        {
          "date_debut": "2024-09-01",
          "date_fin": "2025-09-01",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bob' -d 'prenoms[]=Nassima' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=12' -d 'jourDateNaissance=4' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99335' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Caravelle",
    "prenoms": [
      "Marc-Antoine"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 4,
    "jourDateNaissance": 15,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75110"
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
        "nom_naissance": "Caravelle",
        "prenom": "Marc-Antoine",
        "date_naissance": "2002-04-15"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Caravelle' -d 'prenoms[]=Marc-Antoine' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=4' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75110' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Carey",
    "prenoms": [
      "Abdelhay"
    ],
    "anneeDateNaissance": 2003,
    "moisDateNaissance": 7,
    "jourDateNaissance": 11,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "77373"
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
        "nom_naissance": "Carey",
        "prenom": "Abdelhay",
        "date_naissance": "2003-07-11"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Carey' -d 'prenoms[]=Abdelhay' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=7' -d 'jourDateNaissance=11' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=77373' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Chateau",
    "prenoms": [
      "Elyes"
    ],
    "anneeDateNaissance": 2006,
    "moisDateNaissance": 7,
    "jourDateNaissance": 25,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75105"
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
        "nom_naissance": "Chateau",
        "prenom": "Elyes",
        "date_naissance": "2006-07-25"
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
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Chateau' -d 'prenoms[]=Elyes' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=7' -d 'jourDateNaissance=25' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75105' \
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
    "prenoms": [
      "Louis"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=CLERMONT' -d 'prenoms[]=Louis' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "De Carvalho",
    "prenoms": [
      "Alexandra"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 3,
    "jourDateNaissance": 14,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "69123"
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
        "nom_naissance": "De Carvalho",
        "prenom": "Alexandra",
        "date_naissance": "2000-03-14"
      },
      "admissions": [
        {
          "date_debut": "2025-11-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=De+Carvalho' -d 'prenoms[]=Alexandra' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=3' -d 'jourDateNaissance=14' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=69123' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Delin",
    "prenoms": [
      "Antoine"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 12,
    "jourDateNaissance": 3,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99139"
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
        "nom_naissance": "Delin",
        "prenom": "Antoine",
        "date_naissance": "2000-12-03"
      },
      "admissions": [
        {
          "date_debut": "2026-12-31",
          "date_fin": "2027-06-12",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Delin' -d 'prenoms[]=Antoine' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=3' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99139' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Duper",
    "prenoms": [
      "Louise"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99208"
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
        "nom_naissance": "Duper",
        "prenom": "Louise",
        "date_naissance": "2001-01-10"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Duper' -d 'prenoms[]=Louise' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99208' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Dupont",
    "prenoms": [
      "Nouhe"
    ],
    "anneeDateNaissance": 2007,
    "moisDateNaissance": 12,
    "jourDateNaissance": 9,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "92073"
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
        "prenom": "Nouhe",
        "date_naissance": "2007-12-09"
      },
      "admissions": [
        {
          "date_debut": "2025-12-01",
          "date_fin": "2026-12-10",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupont' -d 'prenoms[]=Nouhe' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=12' -d 'jourDateNaissance=9' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=92073' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Dupré",
    "prenoms": [
      "Hind"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 12,
    "jourDateNaissance": 8,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99138"
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
        "nom_naissance": "Dupré",
        "prenom": "Hind",
        "date_naissance": "2000-12-08"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupr%C3%A9' -d 'prenoms[]=Hind' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=8' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99138' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Garuba",
    "prenoms": [
      "Feryel"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 11,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99331"
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
        "nom_naissance": "Garuba",
        "prenom": "Feryel",
        "date_naissance": "2001-01-11"
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
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Garuba' -d 'prenoms[]=Feryel' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=11' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99331' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Hamilton",
    "prenoms": [
      "Nicole"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 7,
    "jourDateNaissance": 18,
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
        "nom_naissance": "Hamilton",
        "prenom": "Nicole",
        "date_naissance": "2002-07-18"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Hamilton' -d 'prenoms[]=Nicole' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=7' -d 'jourDateNaissance=18' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75113' \
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
    "prenoms": [
      "JENNYFER"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=IBARRA' -d 'prenoms[]=JENNYFER' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
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
    "prenoms": [
      "John"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=IZAK' -d 'prenoms[]=John' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Lenovo",
    "prenoms": [
      "Charles"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "67482"
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
        "nom_naissance": "Lenovo",
        "prenom": "Charles",
        "date_naissance": "2001-01-10"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lenovo' -d 'prenoms[]=Charles' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=67482' \
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
    "prenoms": [
      "Clémentine"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LETERIEN' -d 'prenoms[]=Cl%C3%A9mentine' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99404' \
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
    "prenoms": [
      "LUC"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DE+JEAN' -d 'prenoms[]=LUC' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99352' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Lunette",
    "prenoms": [
      "Zahid"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 12,
    "jourDateNaissance": 7,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99241"
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
        "nom_naissance": "Lunette",
        "prenom": "Zahid",
        "date_naissance": "2000-12-07"
      },
      "admissions": [
        {
          "date_debut": "2026-12-01",
          "date_fin": "2027-03-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lunette' -d 'prenoms[]=Zahid' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=7' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99241' \
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
    "prenoms": [
      "TINA"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MAYVILLE' -d 'prenoms[]=TINA' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
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
    "prenoms": [
      "Louis"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MEDIZ' -d 'prenoms[]=Louis' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75109' \
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
    "prenoms": [
      "Lisa"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MONT-PARRAIN' -d 'prenoms[]=Lisa' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Nom",
    "prenoms": [
      "Narjes"
    ],
    "anneeDateNaissance": 2006,
    "moisDateNaissance": 1,
    "jourDateNaissance": 6,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99424"
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
        "nom_naissance": "Nom",
        "prenom": "Narjes",
        "date_naissance": "2006-01-06"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-12-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Nom' -d 'prenoms[]=Narjes' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=1' -d 'jourDateNaissance=6' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99424' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Pereira",
    "prenoms": [
      "Maoris"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 8,
    "jourDateNaissance": 5,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99131"
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
        "nom_naissance": "Pereira",
        "prenom": "Maoris",
        "date_naissance": "2002-08-05"
      },
      "admissions": [
        {
          "date_debut": "2024-10-10",
          "date_fin": "2025-10-10",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Pereira' -d 'prenoms[]=Maoris' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=8' -d 'jourDateNaissance=5' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99131' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RAMSON",
    "prenoms": [
      "ASSYA"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 3,
    "jourDateNaissance": 12,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75112"
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
        "nom_naissance": "RAMSON",
        "prenom": "ASSYA",
        "date_naissance": "2001-03-12"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RAMSON' -d 'prenoms[]=ASSYA' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=3' -d 'jourDateNaissance=12' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75112' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Randri",
    "prenoms": [
      "Ishan"
    ],
    "anneeDateNaissance": 2003,
    "moisDateNaissance": 6,
    "jourDateNaissance": 17,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75112"
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
        "nom_naissance": "Randri",
        "prenom": "Ishan",
        "date_naissance": "2003-06-17"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Randri' -d 'prenoms[]=Ishan' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=6' -d 'jourDateNaissance=17' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75112' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "ARNAUD"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "97206"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "ARNAUD",
        "date_naissance": "2001-01-10"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=ARNAUD' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=97206' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "AUDE"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "92073"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "AUDE",
        "date_naissance": "2001-01-10"
      },
      "admissions": [
        {
          "date_debut": "2027-01-01",
          "date_fin": "2027-12-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=AUDE' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=92073' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "CORENTIN"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "97120"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "CORENTIN",
        "date_naissance": "2001-01-10"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=CORENTIN' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=97120' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "ELISE"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75105"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "ELISE",
        "date_naissance": "2001-01-10"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=ELISE' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75105' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "FLAVIEN"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 15,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75110"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "FLAVIEN",
        "date_naissance": "2001-01-15"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=FLAVIEN' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75110' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "ISABELLE"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 13,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "69123"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "ISABELLE",
        "date_naissance": "2001-01-13"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=ISABELLE' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=13' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=69123' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "NATHANAEL"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75111"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "NATHANAEL",
        "date_naissance": "2000-01-01"
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
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=NATHANAEL' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75111' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "NOLAN"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 6,
    "jourDateNaissance": 11,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "93010"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "NOLAN",
        "date_naissance": "2001-06-11"
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
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=NOLAN' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=6' -d 'jourDateNaissance=11' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=93010' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "PAUL"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 9,
    "jourDateNaissance": 20,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "93010"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "PAUL",
        "date_naissance": "2000-09-20"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=PAUL' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=9' -d 'jourDateNaissance=20' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=93010' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "PAULINE"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 20,
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "PAULINE",
        "date_naissance": "2001-01-20"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=PAULINE' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75113' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "RLUHDEFKWR",
    "prenoms": [
      "TERRENCE"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "59350"
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
        "nom_naissance": "RLUHDEFKWR",
        "prenom": "TERRENCE",
        "date_naissance": "2001-01-10"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RLUHDEFKWR' -d 'prenoms[]=TERRENCE' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=59350' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "ROBINHO",
    "prenoms": [
      "BAPTISTE"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 1,
    "jourDateNaissance": 12,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99139"
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
        "nom_naissance": "ROBINHO",
        "prenom": "BAPTISTE",
        "date_naissance": "2001-01-12"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-06-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ROBINHO' -d 'prenoms[]=BAPTISTE' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=1' -d 'jourDateNaissance=12' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99139' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Ronaldo",
    "prenoms": [
      "Marie Davida"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 5,
    "jourDateNaissance": 16,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75111"
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
        "nom_naissance": "Ronaldo",
        "prenom": "Marie Davida",
        "date_naissance": "2001-05-16"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Ronaldo' -d 'prenoms[]=Marie+Davida' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=5' -d 'jourDateNaissance=16' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75111' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Sales",
    "prenoms": [
      "Lisa"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 2,
    "jourDateNaissance": 12,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "97120"
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
        "nom_naissance": "Sales",
        "prenom": "Lisa",
        "date_naissance": "2000-02-12"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Sales' -d 'prenoms[]=Lisa' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=2' -d 'jourDateNaissance=12' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=97120' \
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
    "prenoms": [
      "JOHN"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=YOLAN' -d 'prenoms[]=JOHN' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75109' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Zidane",
    "prenoms": [
      "Hamid"
    ],
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 12,
    "jourDateNaissance": 13,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "97206"
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
        "nom_naissance": "Zidane",
        "prenom": "Hamid",
        "date_naissance": "2005-12-13"
      },
      "admissions": [
        {
          "date_debut": "2025-10-01",
          "date_fin": "2026-07-30",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation initiale",
            "code": "RF1"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Zidane' -d 'prenoms[]=Hamid' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=12' -d 'jourDateNaissance=13' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=97206' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "AUTORBB",
    "prenoms": [
      "DAVID"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 2,
    "jourDateNaissance": 5,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "99241"
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
        "nom_naissance": "AUTORBB",
        "prenom": "DAVID",
        "date_naissance": "2001-02-05"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-12-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation continue",
            "code": "RF5"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=AUTORBB' -d 'prenoms[]=DAVID' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=2' -d 'jourDateNaissance=5' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=99241' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
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
    "nomNaissance": "Capeta",
    "prenoms": [
      "Ana"
    ],
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 5,
    "jourDateNaissance": 30,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "99208"
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
        "nom_naissance": "Capeta",
        "prenom": "Ana",
        "date_naissance": "2001-05-30"
      },
      "admissions": [
        {
          "date_debut": "2025-09-01",
          "date_fin": "2026-12-31",
          "est_inscrit": true,
          "regime_formation": {
            "libelle": "formation continue",
            "code": "RF5"
          },
          "code_cog_insee_commune": "75009",
          "etablissement_etudes": {
            "uai": "0331023W",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Capeta' -d 'prenoms[]=Ana' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=5' -d 'jourDateNaissance=30' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=99208' \
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
    "prenoms": [
      "Jean"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=COLONEL' -d 'prenoms[]=Jean' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=8' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=78646' \
    --url "https://staging.particulier.api.gouv.fr/v3/mesri/statut_etudiant/identite"
  ```

  </p>
  </details>
