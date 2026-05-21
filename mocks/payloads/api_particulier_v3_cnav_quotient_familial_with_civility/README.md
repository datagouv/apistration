# [Identité] Quotient familial CAF & MSA
* [200-QF-150-CNAF.yaml](200-QF-150-CNAF.yaml)

  Status `200`

  ## QF 150

Permet de tester la fourniture d'un quotient familial de 150

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "35238",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "MARTIN",
    "prenoms": [
      "AXELLE"
    ],
    "anneeDateNaissance": 1989,
    "moisDateNaissance": 12,
    "jourDateNaissance": 3
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
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "AXELLE",
          "date_naissance": "1989-12-03",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Madame MARTIN AXELLE LAURENCE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE DE SAINT-MALO",
        "lieu_dit": null,
        "code_postal_ville": "35000 RENNES",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 150,
        "annee": 2026,
        "mois": 4,
        "annee_calcul": 2026,
        "mois_calcul": 4
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=35238' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=MARTIN' -d 'prenoms[]=AXELLE' -d 'anneeDateNaissance=1989' -d 'moisDateNaissance=12' -d 'jourDateNaissance=3' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-QF-CNAF-etranger-pas-de-date-naissance.yaml](200-QF-CNAF-etranger-pas-de-date-naissance.yaml)

  Status `200`

  ## IDENTITÉ CAS ETRANGER

Permet de tester un appel pour une personne née à l'étranger (Italie) sans fourniture de date de naissance

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseePaysNaissance": "99127",
    "sexeEtatCivil": "F",
    "nomNaissance": "LISA",
    "prenoms": [
      "MONA"
    ]
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
          "nom_naissance": "LISA",
          "nom_usage": null,
          "prenoms": "MONA",
          "date_naissance": "1980-01-12",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Madame Mona Lisa",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "Place du musée du Louvres",
        "lieu_dit": null,
        "code_postal_ville": "75001 Paris",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 4270,
        "annee": 2026,
        "mois": 4,
        "annee_calcul": 2026,
        "mois_calcul": 4
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseePaysNaissance=99127' -d 'sexeEtatCivil=F' -d 'nomNaissance=LISA' -d 'prenoms[]=MONA' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-aitali-leyna-4_enfants.yaml](200-aitali-leyna-4_enfants.yaml)

  Status `200`

  ## Famille AITALI avec quatre enfants

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* parent : AITALI Leyna

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13001",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "AITALI",
    "prenoms": [
      "LEYNA"
    ],
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 7,
    "jourDateNaissance": 11
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
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "LEYNA",
          "date_naissance": "2010-07-11",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "RAYANE",
          "date_naissance": "2012-08-12",
          "sexe": "M"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2015-03-19",
          "sexe": "F"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "AMIR",
          "date_naissance": "2017-11-06",
          "sexe": "M"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "LINA",
          "date_naissance": "2020-05-14",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame AITALI LEYNA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "18 AVENUE DE MARSEILLE",
        "lieu_dit": null,
        "code_postal_ville": "13127 VITROLLES",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 810,
        "annee": 2024,
        "mois": 11,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13001' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=AITALI' -d 'prenoms[]=LEYNA' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=7' -d 'jourDateNaissance=11' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-aitali-nadia-5_enfants.yaml](200-aitali-nadia-5_enfants.yaml)

  Status `200`

  ## Famille AITALI avec cinq enfants

Ce cas permet de tester :
* la gestion d'une famille avec cinq enfants
* parent : AITALI Nadia

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13001",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "AITALI",
    "prenoms": [
      "NADIA"
    ],
    "anneeDateNaissance": 1980,
    "moisDateNaissance": 11,
    "jourDateNaissance": 18
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
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "NADIA",
          "date_naissance": "1980-11-18",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "SAMY",
          "date_naissance": "2011-08-28",
          "sexe": "M"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "LEYNA",
          "date_naissance": "2010-07-11",
          "sexe": "F"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "RAYANE",
          "date_naissance": "2012-08-12",
          "sexe": "M"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "SARA",
          "date_naissance": "2016-06-06",
          "sexe": "F"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "MALIK",
          "date_naissance": "2019-09-21",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame AITALI NADIA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "12 RUE DES FRERES",
        "lieu_dit": null,
        "code_postal_ville": "13127 VITROLLES",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 720,
        "annee": 2024,
        "mois": 10,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13001' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=AITALI' -d 'prenoms[]=NADIA' -d 'anneeDateNaissance=1980' -d 'moisDateNaissance=11' -d 'jourDateNaissance=18' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-aitali-samy-3_enfants.yaml](200-aitali-samy-3_enfants.yaml)

  Status `200`

  ## Famille AITALI avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : AITALI Samy

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13001",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "AITALI",
    "prenoms": [
      "SAMY"
    ],
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 8,
    "jourDateNaissance": 28
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
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "SAMY",
          "date_naissance": "2011-08-28",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "NADIR",
          "date_naissance": "2016-04-12",
          "sexe": "M"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "SARA",
          "date_naissance": "2018-09-03",
          "sexe": "F"
        },
        {
          "nom_naissance": "AITALI",
          "nom_usage": null,
          "prenoms": "MALIK",
          "date_naissance": "2020-01-21",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur AITALI SAMY",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "12 RUE DES FRERES",
        "lieu_dit": null,
        "code_postal_ville": "13127 VITROLLES",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 720,
        "annee": 2024,
        "mois": 10,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13001' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=AITALI' -d 'prenoms[]=SAMY' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=8' -d 'jourDateNaissance=28' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-benzarte-samira-3_enfants.yaml](200-benzarte-samira-3_enfants.yaml)

  Status `200`

  ## Famille BENZARTE avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : BENZARTE Samira

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "BENZARTE",
    "prenoms": [
      "SAMIRA"
    ],
    "anneeDateNaissance": 1986,
    "moisDateNaissance": 4,
    "jourDateNaissance": 12
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
          "nom_naissance": "BENZARTE",
          "nom_usage": null,
          "prenoms": "SAMIRA",
          "date_naissance": "1986-04-12",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "BENZARTE",
          "nom_usage": null,
          "prenoms": "LANA",
          "date_naissance": "2011-11-18",
          "sexe": "F"
        },
        {
          "nom_naissance": "BENZARTE",
          "nom_usage": null,
          "prenoms": "NASSIM",
          "date_naissance": "2014-01-13",
          "sexe": "M"
        },
        {
          "nom_naissance": "BENZARTE",
          "nom_usage": null,
          "prenoms": "YANIS",
          "date_naissance": "2018-06-04",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame BENZARTE SAMIRA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "14 RUE SAINT-PIERRE",
        "lieu_dit": null,
        "code_postal_ville": "13005 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 980,
        "annee": 2024,
        "mois": 9,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=BENZARTE' -d 'prenoms[]=SAMIRA' -d 'anneeDateNaissance=1986' -d 'moisDateNaissance=4' -d 'jourDateNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-couple-2_enfants-qf_msa_150_mai26.yaml](200-couple-2_enfants-qf_msa_150_mai26.yaml)

  Status `200`

  ## Couple avec deux enfants - allocataire féminin - QF MSA de 150 en mai 2026

