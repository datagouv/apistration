# [Identité] Quotient familial CAF & MSA
* [200-couple-2_enfants-qf_msa_150_mai23.yaml](200-couple-2_enfants-qf_msa_150_mai23.yaml)

  Status `200`

  ## Couple avec deux enfants - allocataire féminin - QF MSA de 150 en mai 2023

Ce cas permet de tester :
- [Param. appel] Mois et année du QF recherché 
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe feminin
- [Param. appel] Deux prénoms
- [Réponse] Tableau d'informations car couple
- [Réponse] Tableau d'informations car deux enfants
- [Réponse] Régime MSA
- [Réponse] Quotient familial de 150
- [Réponse] Quotient familial ancien de mai 2023

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
    "annee": 2023,
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
        "annee": 2023,
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=ROUX' -d 'prenoms[]=JEANNE' -d 'prenoms[]=STEPHANIE' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=6' -d 'annee=2023' -d 'mois=5' \
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=51108' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=Martin' -d 'prenoms[]=Pierre' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=6' -d 'jourDateNaissance=27' \
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13001' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=DUPONT' -d 'prenoms[]=SOPHIE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=9' -d 'jourDateNaissance=3' \
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13002' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=GIRAUD' -d 'prenoms[]=ANNE' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=12' -d 'jourDateNaissance=1' \
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
      "enfants": [
  
      ],
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
      "enfants": [
  
      ],
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
      "enfants": [
  
      ],
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
      "enfants": [
  
      ],
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
      "enfants": [
  
      ],
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
      "enfants": [
  
      ],
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=MARTIN' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=6' -d 'jourDateNaissance=12' \
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=MARTIN' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=6' -d 'jourDateNaissance=12' \
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13054' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=ROUX' -d 'prenoms[]=DAVID' -d 'anneeDateNaissance=1983' -d 'moisDateNaissance=5' -d 'jourDateNaissance=19' \
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
      "enfants": [
  
      ],
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
      "enfants": [
  
      ],
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
        "meta": {
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
