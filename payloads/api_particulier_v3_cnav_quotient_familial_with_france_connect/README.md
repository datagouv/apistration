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
      "enfants": [],
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
    "links": {},
    "meta": {}
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
* [fake_france_connect_cnaf_2.yml](fake_france_connect_cnaf_2.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/cnaf_qfv2.yml).
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Thomas"
    ],
    "nomNaissance": "Delatour",
    "nomUsage": "Delamouette",
    "anneeDateNaissance": 1994,
    "moisDateNaissance": 4,
    "jourDateNaissance": 16,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75111",
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
      "enfants": [],
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
    "links": {},
    "meta": {}
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
* [france_connect_200_1_parent_0_enfant_cnaf.yml](france_connect_200_1_parent_0_enfant_cnaf.yml)

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
      "enfants": [],
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
    "links": {},
    "meta": {}
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
    "links": {},
    "meta": {}
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
    "sexeEtatCivil": "F",
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
      "enfants": [],
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
    "links": {},
    "meta": {}
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
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "13012",
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
          "date_naissance": "1981-07-27",
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
    "links": {},
    "meta": {}
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
          "nom_naissance": "DUPONT",
          "nom_usage": "DUPONT",
          "prenoms": "PAUL LOUIS",
          "date_naissance": "1962-08-24",
          "sexe": "M"
        },
        {
          "nom_naissance": "DURAND",
          "nom_usage": "DUPONT",
          "prenoms": "ANGELA LOUISE",
          "date_naissance": "1963-10-12",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "DUPONT",
          "nom_usage": "DUPONT",
          "prenoms": "PIERRE",
          "date_naissance": "2018-01-10",
          "sexe": "M"
        },
        {
          "nom_naissance": "DUPONT",
          "nom_usage": "DUPONT",
          "prenoms": "ROBERT",
          "date_naissance": "2020-03-15",
          "sexe": "M"
        },
        {
          "nom_naissance": "DUPONT",
          "nom_usage": "DUPONT",
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
    "links": {},
    "meta": {}
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
* [france_connect_200_cnaf_2_parents_3_mineurs_1_nom_avec_caracteres_speciaux.yml](france_connect_200_cnaf_2_parents_3_mineurs_1_nom_avec_caracteres_speciaux.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Olivier",
      "Martin"
    ],
    "nomNaissance": "ANO'NYMOS-LONS",
    "anneeDateNaissance": 1980,
    "moisDateNaissance": 5,
    "jourDateNaissance": 24,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "95491",
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
          "nom_naissance": "ANO'NYMOS-LONS",
          "nom_usage": "ANO'NYMOS-LONS",
          "prenoms": "OLIVIER",
          "date_naissance": "1980-05-24",
          "sexe": "M"
        },
        {
          "nom_naissance": "ANO'NYMOS-LONS",
          "nom_usage": "ROUSSEAU",
          "prenoms": "LAURENCE",
          "date_naissance": "1981-06-01",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ANO'NYMOS-LONS",
          "nom_usage": "ANO'NYMOS-LONS",
          "prenoms": "Gabriel",
          "date_naissance": "2010-02-02",
          "sexe": "M"
        },
        {
          "nom_naissance": "ANO'NYMOS-LONS",
          "nom_usage": "ANO'NYMOS-LONS",
          "prenoms": "Jules",
          "date_naissance": "2013-03-03",
          "sexe": "M"
        },
        {
          "nom_naissance": "ANO'NYMOS-LONS",
          "nom_usage": "ANO'NYMOS-LONS",
          "prenoms": "Simon",
          "date_naissance": "2017-12-05",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur et Madame Olivier ANO'NYMOS-LONS",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "9 R DES MONTS DE LA MADELEINE",
        "lieu_dit": null,
        "code_postal_ville": "42300 LONS-LE-SAUNIER",
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
    "links": {},
    "meta": {}
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
* [france_connect_200_cnaf_2_parents_3_mineurs_1_prenom_compose_sans_tiret.yml](france_connect_200_cnaf_2_parents_3_mineurs_1_prenom_compose_sans_tiret.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Emmanuel",
      "Alexandre",
      "Nicolas"
    ],
    "nomNaissance": "DELALALALANDE",
    "anneeDateNaissance": 1991,
    "moisDateNaissance": 1,
    "jourDateNaissance": 7,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75101",
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
          "nom_naissance": "DELALALALANDE",
          "nom_usage": "DELALALALANDE",
          "prenoms": "EMMANUEL ALEXANDRE",
          "date_naissance": "1991-01-07",
          "sexe": "M"
        },
        {
          "nom_naissance": "CARPENTIER",
          "nom_usage": "DELALALALANDE",
          "prenoms": "FLORENCE",
          "date_naissance": "1990-05-30",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "DELALALALANDE",
          "nom_usage": "DELALALALANDE",
          "prenoms": "Alex",
          "date_naissance": "2015-02-15",
          "sexe": "M"
        },
        {
          "nom_naissance": "DELALALALANDE",
          "nom_usage": "DELALALALANDE",
          "prenoms": "Léo",
          "date_naissance": "2017-02-02",
          "sexe": "M"
        },
        {
          "nom_naissance": "DELALALALANDE",
          "nom_usage": "DELALALALANDE",
          "prenoms": "Laura",
          "date_naissance": "2019-12-31",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur et Madame Emmanuel DELALALALANDE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "20 AVENUE DE SEGUR",
        "lieu_dit": null,
        "code_postal_ville": "75107 PARIS",
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
    "links": {},
    "meta": {}
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
* [france_connect_200_cnaf_2_parents_3_mineurs_dont_1_jour_et_mois_inconnus.yml](france_connect_200_cnaf_2_parents_3_mineurs_dont_1_jour_et_mois_inconnus.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Sophie",
      "Suzanne"
    ],
    "nomNaissance": "YOGO",
    "anneeDateNaissance": 1981,
    "moisDateNaissance": 11,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "50528",
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
          "nom_naissance": "YOGO",
          "nom_usage": "BOBO",
          "prenoms": "Sophie Suzanne",
          "date_naissance": "1981-11-01",
          "sexe": "F"
        },
        {
          "nom_naissance": "LALI",
          "nom_usage": "LALI",
          "prenoms": "Mohamed",
          "date_naissance": "1983-05-15",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "LALI",
          "nom_usage": "LALI",
          "prenoms": "Inès",
          "date_naissance": "2010-07-10",
          "sexe": "F"
        },
        {
          "nom_naissance": "LALI",
          "nom_usage": "LALI",
          "prenoms": "Amir",
          "date_naissance": "2012-09-09",
          "sexe": "M"
        },
        {
          "nom_naissance": "LALI",
          "nom_usage": "LALI",
          "prenoms": "Ibrahim",
          "date_naissance": "2020-00-00",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur et Madame Mohamed LALI",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "Cours des 50 Otages",
        "lieu_dit": null,
        "code_postal_ville": "44109 NANTES",
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
    "links": {},
    "meta": {}
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
* [france_connect_200_cnaf_2_parents_4_mineurs_1_majeur.yml](france_connect_200_cnaf_2_parents_4_mineurs_1_majeur.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "FABIEN"
    ],
    "nomNaissance": "PENDERIE",
    "anneeDateNaissance": 1986,
    "moisDateNaissance": 3,
    "jourDateNaissance": 25,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "83028",
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
          "nom_naissance": "PENDERIE",
          "nom_usage": "PENDERIE",
          "prenoms": "FABIEN",
          "date_naissance": "1986-03-25",
          "sexe": "M"
        },
        {
          "nom_naissance": "SUVE",
          "nom_usage": "PENDERIE",
          "prenoms": "LUCIE",
          "date_naissance": "1987-08-08",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "PENDERIE",
          "nom_usage": "PENDERIE",
          "prenoms": "Léo",
          "date_naissance": "2020-01-01",
          "sexe": "M"
        },
        {
          "nom_naissance": "PENDERIE",
          "nom_usage": "PENDERIE",
          "prenoms": "Léa",
          "date_naissance": "2021-07-17",
          "sexe": "F"
        },
        {
          "nom_naissance": "PENDERIE",
          "nom_usage": "PENDERIE",
          "prenoms": "Hugo",
          "date_naissance": "2022-08-08",
          "sexe": "M"
        },
        {
          "nom_naissance": "PENDERIE",
          "nom_usage": "PENDERIE",
          "prenoms": "Bérénice",
          "date_naissance": "2024-10-25",
          "sexe": "F"
        },
        {
          "nom_naissance": "PENDERIE",
          "nom_usage": "PENDERIE",
          "prenoms": "Paul",
          "date_naissance": "2004-11-01",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur Fabien PENDERIE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "20 AVENUE DE SEGUR",
        "lieu_dit": null,
        "code_postal_ville": "75107 PARIS",
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
    "links": {},
    "meta": {}
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
* [france_connect_200_msa_1_parent_1_mineur_2_majeurs.yml](france_connect_200_msa_1_parent_1_mineur_2_majeurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "ELSA"
    ],
    "nomNaissance": "PLACARD",
    "anneeDateNaissance": 1987,
    "moisDateNaissance": 4,
    "jourDateNaissance": 13,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "59226",
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
          "nom_naissance": "PLACARD",
          "nom_usage": "DUBOIS",
          "prenoms": "ELSA",
          "date_naissance": "1987-04-13",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "Alex",
          "date_naissance": "1999-01-01",
          "sexe": "M"
        },
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "Léo",
          "date_naissance": "2000-01-01",
          "sexe": "M"
        },
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": "DUBOIS",
          "prenoms": "Alice",
          "date_naissance": "2024-02-02",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur Elsa DUBOIS",
        "complement_information": "Batiment 2",
        "complement_information_geographique": "Porte 8",
        "numero_libelle_voie": "20 AVENUE DE SEGUR",
        "lieu_dit": "Lieu dit",
        "code_postal_ville": "75107 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "MSA",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_200_msa_2_parents_5_mineurs.yml](france_connect_200_msa_2_parents_5_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "CINDY"
    ],
    "nomNaissance": "COMMODE",
    "anneeDateNaissance": 1980,
    "moisDateNaissance": 6,
    "jourDateNaissance": 27,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "57431",
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
          "nom_naissance": "COMMODE",
          "nom_usage": "LEMAITRE",
          "prenoms": "CINDY",
          "date_naissance": "1980-06-27",
          "sexe": "F"
        },
        {
          "nom_naissance": "LEMAITRE",
          "nom_usage": "LEMAITRE",
          "prenoms": "FRANCK",
          "date_naissance": "1990-12-30",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "LEMAITRE",
          "nom_usage": "LEMAITRE",
          "prenoms": "Gaston",
          "date_naissance": "2021-05-01",
          "sexe": "M"
        },
        {
          "nom_naissance": "LEMAITRE",
          "nom_usage": "LEMAITRE",
          "prenoms": "Henri",
          "date_naissance": "2021-05-01",
          "sexe": "M"
        },
        {
          "nom_naissance": "LEMAITRE",
          "nom_usage": "LEMAITRE",
          "prenoms": "Robert",
          "date_naissance": "2021-05-01",
          "sexe": "M"
        },
        {
          "nom_naissance": "LEMAITRE",
          "nom_usage": "LEMAITRE",
          "prenoms": "Hugo",
          "date_naissance": "2022-04-30",
          "sexe": "M"
        },
        {
          "nom_naissance": "LEMAITRE",
          "nom_usage": "LEMAITRE",
          "prenoms": "Lucie",
          "date_naissance": "2023-10-01",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur Franck LEMAITRE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "20 AVENUE DE SEGUR",
        "lieu_dit": null,
        "code_postal_ville": "75107 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "MSA",
        "valeur": 2550,
        "annee": 2024,
        "mois": 2,
        "annee_calcul": 2024,
        "mois_calcul": 12
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