Ce cas permet de tester :
- [Param. appel] Mois et année du QF recherché 
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe feminin
- [Param. appel] Deux prénoms
- [Réponse] Tableau d'informations car couple
- [Réponse] Tableau d'informations car deux enfants
- [Réponse] Régime MSA
- [Réponse] Quotient familial de 150
- [Réponse] Quotient familial ancien de mai 2026

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "ROUX",
    "prenoms": [
      "JEANNE",
      "STEPHANIE"
    ],
    "anneeDateNaissance": 1987,
    "moisDateNaissance": 6,
    "annee": 2026,
    "mois": 5
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "quotient_familial": {
        "fournisseur": "MSA",
        "valeur": 150,
        "annee": 2026,
        "mois": 5,
        "annee_calcul": 2024,
        "mois_calcul": 12
      },
      "allocataires": [
        {
          "nom_naissance": "ROUX",
          "nom_usage": null,
          "prenoms": "JEANNE STEPHANIE",
          "date_naissance": "1987-06-27",
          "sexe": "F"
        },
        {
          "nom_naissance": "ROUX",
          "nom_usage": null,
          "prenoms": "LOIC NATHAN",
          "date_naissance": "1979-05-19",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ROUX",
          "nom_usage": null,
          "prenoms": "ALEXIS VINCENT",
          "date_naissance": "2006-04-20",
          "sexe": "M"
        },
        {
          "nom_naissance": "ROUX",
          "nom_usage": null,
          "prenoms": "FLEUR EDITH",
          "date_naissance": "2004-04-20",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame ROUX JEANNE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=ROUX' -d 'prenoms[]=JEANNE' -d 'prenoms[]=STEPHANIE' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=6' -d 'annee=2026' -d 'mois=5' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-couple-2_enfants-qf_msa_150_sept2024.yaml](200-couple-2_enfants-qf_msa_150_sept2024.yaml)

  Status `200`

  ## Couple avec deux enfants - allocataire masculin - QF MSA de 200 en septembre 2024

Ce cas permet de tester : 
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe masculin
- [Param. appel] 1 prénom
- [Réponse] Tableau d'informations car couple
- [Réponse] Tableau d'informations car deux enfants
- [Réponse] Régime MSA
- [Réponse] Quotient familial de 200
- [Réponse] Quotient familial ancien de septembre 2024

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "51108",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "Martin",
    "prenoms": [
      "Pierre"
    ],
    "anneeDateNaissance": 1987,
    "moisDateNaissance": 6,
    "jourDateNaissance": 27
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
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "PIERRE ALEXIS FRANÇOIS",
          "date_naissance": "1978-06-27",
          "sexe": "M"
        },
        {
          "nom_naissance": "LEROUGE",
          "nom_usage": "MARTIN",
          "prenoms": "JUSTINE ÉLISE",
          "date_naissance": "1979-05-19",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "ALEXIS VINCENT",
          "date_naissance": "2006-04-20",
          "sexe": "M"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "FLEUR EDITH",
          "date_naissance": "2010-04-20",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur MARTIN Pierre",
        "complement_information": "Bâtiment B",
        "complement_information_geographique": "Résidence Alouette",
        "numero_libelle_voie": "12 AVENUE DU GÉNÉRAL DE GAULLE",
        "lieu_dit": null,
        "code_postal_ville": "51000 CHÂLONS-EN-CHAMPAGNE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "MSA",
        "valeur": 200,
        "annee": 2024,
        "mois": 9,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=51108' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=Martin' -d 'prenoms[]=Pierre' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=6' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-diallo-aminata-5_enfants.yaml](200-diallo-aminata-5_enfants.yaml)

  Status `200`

  ## Famille DIALLO avec cinq enfants

Ce cas permet de tester :
* la gestion d'une famille avec cinq enfants
* parent : DIALLO Aminata

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "DIALLO",
    "prenoms": [
      "AMINATA"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 2,
    "jourDateNaissance": 7
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
          "nom_naissance": "DIALLO",
          "nom_usage": null,
          "prenoms": "AMINATA",
          "date_naissance": "1982-02-07",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "DIALLO",
          "nom_usage": null,
          "prenoms": "FELIXIA",
          "date_naissance": "2010-09-30",
          "sexe": "F"
        },
        {
          "nom_naissance": "DIALLO",
          "nom_usage": null,
          "prenoms": "ISMAEL",
          "date_naissance": "2015-07-09",
          "sexe": "M"
        },
        {
          "nom_naissance": "DIALLO",
          "nom_usage": null,
          "prenoms": "NOUR",
          "date_naissance": "2012-01-14",
          "sexe": "F"
        },
        {
          "nom_naissance": "DIALLO",
          "nom_usage": null,
          "prenoms": "ADAMA",
          "date_naissance": "2017-03-16",
          "sexe": "M"
        },
        {
          "nom_naissance": "DIALLO",
          "nom_usage": null,
          "prenoms": "MARIAM",
          "date_naissance": "2020-08-05",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame DIALLO AMINATA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "6 RUE DES ABEILLES",
        "lieu_dit": null,
        "code_postal_ville": "13001 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 760,
        "annee": 2024,
        "mois": 8,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=DIALLO' -d 'prenoms[]=AMINATA' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=2' -d 'jourDateNaissance=7' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-etranger-celibataire-2_enfants-qf_cnaf_300_sept2024.yaml](200-etranger-celibataire-2_enfants-qf_cnaf_300_sept2024.yaml)

  Status `200`

  ## célibataire né aux Etats Unis avec deux enfants - allocataire féminin - QF CNAF de 300 en aout 2024

Ce cas permet de tester : 
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe féminin
- [Param. appel] 1 prénom
- [Réponse] Tableau d'informations 1 seul allocataire
- [Réponse] Tableau d'informations car deux enfants
- [Réponse] Régime CNAF
- [Réponse] Quotient familial de 300
- [Réponse] Quotient familial ancien de aout 2024

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseePaysNaissance": "99404",
    "sexeEtatCivil": "F",
    "nomNaissance": "SIMPSON",
    "prenoms": [
      "Marge"
    ],
    "anneeDateNaissance": 1980,
    "moisDateNaissance": 11,
    "jourDateNaissance": 15
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
          "nom_naissance": "BROWN",
          "nom_usage": null,
          "prenoms": "Marge",
          "date_naissance": "1980-11-15",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "BROWN",
          "nom_usage": null,
          "prenoms": "Bart",
          "date_naissance": "2012-02-28",
          "sexe": "M"
        },
        {
          "nom_naissance": "SIMPSON",
          "nom_usage": null,
          "prenoms": "LISA",
          "date_naissance": "2013-03-01",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame SIMPSON Marge",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 PLACE DE L'HÔTEL DE VILLE'",
        "lieu_dit": null,
        "code_postal_ville": "51000 CHÂLONS-EN-CHAMPAGNE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 300,
        "annee": 2024,
        "mois": 8,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseePaysNaissance=99404' -d 'sexeEtatCivil=F' -d 'nomNaissance=SIMPSON' -d 'prenoms[]=Marge' -d 'anneeDateNaissance=1980' -d 'moisDateNaissance=11' -d 'jourDateNaissance=15' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-famille-4_enfants.yaml](200-famille-4_enfants.yaml)

  Status `200`

  ## Famille avec quatre enfants (scolarisé / boursier / non boursier / majeur)

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* la prise en compte de profils enfants différents (scolarisé, boursier, non boursier/scolarisé, majeur)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13001",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "SOPHIE"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 9,
    "jourDateNaissance": 3
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
          "nom_usage": null,
          "prenoms": "SOPHIE",
          "date_naissance": "1982-09-03",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "DUPONT",
          "nom_usage": null,
          "prenoms": "LOUISE",
          "date_naissance": "2007-06-22",
          "sexe": "F"
        },
        {
          "nom_naissance": "DUPONT",
          "nom_usage": null,
          "prenoms": "LAURA",
          "date_naissance": "2013-11-15",
          "sexe": "F"
        },
        {
          "nom_naissance": "DUPONT",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2016-12-03",
          "sexe": "F"
        },
        {
          "nom_naissance": "DUPONT",
          "nom_usage": null,
          "prenoms": "MAXIME",
          "date_naissance": "2015-09-01",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame DUPONT SOPHIE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "15 COURS JULIEN",
        "lieu_dit": null,
        "code_postal_ville": "13006 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 900,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13001' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=DUPONT' -d 'prenoms[]=SOPHIE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=9' -d 'jourDateNaissance=3' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-famille-avec_espace_dans_le_nom.yaml](200-famille-avec_espace_dans_le_nom.yaml)

  Status `200`

  ## Famille CHAMPS BERGER avec trois enfants

Ce cas permet de tester :
- la gestion d'un nom de famille avec un espace

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "57463",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "CHAMPS BERGER",
    "prenoms": [
      "MARIE"
    ],
    "anneeDateNaissance": 1988,
    "moisDateNaissance": 12,
    "jourDateNaissance": 1
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
          "nom_naissance": "CHAMPS BERGER",
          "nom_usage": null,
          "prenoms": "MARIE",
          "date_naissance": "1988-12-01",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "CHAMPS BERGER",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2004-03-30",
          "sexe": "F"
        },
        {
          "nom_naissance": "CHAMPS BERGER",
          "nom_usage": null,
          "prenoms": "SARAH SOFIA",
          "date_naissance": "2012-07-12",
          "sexe": "F"
        },
        {
          "nom_naissance": "CHAMPS BERGER",
          "nom_usage": null,
          "prenoms": "LEA SOPHIE",
          "date_naissance": "2018-11-25",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame CHAMPS BERGER MARIE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "12 RUE DE LA PAIX",
        "lieu_dit": null,
        "code_postal_ville": "57000 METZ",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 689,
        "annee": 2026,
        "mois": 4,
        "annee_calcul": 2026,
        "mois_calcul": 4
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=57463' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=CHAMPS+BERGER' -d 'prenoms[]=MARIE' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=12' -d 'jourDateNaissance=1' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-ferreira-ana-4_enfants.yaml](200-ferreira-ana-4_enfants.yaml)

  Status `200`

  ## Famille FERREIRA avec quatre enfants

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* parent : FERREIRA Ana

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13002",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "FERREIRA",
    "prenoms": [
      "ANA"
    ],
    "anneeDateNaissance": 1986,
    "moisDateNaissance": 8,
    "jourDateNaissance": 31
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
          "nom_naissance": "FERREIRA",
          "nom_usage": null,
          "prenoms": "ANA",
          "date_naissance": "1986-08-31",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "FERREIRA",
          "nom_usage": null,
          "prenoms": "MAYA",
          "date_naissance": "2011-12-19",
          "sexe": "F"
        },
        {
          "nom_naissance": "FERREIRA",
          "nom_usage": null,
          "prenoms": "KAIS",
          "date_naissance": "2011-01-06",
          "sexe": "M"
        },
        {
          "nom_naissance": "FERREIRA",
          "nom_usage": null,
          "prenoms": "MATEO",
          "date_naissance": "2013-04-17",
          "sexe": "M"
        },
        {
          "nom_naissance": "FERREIRA",
          "nom_usage": null,
          "prenoms": "ELIA",
          "date_naissance": "2018-12-10",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame FERREIRA ANA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "8 BOULEVARD JEAN JAURES",
        "lieu_dit": null,
        "code_postal_ville": "13400 AUBAGNE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1020,
        "annee": 2024,
        "mois": 11,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13002' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=FERREIRA' -d 'prenoms[]=ANA' -d 'anneeDateNaissance=1986' -d 'moisDateNaissance=8' -d 'jourDateNaissance=31' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-garcia-maria-4_enfants.yaml](200-garcia-maria-4_enfants.yaml)

  Status `200`

  ## Famille GARCIA avec quatre enfants

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* parent : GARCIA Maria

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13090",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "GARCIA",
    "prenoms": [
      "MARIA"
    ],
    "anneeDateNaissance": 1984,
    "moisDateNaissance": 9,
    "jourDateNaissance": 23
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
          "nom_naissance": "GARCIA",
          "nom_usage": null,
          "prenoms": "MARIA",
          "date_naissance": "1984-09-23",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "GARCIA",
          "nom_usage": null,
          "prenoms": "MATEO",
          "date_naissance": "2012-03-07",
          "sexe": "M"
        },
        {
          "nom_naissance": "GARCIA",
          "nom_usage": null,
          "prenoms": "ELENA",
          "date_naissance": "2013-05-21",
          "sexe": "F"
        },
        {
          "nom_naissance": "GARCIA",
          "nom_usage": null,
          "prenoms": "NOAH",
          "date_naissance": "2016-10-02",
          "sexe": "M"
        },
        {
          "nom_naissance": "GARCIA",
          "nom_usage": null,
          "prenoms": "LUCIE",
          "date_naissance": "2019-01-18",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame GARCIA MARIA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "22 AVENUE DE LA REPUBLIQUE",
        "lieu_dit": null,
        "code_postal_ville": "13190 ALLAUCH",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1120,
        "annee": 2024,
        "mois": 10,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13090' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=GARCIA' -d 'prenoms[]=MARIA' -d 'anneeDateNaissance=1984' -d 'moisDateNaissance=9' -d 'jourDateNaissance=23' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-giraud-anne-3_enfants.yaml](200-giraud-anne-3_enfants.yaml)

  Status `200`

  ## Famille GIRAUD avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : GIRAUD Anne

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13002",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "GIRAUD",
    "prenoms": [
      "ANNE"
    ],
    "anneeDateNaissance": 1988,
    "moisDateNaissance": 12,
    "jourDateNaissance": 1
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
          "nom_naissance": "GIRAUD",
          "nom_usage": null,
          "prenoms": "ANNE",
          "date_naissance": "1988-12-01",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "GIRAUD",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2004-03-30",
          "sexe": "F"
        },
        {
          "nom_naissance": "GIRAUD",
          "nom_usage": null,
          "prenoms": "SARAH",
          "date_naissance": "2012-07-12",
          "sexe": "F"
        },
        {
          "nom_naissance": "GIRAUD",
          "nom_usage": null,
          "prenoms": "LEA",
          "date_naissance": "2018-11-25",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame GIRAUD ANNE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "8 BOULEVARD JEAN JAURÈS",
        "lieu_dit": null,
        "code_postal_ville": "13400 AUBAGNE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1200,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13002' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=GIRAUD' -d 'prenoms[]=ANNE' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=12' -d 'jourDateNaissance=1' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-haddad-leyna-5_enfants.yaml](200-haddad-leyna-5_enfants.yaml)

  Status `200`

  ## Famille HADDAD avec cinq enfants

Ce cas permet de tester :
* la gestion d'une famille avec cinq enfants
* parent : HADDAD Leyna

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13056",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "HADDAD",
    "prenoms": [
      "LEYNA"
    ],
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 11,
    "jourDateNaissance": 6
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
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "LEYNA",
          "date_naissance": "2010-11-06",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "YANIS",
          "date_naissance": "2011-02-19",
          "sexe": "M"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2015-02-08",
          "sexe": "F"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "SAMIR",
          "date_naissance": "2018-07-17",
          "sexe": "M"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "AMEL",
          "date_naissance": "2020-10-04",
          "sexe": "F"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "NADIR",
          "date_naissance": "2022-01-15",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame HADDAD LEYNA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "31 RUE DES ECOLES",
        "lieu_dit": null,
        "code_postal_ville": "13003 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 790,
        "annee": 2024,
        "mois": 12,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13056' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=HADDAD' -d 'prenoms[]=LEYNA' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=11' -d 'jourDateNaissance=6' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-haddad-rachid-4_enfants.yaml](200-haddad-rachid-4_enfants.yaml)

  Status `200`

  ## Famille HADDAD avec quatre enfants

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* parent : HADDAD Rachid

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13056",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "HADDAD",
    "prenoms": [
      "RACHID"
    ],
    "anneeDateNaissance": 1981,
    "moisDateNaissance": 7,
    "jourDateNaissance": 5
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
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "RACHID",
          "date_naissance": "1981-07-05",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "YANIS",
          "date_naissance": "2011-02-19",
          "sexe": "M"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "LEYNA",
          "date_naissance": "2010-11-06",
          "sexe": "F"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2015-02-08",
          "sexe": "F"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "SAMIR",
          "date_naissance": "2018-07-17",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur HADDAD RACHID",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "27 BOULEVARD NATIONAL",
        "lieu_dit": null,
        "code_postal_ville": "13003 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 850,
        "annee": 2024,
        "mois": 12,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13056' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=HADDAD' -d 'prenoms[]=RACHID' -d 'anneeDateNaissance=1981' -d 'moisDateNaissance=7' -d 'jourDateNaissance=5' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-haddad-yanis-4_enfants.yaml](200-haddad-yanis-4_enfants.yaml)

  Status `200`

  ## Famille HADDAD avec quatre enfants

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* parent : HADDAD Yanis

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13056",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "HADDAD",
    "prenoms": [
      "YANIS"
    ],
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 2,
    "jourDateNaissance": 19
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
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "YANIS",
          "date_naissance": "2011-02-19",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2015-02-08",
          "sexe": "F"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "SAMIR",
          "date_naissance": "2018-07-17",
          "sexe": "M"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "AMEL",
          "date_naissance": "2020-10-04",
          "sexe": "F"
        },
        {
          "nom_naissance": "HADDAD",
          "nom_usage": null,
          "prenoms": "NADIR",
          "date_naissance": "2022-01-15",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur HADDAD YANIS",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "27 BOULEVARD NATIONAL",
        "lieu_dit": null,
        "code_postal_ville": "13003 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 850,
        "annee": 2024,
        "mois": 12,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13056' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=HADDAD' -d 'prenoms[]=YANIS' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=2' -d 'jourDateNaissance=19' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-identite-cas-etranger.yaml](200-identite-cas-etranger.yaml)

  Status `200`

  ## IDENTITÉ CAS ETRANGER

Ce cas est le cas personne étrangère de l'ensemble des cas de test d'identité/limite.
Il a pour but de décrire une personne fictive avec l'ensemble de ses paramètres
et la réponse lorsque celui ci est trouvé.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseePaysNaissance": "99350",
    "sexeEtatCivil": "M",
    "nomNaissance": "FAKIR",
    "prenoms": [
      "EYMEN",
      "MOHAMED"
    ],
    "anneeDateNaissance": 1992,
    "moisDateNaissance": 11,
    "jourDateNaissance": 14
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
          "nom_naissance": "FAKIR",
          "nom_usage": null,
          "prenoms": "EYMEN MOHAMED",
          "date_naissance": "1992-11-14",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Monsieur FAKOR EYMEN MOHAMED",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "19 RUE ARISTIDE BRIAND",
        "lieu_dit": null,
        "code_postal_ville": "92330 SCEAUX",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 4270,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseePaysNaissance=99350' -d 'sexeEtatCivil=M' -d 'nomNaissance=FAKIR' -d 'prenoms[]=EYMEN' -d 'prenoms[]=MOHAMED' -d 'anneeDateNaissance=1992' -d 'moisDateNaissance=11' -d 'jourDateNaissance=14' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-identite-cas-limite-erreur-phonetique.yaml](200-identite-cas-limite-erreur-phonetique.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui ne changent pas la phonétique. Ici, il y a suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXI",
      "GEROME",
      "JEN-PHILIPE"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12,
    "jourDateNaissance": 27
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
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
          "date_naissance": "1982-12-27",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXI' -d 'prenoms[]=GEROME' -d 'prenoms[]=JEN-PHILIPE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-identite-cas-limite-faute-de-frappe.yaml](200-identite-cas-limite-faute-de-frappe.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui changent la phonétique. Ici, il y a suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEIXS",
      "GRÉÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12,
    "jourDateNaissance": 27
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
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
          "date_naissance": "1982-12-27",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEIXS' -d 'prenoms[]=GR%C3%89%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-identite-cas-nominal-peu-de-donnee-naissance.yaml](200-identite-cas-nominal-peu-de-donnee-naissance.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Les données de jour et de mois de naissance ont été retiré.

Il y a suffisament de données de nom/prénoms dans les paramètres pour compenser
l'absence des données de naissance.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXIS",
      "GÉRÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateNaissance": 1982
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
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
          "date_naissance": "1982-12-27",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateNaissance=1982' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-identite-cas-nominal-peu-de-donnee-prenom.yaml](200-identite-cas-nominal-peu-de-donnee-prenom.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Les deuxième et troisième prenoms ont été retiré des données

Il y suffisament de donnée de naissance dans cet ensemble de paramètre pour permettre
de compenser les données manquantes

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXIS"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12,
    "jourDateNaissance": 27
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
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
          "date_naissance": "1982-12-27",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-identite-cas-nominal.yaml](200-identite-cas-nominal.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas est le cas nominal de l'ensemble des cas de test d'identité/limite.
Il a pour but de décrire une personne fictive avec l'ensemble de ses paramètres
et la réponse lorsque celui ci est trouvé.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXIS",
      "GÉRÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12,
    "jourDateNaissance": 27
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
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
          "date_naissance": "1982-12-27",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-khelifi-sofia-3_enfants.yaml](200-khelifi-sofia-3_enfants.yaml)

  Status `200`

  ## Famille KHELIFI avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : KHELIFI Sofia

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13047",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "KHELIFI",
    "prenoms": [
      "SOFIA"
    ],
    "anneeDateNaissance": 1988,
    "moisDateNaissance": 5,
    "jourDateNaissance": 9
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
          "nom_naissance": "KHELIFI",
          "nom_usage": null,
          "prenoms": "SOFIA",
          "date_naissance": "1988-05-09",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "KHELIFI",
          "nom_usage": null,
          "prenoms": "SARAH",
          "date_naissance": "2012-02-08",
          "sexe": "F"
        },
        {
          "nom_naissance": "KHELIFI",
          "nom_usage": null,
          "prenoms": "YANE",
          "date_naissance": "2012-02-24",
          "sexe": "M"
        },
        {
          "nom_naissance": "KHELIFI",
          "nom_usage": null,
          "prenoms": "NADIR",
          "date_naissance": "2017-10-14",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame KHELIFI SOFIA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "5 ALLEE DES PINS",
        "lieu_dit": null,
        "code_postal_ville": "13120 GARDANNE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1180,
        "annee": 2024,
        "mois": 9,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13047' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=KHELIFI' -d 'prenoms[]=SOFIA' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=5' -d 'jourDateNaissance=9' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-martin-julien-4_enfants.yaml](200-martin-julien-4_enfants.yaml)

  Status `200`

  ## Famille MARTIN avec quatre enfants

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* parent : MARTIN Julien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13005",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "MARTIN",
    "prenoms": [
      "JULIEN"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 1,
    "jourDateNaissance": 29
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
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "JULIEN",
          "date_naissance": "1985-01-29",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "LINA",
          "date_naissance": "2011-04-09",
          "sexe": "F"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "THEO",
          "date_naissance": "2014-09-18",
          "sexe": "M"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "CAMILLE",
          "date_naissance": "2016-05-22",
          "sexe": "F"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "RAPHAEL",
          "date_naissance": "2019-12-03",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur MARTIN JULIEN",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "3 PLACE DE LA MAIRIE",
        "lieu_dit": null,
        "code_postal_ville": "13260 CASSIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1480,
        "annee": 2024,
        "mois": 11,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13005' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=MARTIN' -d 'prenoms[]=JULIEN' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=1' -d 'jourDateNaissance=29' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-martin-pierre-3_enfants.yaml](200-martin-pierre-3_enfants.yaml)

  Status `200`

  ## Famille MARTIN avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : MARTIN Pierre

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "MARTIN",
    "prenoms": [
      "PIERRE"
    ],
    "anneeDateNaissance": 1987,
    "moisDateNaissance": 6,
    "jourDateNaissance": 12
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
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "PIERRE",
          "date_naissance": "1987-06-12",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "LUCAS",
          "date_naissance": "2005-04-20",
          "sexe": "M"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "EMMA",
          "date_naissance": "2012-08-15",
          "sexe": "F"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "NOAH",
          "date_naissance": "2015-01-10",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur MARTIN PIERRE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "15 AVENUE DU PRADO",
        "lieu_dit": null,
        "code_postal_ville": "13001 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1200,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=MARTIN' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=6' -d 'jourDateNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-moreau-claire-3_enfants.yaml](200-moreau-claire-3_enfants.yaml)

  Status `200`

  ## Famille MOREAU avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : MOREAU Claire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13103",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "MOREAU",
    "prenoms": [
      "CLAIRE"
    ],
    "anneeDateNaissance": 1989,
    "moisDateNaissance": 3,
    "jourDateNaissance": 19
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
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "CLAIRE",
          "date_naissance": "1989-03-19",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "EMMA",
          "date_naissance": "2012-08-14",
          "sexe": "F"
        },
        {
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "NOAH",
          "date_naissance": "2013-06-27",
          "sexe": "M"
        },
        {
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "LEA",
          "date_naissance": "2017-09-09",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame MOREAU CLAIRE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "9 AVENUE VICTOR HUGO",
        "lieu_dit": null,
        "code_postal_ville": "13500 MARTIGUES",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1260,
        "annee": 2024,
        "mois": 9,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13103' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=MOREAU' -d 'prenoms[]=CLAIRE' -d 'anneeDateNaissance=1989' -d 'moisDateNaissance=3' -d 'jourDateNaissance=19' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-moreau-emma-3_enfants.yaml](200-moreau-emma-3_enfants.yaml)

  Status `200`

  ## Famille MOREAU avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : MOREAU Emma

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13103",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "MOREAU",
    "prenoms": [
      "EMMA"
    ],
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 8,
    "jourDateNaissance": 14
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
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "EMMA",
          "date_naissance": "2012-08-14",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "LEA",
          "date_naissance": "2017-09-09",
          "sexe": "F"
        },
        {
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "NOAH",
          "date_naissance": "2013-06-27",
          "sexe": "M"
        },
        {
          "nom_naissance": "MOREAU",
          "nom_usage": null,
          "prenoms": "LOUIS",
          "date_naissance": "2020-02-18",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame MOREAU EMMA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "11 AVENUE VICTOR HUGO",
        "lieu_dit": null,
        "code_postal_ville": "13500 MARTIGUES",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1180,
        "annee": 2024,
        "mois": 10,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13103' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=MOREAU' -d 'prenoms[]=EMMA' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=8' -d 'jourDateNaissance=14' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-nom-usage-femme-seule-qf_caf_800.yaml](200-nom-usage-femme-seule-qf_caf_800.yaml)

  Status `200`

  ## Femme seule avec nom d'usage - QF CAF de 800

Ce cas permet de tester :
- [Param. appel] Utilisation du paramètre nomUsage
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe féminin
- [Réponse] Nom d'usage présent dans la réponse
- [Réponse] Régime CAF
- [Réponse] Quotient familial de 800

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "DURAND",
    "nomUsage": "MARTIN",
    "prenoms": [
      "SOPHIE",
      "MARIE"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 3,
    "jourDateNaissance": 15
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
          "nom_naissance": "DURAND",
          "nom_usage": "MARTIN",
          "prenoms": "SOPHIE MARIE",
          "date_naissance": "1985-03-15",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Madame MARTIN SOPHIE MARIE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "12 AVENUE DES CHAMPS ELYSEES",
        "lieu_dit": null,
        "code_postal_ville": "75008 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 800,
        "annee": 2024,
        "mois": 3,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=DURAND' -d 'nomUsage=MARTIN' -d 'prenoms[]=SOPHIE' -d 'prenoms[]=MARIE' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=3' -d 'jourDateNaissance=15' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-parent-1_enfant_non_scolarise.yaml](200-parent-1_enfant_non_scolarise.yaml)

  Status `200`

  ## Parent avec un enfant non scolarisé

Ce cas permet de tester :
* la gestion d'un parent avec un enfant non scolarisé
* la non-éligibilité au statut famille nombreuse pour ce profil

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "ROCHER",
    "prenoms": [
      "SANDRINE"
    ],
    "anneeDateNaissance": 1986,
    "moisDateNaissance": 11,
    "jourDateNaissance": 9
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
          "nom_naissance": "ROCHER",
          "nom_usage": null,
          "prenoms": "SANDRINE",
          "date_naissance": "1986-11-09",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ROCHER",
          "nom_usage": null,
          "prenoms": "LUCIE",
          "date_naissance": "2009-05-14",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame ROCHER SANDRINE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "10 RUE SAINTE",
        "lieu_dit": null,
        "code_postal_ville": "13001 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 800,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=ROCHER' -d 'prenoms[]=SANDRINE' -d 'anneeDateNaissance=1986' -d 'moisDateNaissance=11' -d 'jourDateNaissance=9' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-parent-2_enfants.yaml](200-parent-2_enfants.yaml)

  Status `200`

  ## Parent avec deux enfants

Ce cas permet de tester :
* la gestion d'une famille avec deux enfants

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13090",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "BERNANRD",
    "prenoms": [
      "JULIEN"
    ],
    "anneeDateNaissance": 1979,
    "moisDateNaissance": 2,
    "jourDateNaissance": 27
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
          "nom_naissance": "BERNANRD",
          "nom_usage": null,
          "prenoms": "JULIEN",
          "date_naissance": "1979-02-27",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "BERNANRD",
          "nom_usage": null,
          "prenoms": "THOMAS",
          "date_naissance": "2006-06-08",
          "sexe": "M"
        },
        {
          "nom_naissance": "BERNANRD",
          "nom_usage": null,
          "prenoms": "MAXIME",
          "date_naissance": "2015-09-01",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur BERNANRD JULIEN",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "28 BOULEVARD MICHELET",
        "lieu_dit": null,
        "code_postal_ville": "13008 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1050,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13090' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=BERNANRD' -d 'prenoms[]=JULIEN' -d 'anneeDateNaissance=1979' -d 'moisDateNaissance=2' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-parent-3_enfants.yaml](200-parent-3_enfants.yaml)

  Status `200`

  ## Famille avec trois enfants (boursier / non boursier / majeur)

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* la prise en compte de statuts différents (boursier, non boursier, enfant majeur)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "MARTIN",
    "prenoms": [
      "PIERRE"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 6,
    "jourDateNaissance": 12
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
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "PIERRE",
          "date_naissance": "1985-06-12",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "LUCAS",
          "date_naissance": "2005-04-20",
          "sexe": "M"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "EMMA",
          "date_naissance": "2012-08-15",
          "sexe": "F"
        },
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "NOAH",
          "date_naissance": "2015-01-10",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur MARTIN PIERRE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "42 AVENUE DE LA RÉPUBLIQUE",
        "lieu_dit": null,
        "code_postal_ville": "13001 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1200,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=MARTIN' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=6' -d 'jourDateNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-rossi-chiara-4_enfants.yaml](200-rossi-chiara-4_enfants.yaml)

  Status `200`

  ## Famille ROSSI avec quatre enfants

Ce cas permet de tester :
* la gestion d'une famille avec quatre enfants
* parent : ROSSI Chiara

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13028",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "ROSSI",
    "prenoms": [
      "CHIARA"
    ],
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 3,
    "jourDateNaissance": 30
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
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "CHIARA",
          "date_naissance": "2012-03-30",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "NOAH",
          "date_naissance": "2016-06-11",
          "sexe": "M"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "INES",
          "date_naissance": "2018-12-02",
          "sexe": "F"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "LOU",
          "date_naissance": "2020-05-09",
          "sexe": "F"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "ENZO",
          "date_naissance": "2022-07-21",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame ROSSI CHIARA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "22 AVENUE DES PINS",
        "lieu_dit": null,
        "code_postal_ville": "13600 LA CIOTAT",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 980,
        "annee": 2024,
        "mois": 10,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13028' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=ROSSI' -d 'prenoms[]=CHIARA' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=3' -d 'jourDateNaissance=30' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-rossi-clara-3_enfants.yaml](200-rossi-clara-3_enfants.yaml)

  Status `200`

  ## Famille ROSSI avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : ROSSI Clara

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13028",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "ROSSI",
    "prenoms": [
      "CLARA"
    ],
    "anneeDateNaissance": 1987,
    "moisDateNaissance": 6,
    "jourDateNaissance": 14
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
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "CLARA",
          "date_naissance": "1987-06-14",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "LUCA",
          "date_naissance": "2011-06-15",
          "sexe": "M"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "CHIARA",
          "date_naissance": "2012-03-30",
          "sexe": "F"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "EMMA",
          "date_naissance": "2011-03-17",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame ROSSI CLARA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "18 CHEMIN DES OLIVIERS",
        "lieu_dit": null,
        "code_postal_ville": "13600 LA CIOTAT",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1340,
        "annee": 2024,
        "mois": 7,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13028' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=ROSSI' -d 'prenoms[]=CLARA' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=6' -d 'jourDateNaissance=14' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-rossi-emma-5_enfants.yaml](200-rossi-emma-5_enfants.yaml)

  Status `200`

  ## Famille ROSSI avec cinq enfants

Ce cas permet de tester :
* la gestion d'une famille avec cinq enfants
* parent : ROSSI Emma

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13028",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "ROSSI",
    "prenoms": [
      "EMMA"
    ],
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 3,
    "jourDateNaissance": 17
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
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "EMMA",
          "date_naissance": "2011-03-17",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "LINA",
          "date_naissance": "2015-02-05",
          "sexe": "F"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "GABRIEL",
          "date_naissance": "2016-08-19",
          "sexe": "M"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "MIA",
          "date_naissance": "2018-11-23",
          "sexe": "F"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "LEO",
          "date_naissance": "2020-04-12",
          "sexe": "M"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "NINA",
          "date_naissance": "2022-09-30",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Madame ROSSI EMMA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "5 IMPASSE DU PORT",
        "lieu_dit": null,
        "code_postal_ville": "13600 LA CIOTAT",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 870,
        "annee": 2024,
        "mois": 11,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13028' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=ROSSI' -d 'prenoms[]=EMMA' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=3' -d 'jourDateNaissance=17' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-rossi-luca-3_enfants.yaml](200-rossi-luca-3_enfants.yaml)

  Status `200`

  ## Famille ROSSI avec trois enfants

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants
* parent : ROSSI Luca

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13028",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "ROSSI",
    "prenoms": [
      "LUCA"
    ],
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 6,
    "jourDateNaissance": 15
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
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "LUCA",
          "date_naissance": "2011-06-15",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "NINA",
          "date_naissance": "2017-04-08",
          "sexe": "F"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "MATTEO",
          "date_naissance": "2019-09-14",
          "sexe": "M"
        },
        {
          "nom_naissance": "ROSSI",
          "nom_usage": null,
          "prenoms": "LENA",
          "date_naissance": "2021-01-27",
          "sexe": "F"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur ROSSI LUCA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "18 CHEMIN DES OLIVIERS",
        "lieu_dit": null,
        "code_postal_ville": "13600 LA CIOTAT",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1290,
        "annee": 2024,
        "mois": 9,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13028' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=ROSSI' -d 'prenoms[]=LUCA' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-roux-david-3_enfants-tuteur.yaml](200-roux-david-3_enfants-tuteur.yaml)

  Status `200`

  ## Famille ROUX avec trois enfants (tuteur légal)

