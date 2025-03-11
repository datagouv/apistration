# [FranceConnect] Quotient familial CAF & MSA
* [404.yaml](404.yaml)

  Status `404`

  Dossier non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "LEFEBVRE",
    "codeCogInseeCommuneNaissance": "00404",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F"
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
        "code": "37003",
        "title": "Dossier allocataire absent CNAV",
        "detail": "Le dossier allocataire n'a pas été trouvé auprès de la CNAV.",
        "source": null,
        "meta": {
          "provider": "CNAV"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_cnaf.yml](fake_france_connect_cnaf.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/cnaf_qfv2.yml).
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Georges"
    ],
    "nomNaissance": "CNAF",
    "nomUsage": "MARTIN",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75002",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "allocataires": [
        {
          "nom_naissance": "CNAF",
          "nom_usage": "MARTIN",
          "prenoms": "GEORGES",
          "date_naissance": "2002-01-01",
          "sexe": "M"
        }
      ],
      "enfants": [
  
      ],
      "adresse": {
        "destinataire": "Monsieur CNAF MARTIN",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
      }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_200_cnaf_1_parent_3_mineurs.yml](france_connect_200_cnaf_1_parent_3_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Pierre"
    ],
    "nomNaissance": "MERCIER",
    "anneeDateNaissance": 1969,
    "moisDateNaissance": 3,
    "jourDateNaissance": 17,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "95277",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "allocataires": [
        {
          "nom_naissance": "MERCIER",
          "nom_usage": "MERCIER",
          "prenoms": "PIERRE",
          "date_naissance": "1969-03-17",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "MERCIER",
          "nom_usage": "MERCIER",
          "prenoms": "PIERRE",
          "date_naissance": "2018-01-10",
          "sexe": "M"
        },
        {
          "nom_naissance": "MERCIER",
          "nom_usage": "MERCIER",
          "prenoms": "ROBERT",
          "date_naissance": "2020-03-15",
          "sexe": "M"
        },
        {
          "nom_naissance": "MERCIER",
          "nom_usage": "MERCIER",
          "prenoms": "HENRY",
          "date_naissance": "2022-06-20",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur MERCIER PIERRE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
      }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_200_cnaf_2_parents_0_enfant.yml](france_connect_200_cnaf_2_parents_0_enfant.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Anne-Laure"
    ],
    "nomNaissance": "HUCHE",
    "anneeDateNaissance": 1945,
    "moisDateNaissance": 9,
    "jourDateNaissance": 30,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "31555",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "allocataires": [
        {
          "nom_naissance": "HUCHE",
          "nom_usage": "MERCIER",
          "prenoms": "ANNE-LAURE",
          "date_naissance": "1945-09-30",
          "sexe": "F"
        },
        {
          "nom_naissance": "MERCIER",
          "nom_usage": "MERCIER",
          "prenoms": "JEAN LOUIS",
          "date_naissance": "1945-10-12",
          "sexe": "M"
        }
      ],
      "enfants": [
  
      ],
      "adresse": {
        "destinataire": "Monsieur MERCIER JEAN",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
      }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_200_cnaf_2_parents_1_mineur_2_majeurs.yml](france_connect_200_cnaf_2_parents_1_mineur_2_majeurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Melissandre",
      "Juliette"
    ],
    "nomNaissance": "TROIS-DUPRE",
    "anneeDateNaissance": 1981,
    "moisDateNaissance": 7,
    "jourDateNaissance": 27,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75107",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "allocataires": [
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "TROIS-DUPRE",
          "prenoms": "MELISSANDRE JULIETTE",
          "anneeDateNaissance": "1981",
          "moisDateNaissance": "07",
          "jourDateNaissance": "27",
          "sexe": "F"
        },
        {
          "nom_naissance": "TROIS-DUPRE",
          "nom_usage": "TROIS-DUPRE",
          "prenoms": "PAUL",
          "date_naissance": "1963-10-12",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "TROIS-DUPRE",
          "nom_usage": "TROIS-DUPRE",
          "prenoms": "PIERRE",
          "date_naissance": "2004-01-10",
          "sexe": "M"
        },
        {
          "nom_naissance": "TROIS-DUPRE",
          "nom_usage": "TROIS-DUPRE",
          "prenoms": "LOU",
          "date_naissance": "2015-03-15",
          "sexe": "F"
        },
        {
          "nom_naissance": "TROIS-DUPRE",
          "nom_usage": "TROIS-DUPRE",
          "prenoms": "HENRY",
          "date_naissance": "2022-06-20",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur TROIS-DUPRE PAUL",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
      }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_200_cnaf_2_parents_3_mineurs.yml](france_connect_200_cnaf_2_parents_3_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Paul",
      "Louis"
    ],
    "nomNaissance": "DUPONT",
    "anneeDateNaissance": 1962,
    "moisDateNaissance": 8,
    "jourDateNaissance": 24,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75107",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "allocataires": [
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "PAUL LOUIS",
          "anneeDateNaissance": "1962",
          "moisDateNaissance": "08",
          "jourDateNaissance": "24",
          "sexe": "M"
        },
        {
          "nom_naissance": "DURAND",
          "nom_usage": "DUBOIS",
          "prenoms": "ANGELA LOUISE",
          "date_naissance": "1963-10-12",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "PIERRE",
          "date_naissance": "2018-01-10",
          "sexe": "M"
        },
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "ROBERT",
          "date_naissance": "2020-03-15",
          "sexe": "M"
        },
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "HENRY",
          "date_naissance": "2022-06-20",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur DUPONT PAUL",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
      }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_cnaf.yml](france_connect_cnaf.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

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
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "allocataires": [
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "ANGELA",
          "date_naissance": "1962-08-24",
          "sexe": "F"
        }
      ],
      "enfants": [
  
      ],
      "adresse": {
        "destinataire": "Madame DUBOIS ANGELA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
      }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