Ce cas permet de tester :
* la gestion d'une famille avec trois enfants de noms différents
* parent/tuteur légal : ROUX David

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13054",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "ROUX",
    "prenoms": [
      "DAVID"
    ],
    "anneeDateNaissance": 1983,
    "moisDateNaissance": 5,
    "jourDateNaissance": 19
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
          "nom_naissance": "ROUX",
          "nom_usage": null,
          "prenoms": "DAVID",
          "date_naissance": "1983-05-19",
          "sexe": "M"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "ROLLAND",
          "nom_usage": null,
          "prenoms": "MATHIS",
          "date_naissance": "2011-09-12",
          "sexe": "M"
        },
        {
          "nom_naissance": "LECLERC",
          "nom_usage": null,
          "prenoms": "ENZO",
          "date_naissance": "2014-01-28",
          "sexe": "M"
        },
        {
          "nom_naissance": "SAYDOU",
          "nom_usage": null,
          "prenoms": "ADAM",
          "date_naissance": "2017-06-03",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur ROUX DAVID",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "31 AVENUE DE MARSEILLE",
        "lieu_dit": null,
        "code_postal_ville": "13127 VITROLLES",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 1200,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13054' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=ROUX' -d 'prenoms[]=DAVID' -d 'anneeDateNaissance=1983' -d 'moisDateNaissance=5' -d 'jourDateNaissance=19' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-saidi-karima-5_enfants.yaml](200-saidi-karima-5_enfants.yaml)

  Status `200`

  ## Famille SAIDI avec cinq enfants

Ce cas permet de tester :
* la gestion d'une famille avec cinq enfants
* parent : SAIDI Karima

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "SAIDI",
    "prenoms": [
      "KARIMA"
    ],
    "anneeDateNaissance": 1983,
    "moisDateNaissance": 10,
    "jourDateNaissance": 8
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
          "nom_naissance": "SAIDI",
          "nom_usage": null,
          "prenoms": "KARIMA",
          "date_naissance": "1983-10-08",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "SAIDI",
          "nom_usage": null,
          "prenoms": "NOUR",
          "date_naissance": "2010-12-02",
          "sexe": "F"
        },
        {
          "nom_naissance": "SAIDI",
          "nom_usage": null,
          "prenoms": "YANIS",
          "date_naissance": "2012-07-10",
          "sexe": "M"
        },
        {
          "nom_naissance": "SAIDI",
          "nom_usage": null,
          "prenoms": "MAYA",
          "date_naissance": "2011-11-02",
          "sexe": "F"
        },
        {
          "nom_naissance": "SAIDI",
          "nom_usage": null,
          "prenoms": "ILYANA",
          "date_naissance": "2016-02-26",
          "sexe": "F"
        },
        {
          "nom_naissance": "SAIDI",
          "nom_usage": null,
          "prenoms": "AMIR",
          "date_naissance": "2020-04-11",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame SAIDI KARIMA",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "45 RUE DE LYON",
        "lieu_dit": null,
        "code_postal_ville": "13015 MARSEILLE",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 690,
        "annee": 2024,
        "mois": 6,
        "annee_calcul": 2025,
        "mois_calcul": 1
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=SAIDI' -d 'prenoms[]=KARIMA' -d 'anneeDateNaissance=1983' -d 'moisDateNaissance=10' -d 'jourDateNaissance=8' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-seul-1_enfant-qf_caf_650.yaml](200-seul-1_enfant-qf_caf_650.yaml)

  Status `200`

  ## Famille monoparentale avec un enfant - allocataire féminin - QF CAF en cours de 650

Ce cas permet de tester :
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe feminin
- [Réponse] Régime CAF
- [Réponse] Quotient familial de 650

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "BERNARD",
    "prenoms": [
      "ELODIE"
    ],
    "anneeDateNaissance": 1990,
    "moisDateNaissance": 3
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
          "nom_naissance": "BERNARD",
          "nom_usage": null,
          "prenoms": "ELODIE JUDITH GERTRUDE",
          "date_naissance": "1990-03-18",
          "sexe": "F"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "BERNARD",
          "nom_usage": null,
          "prenoms": "LEO",
          "date_naissance": "1990-04-20",
          "sexe": "M"
        }
      ],
      "adresse": {
        "destinataire": "Madame BERNARD ELODIE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE MONTORGUEIL",
        "lieu_dit": null,
        "code_postal_ville": "75002 PARIS",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 650,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=BERNARD' -d 'prenoms[]=ELODIE' -d 'anneeDateNaissance=1990' -d 'moisDateNaissance=3' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-seul-sans_enfant-qf_caf_2550.yaml](200-seul-sans_enfant-qf_caf_2550.yaml)

  Status `200`

  ## Allocataire seul - masculin - QF CAF de 2550 du mois en cours

Ce cas permet de tester :
- [Param. appel] lieu de naissance en France
- [Param. appel] sexe masculin
- [Réponse] Régime CAF
- [Réponse] Quotient familial de 2550
- [Réponse] Quotient familial du mois en cours

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXIS"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12
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
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "ALEXIS",
          "date_naissance": "1982-12-27",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Monsieur LEFEBVRE ALEXIS",
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
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [200-usager-base-france_connect.yaml](200-usager-base-france_connect.yaml)

  Status `200`

  ## Identité connue de la base de test de France Connect

Ce cas permet de tester un appel à partir notamment des données de l'identité
pivot France Connect.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "75107",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "DUBOIS",
    "prenoms": [
      "ANGELA",
      "CLAIRE",
      "LOUISE"
    ],
    "anneeDateNaissance": 1962,
    "moisDateNaissance": 8,
    "jourDateNaissance": 24
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
          "nom_usage": null,
          "prenoms": "ANGELA CLAIRE LOUISE",
          "date_naissance": "1962-08-24",
          "sexe": "F"
        }
      ],
      "enfants": [],
      "adresse": {
        "destinataire": "Madame DUBOIS ANGELA CLAIRE LOUISE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "19 RUE ARISTIDE BRIAND",
        "lieu_dit": null,
        "code_postal_ville": "92330 SCEAUX",
        "pays": "FRANCE"
      },
      "quotient_familial": {
        "fournisseur": "CNAF",
        "valeur": 4270,
        "annee": 2023,
        "mois": 6,
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite?recipient=13002526500013"
  ```

  </p>
  </details>
* [404-identite-cas-limite-erreur-phonetique.yaml](404-identite-cas-limite-erreur-phonetique.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui changent ne change pas ou peu la phonétique. Ici, il n'y a pas suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXI",
      "GEROME",
      "JEN-PHILIPE"
    ],
    "anneeDateNaissance": 1982
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXI' -d 'prenoms[]=GEROME' -d 'prenoms[]=JEN-PHILIPE' -d 'anneeDateNaissance=1982' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [404-identite-cas-limite-faute-de-frappe.yaml](404-identite-cas-limite-faute-de-frappe.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui changent la phonétique. Ici, il n'y a pas suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEIXS",
      "GRÉÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateNaissance": 1982
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEIXS' -d 'prenoms[]=GR%C3%89%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateNaissance=1982' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [404-identite-cas-nominal-trop-peu-de-donnee-naissance.yaml](404-identite-cas-nominal-trop-peu-de-donnee-naissance.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Les données concernant la date de naissance ont été retirée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXIS",
      "GÉRÔME",
      "JEAN-PHILIPPE"
    ]
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [404-identite-cas-nominal-trop-peu-de-donnee-prenom.yaml](404-identite-cas-nominal-trop-peu-de-donnee-prenom.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Le nom ainsi que les deuxième et troisième prenoms ont été retiré des données

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "ALEXIS"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12,
    "jourDateNaissance": 27
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=DUPONT' -d 'prenoms[]=ALEXIS' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LEFEBVRE' -d 'codeCogInseeCommuneNaissance=00404' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [429.yaml](429.yaml)

  Status `429`

  ## Allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DESFOUIN",
    "prenoms": [
      "René"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 12,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
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
        "code": "00429",
        "title": "Trop de requêtes",
        "detail": "Vous avez effectué trop de requêtes",
        "source": null,
        "meta": {}
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DESFOUIN' -d 'prenoms[]=Ren%C3%A9' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  ## Allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DELANOUE",
    "prenoms": [
      "Jean-Marie"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 12,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
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
        "code": "37999",
        "title": "Erreur inconnue du fournisseur de données",
        "detail": "La réponse retournée par le fournisseur de données est invalide et inconnue de notre service. L'équipe technique a été notifiée de cette erreur pour investigation.",
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DELANOUE' -d 'prenoms[]=Jean-Marie' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  ## Allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "SITUDI",
    "prenoms": [
      "Clément"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 12,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
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
        "code": "37002",
        "title": "Intermédiaire hors-délai",
        "detail": "Temps d’attente d’une réponse du fournisseur de données écoulé.",
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SITUDI' -d 'prenoms[]=Cl%C3%A9ment' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/identite"
  ```

  </p>
  </details>
