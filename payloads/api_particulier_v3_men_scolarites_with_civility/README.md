# Statut élève scolarisé et boursier
* [200.yaml](200.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Martin",
    "prenoms": [
      "Justine"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 20,
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
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
        "nom": "Martin",
        "prenom": "Justine",
        "sexe": "F",
        "date_naissance": "2000-01-20"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "211324099991",
        "libelle": "1CAP1 STAFFEUR ORNEMANISTE"
      },
      "annee_scolaire": "2022-2023",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0210015C",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 1
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Martin' -d 'prenoms[]=Justine' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Élève non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Martin",
    "prenoms": [
      "Jerome"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 20,
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
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
        "code": "30003",
        "title": "Entité non trouvée",
        "detail": "Aucun élève n'a pu être trouvé avec les critères de recherche fournis.",
        "source": null,
        "meta": {
          "provider": "MEN"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Martin' -d 'prenoms[]=Jerome' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  Erreur serveur

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Faure",
    "prenoms": [
      "Felix"
    ],
    "sexe": "M",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 20,
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
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
        "code": "30002",
        "title": "Intermédiaire hors-délai",
        "detail": "Temps d’attente d’une réponse du fournisseur de données écoulé.",
        "source": null,
        "meta": {
          "provider": "MEN"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Faure' -d 'prenoms[]=Felix' -d 'sexe=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon1_dupont.yaml](boursier_collegien_echelon1_dupont.yaml)

  Status `200`

  Élève boursier collégien échelon 1 - Dupont Nouhe

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Dupont",
    "prenoms": [
      "Nouhe"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2007,
    "moisDateNaissance": 12,
    "jourDateNaissance": 9,
    "codeEtablissement": "0921236U",
    "anneeScolaire": "2024"
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
        "nom": "Dupont",
        "prenom": "Nouhe",
        "sexe": "M",
        "date_naissance": "2007-12-09"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "3EME GENERALE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0921236U",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 1
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupont' -d 'prenoms[]=Nouhe' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=12' -d 'jourDateNaissance=9' -d 'codeEtablissement=0921236U' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon1_thomas.yaml](boursier_collegien_echelon1_thomas.yaml)

  Status `200`

  Élève boursier collégien échelon 1 - Thomas Kevin

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Thomas",
    "prenoms": [
      "Kevin"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 7,
    "codeEtablissement": "0941035P",
    "anneeScolaire": "2024"
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
        "nom": "Thomas",
        "prenom": "Kevin",
        "sexe": "M",
        "date_naissance": "2002-02-07"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "3EME GENERALE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0941035P",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 1
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Thomas' -d 'prenoms[]=Kevin' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=7' -d 'codeEtablissement=0941035P' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon2_bispo.yaml](boursier_collegien_echelon2_bispo.yaml)

  Status `200`

  Élève boursier collégien échelon 2 - Bispo-Antoinette Hanan

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Bispo-Antoinette",
    "prenoms": [
      "Hanan"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 1999,
    "moisDateNaissance": 12,
    "jourDateNaissance": 24,
    "codeEtablissement": "0941035P",
    "anneeScolaire": "2024"
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
        "nom": "Bispo-Antoinette",
        "prenom": "Hanan",
        "sexe": "F",
        "date_naissance": "1999-12-24"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "3EME GENERALE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0941035P",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 2
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bispo-Antoinette' -d 'prenoms[]=Hanan' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=1999' -d 'moisDateNaissance=12' -d 'jourDateNaissance=24' -d 'codeEtablissement=0941035P' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon2_depuis.yaml](boursier_collegien_echelon2_depuis.yaml)

  Status `200`

  Élève boursier collégien échelon 2 - Depuis Scavi

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Depuis",
    "prenoms": [
      "Scavi"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 8,
    "codeEtablissement": "0750611G",
    "anneeScolaire": "2024"
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
        "nom": "Depuis",
        "prenom": "Scavi",
        "sexe": "M",
        "date_naissance": "2002-02-08"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "3EME GENERALE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0750611G",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 2
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Depuis' -d 'prenoms[]=Scavi' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=8' -d 'codeEtablissement=0750611G' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon3_carey.yaml](boursier_collegien_echelon3_carey.yaml)

  Status `200`

  Élève boursier collégien échelon 3 - Carey Abdelhay

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Carey",
    "prenoms": [
      "Abdelhay"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2003,
    "moisDateNaissance": 7,
    "jourDateNaissance": 11,
    "codeEtablissement": "0750611G",
    "anneeScolaire": "2024"
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
        "nom": "Carey",
        "prenom": "Abdelhay",
        "sexe": "M",
        "date_naissance": "2003-07-11"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "3EME GENERALE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0750611G",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 3
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Carey' -d 'prenoms[]=Abdelhay' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=7' -d 'jourDateNaissance=11' -d 'codeEtablissement=0750611G' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon3_el.yaml](boursier_collegien_echelon3_el.yaml)

  Status `200`

  Élève boursier collégien échelon 3 - El Nass

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "EL",
    "prenoms": [
      "Nass"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 9,
    "codeEtablissement": "0911028Y",
    "anneeScolaire": "2024"
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
        "nom": "EL",
        "prenom": "Nass",
        "sexe": "F",
        "date_naissance": "2002-02-09"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "3EME GENERALE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0911028Y",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 3
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=EL' -d 'prenoms[]=Nass' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=9' -d 'codeEtablissement=0911028Y' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_garcia.yaml](boursier_garcia.yaml)

  Status `200`

  Élève boursier - Garcia Mateo (moins de 16 ans)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Garcia",
    "prenoms": [
      "Mateo"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 3,
    "jourDateNaissance": 7,
    "codeEtablissement": "0130032P",
    "anneeScolaire": "2025"
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
        "nom": "Garcia",
        "prenom": "Mateo",
        "sexe": "M",
        "date_naissance": "2012-03-07"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000210",
        "libelle": "4EME"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0130032P",
        "nom": "Collège Collines Durance",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Garcia' -d 'prenoms[]=Mateo' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=3' -d 'jourDateNaissance=7' -d 'codeEtablissement=0130032P' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon1_delin.yaml](boursier_lyceen_echelon1_delin.yaml)

  Status `200`

  Élève boursier lycéen échelon 1 - Delin Antoine

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Delin",
    "prenoms": [
      "Antoine"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 12,
    "jourDateNaissance": 3,
    "codeEtablissement": "0931190N",
    "anneeScolaire": "2024"
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
        "nom": "Delin",
        "prenom": "Antoine",
        "sexe": "M",
        "date_naissance": "2000-12-03"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0931190N",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 1
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Delin' -d 'prenoms[]=Antoine' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=3' -d 'codeEtablissement=0931190N' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon1_perrier.yaml](boursier_lyceen_echelon1_perrier.yaml)

  Status `200`

  Élève boursier lycéen échelon 1 - Perrier Alex

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Perrier",
    "prenoms": [
      "Alex"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 2,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Perrier",
        "prenom": "Alex",
        "sexe": "M",
        "date_naissance": "2002-02-02"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 1
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Perrier' -d 'prenoms[]=Alex' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon2_bob.yaml](boursier_lyceen_echelon2_bob.yaml)

  Status `200`

  Élève boursier lycéen échelon 2 - Bob Nassima

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Bob",
    "prenoms": [
      "Nassima"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2004,
    "moisDateNaissance": 12,
    "jourDateNaissance": 4,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Bob",
        "prenom": "Nassima",
        "sexe": "F",
        "date_naissance": "2004-12-04"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 2
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bob' -d 'prenoms[]=Nassima' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=12' -d 'jourDateNaissance=4' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon3_herve.yaml](boursier_lyceen_echelon3_herve.yaml)

  Status `200`

  Élève boursier lycéen échelon 3 - Herve Lena

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Herve",
    "prenoms": [
      "Lena"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 3,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Herve",
        "prenom": "Lena",
        "sexe": "F",
        "date_naissance": "2002-02-03"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 3
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Herve' -d 'prenoms[]=Lena' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=3' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon3_pereira.yaml](boursier_lyceen_echelon3_pereira.yaml)

  Status `200`

  Élève boursier lycéen échelon 3 - Pereira Maoris

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Pereira",
    "prenoms": [
      "Maoris"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 8,
    "jourDateNaissance": 5,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Pereira",
        "prenom": "Maoris",
        "sexe": "M",
        "date_naissance": "2002-08-05"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 3
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Pereira' -d 'prenoms[]=Maoris' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=8' -d 'jourDateNaissance=5' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon4_bouti.yaml](boursier_lyceen_echelon4_bouti.yaml)

  Status `200`

  Élève boursier lycéen échelon 4 - Bouti Siham

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Bouti",
    "prenoms": [
      "Siham"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 4,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Bouti",
        "prenom": "Siham",
        "sexe": "F",
        "date_naissance": "2002-02-04"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 4
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bouti' -d 'prenoms[]=Siham' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=4' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon4_nom.yaml](boursier_lyceen_echelon4_nom.yaml)

  Status `200`

  Élève boursier lycéen échelon 4 - Nom Narjes

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Nom",
    "prenoms": [
      "Narjes"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2006,
    "moisDateNaissance": 1,
    "jourDateNaissance": 6,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Nom",
        "prenom": "Narjes",
        "sexe": "F",
        "date_naissance": "2006-01-06"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 4
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Nom' -d 'prenoms[]=Narjes' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=1' -d 'jourDateNaissance=6' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon5_boucher.yaml](boursier_lyceen_echelon5_boucher.yaml)

  Status `200`

  Élève boursier lycéen échelon 5 - Boucher Gabrielle

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Boucher",
    "prenoms": [
      "Gabrielle"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 5,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Boucher",
        "prenom": "Gabrielle",
        "sexe": "F",
        "date_naissance": "2002-02-05"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 5
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Boucher' -d 'prenoms[]=Gabrielle' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=5' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon5_lunette.yaml](boursier_lyceen_echelon5_lunette.yaml)

  Status `200`

  Élève boursier lycéen échelon 5 - Lunette Zahid

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Lunette",
    "prenoms": [
      "Zahid"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 12,
    "jourDateNaissance": 7,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Lunette",
        "prenom": "Zahid",
        "sexe": "M",
        "date_naissance": "2000-12-07"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 5
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lunette' -d 'prenoms[]=Zahid' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=7' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon6_dupre.yaml](boursier_lyceen_echelon6_dupre.yaml)

  Status `200`

  Élève boursier lycéen échelon 6 - Dupré Hind

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Dupré",
    "prenoms": [
      "Hind"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 12,
    "jourDateNaissance": 8,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Dupré",
        "prenom": "Hind",
        "sexe": "F",
        "date_naissance": "2000-12-08"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 6
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupr%C3%A9' -d 'prenoms[]=Hind' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=8' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon6_louki.yaml](boursier_lyceen_echelon6_louki.yaml)

  Status `200`

  Élève boursier lycéen échelon 6 - Louki Ahmed

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Louki",
    "prenoms": [
      "Ahmed"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 6,
    "codeEtablissement": "0921236U",
    "anneeScolaire": "2024"
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
        "nom": "Louki",
        "prenom": "Ahmed",
        "sexe": "M",
        "date_naissance": "2002-02-06"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0921236U",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 6
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Louki' -d 'prenoms[]=Ahmed' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=6' -d 'codeEtablissement=0921236U' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_nguyen.yaml](boursier_nguyen.yaml)

  Status `200`

  Élève boursier - Nguyen Adam (moins de 16 ans)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Nguyen",
    "prenoms": [
      "Adam"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 1,
    "jourDateNaissance": 5,
    "codeEtablissement": "0133510V",
    "anneeScolaire": "2025"
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
        "nom": "Nguyen",
        "prenom": "Adam",
        "sexe": "M",
        "date_naissance": "2011-01-05"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000410",
        "libelle": "6EME"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0133510V",
        "nom": "Collège Ubelka",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Nguyen' -d 'prenoms[]=Adam' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=1' -d 'jourDateNaissance=5' -d 'codeEtablissement=0133510V' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_benzarte.yaml](non_boursier_benzarte.yaml)

  Status `200`

  Élève non boursier - Benzarte Lana (moins de 16 ans)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Benzarte",
    "prenoms": [
      "Lana"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 11,
    "jourDateNaissance": 18,
    "codeEtablissement": "0130022D",
    "anneeScolaire": "2025"
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
        "nom": "Benzarte",
        "prenom": "Lana",
        "sexe": "F",
        "date_naissance": "2011-11-18"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000110",
        "libelle": "5EME"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0130022D",
        "nom": "Collège Alice Guy (anciennement Virebelle)",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Benzarte' -d 'prenoms[]=Lana' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=11' -d 'jourDateNaissance=18' -d 'codeEtablissement=0130022D' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_caravelle.yaml](non_boursier_caravelle.yaml)

  Status `200`

  Élève non boursier - Caravelle Marc-Antoine

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Caravelle",
    "prenoms": [
      "Marc-Antoine"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 4,
    "jourDateNaissance": 15,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Caravelle",
        "prenom": "Marc-Antoine",
        "sexe": "M",
        "date_naissance": "2002-04-15"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Caravelle' -d 'prenoms[]=Marc-Antoine' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=4' -d 'jourDateNaissance=15' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_decarvalho.yaml](non_boursier_decarvalho.yaml)

  Status `200`

  Élève non boursier - De Carvalho Alexandra

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "De Carvalho",
    "prenoms": [
      "Alexandra"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 3,
    "jourDateNaissance": 14,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "De Carvalho",
        "prenom": "Alexandra",
        "sexe": "F",
        "date_naissance": "2000-03-14"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=De+Carvalho' -d 'prenoms[]=Alexandra' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=3' -d 'jourDateNaissance=14' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_diallo.yaml](non_boursier_diallo.yaml)

  Status `200`

  Élève non boursier - Diallo Felixia (moins de 16 ans)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Diallo",
    "prenoms": [
      "Felixia"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 9,
    "jourDateNaissance": 30,
    "codeEtablissement": "0131705H",
    "anneeScolaire": "2025"
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
        "nom": "Diallo",
        "prenom": "Felixia",
        "sexe": "F",
        "date_naissance": "2010-09-30"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000310",
        "libelle": "3EME"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0131705H",
        "nom": "Collège Fernand Léger",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Diallo' -d 'prenoms[]=Felixia' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=9' -d 'jourDateNaissance=30' -d 'codeEtablissement=0131705H' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_dupond.yaml](non_boursier_dupond.yaml)

  Status `200`

  Élève non boursier - Dupond Nicolas

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Dupond",
    "prenoms": [
      "Nicolas"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 2,
    "jourDateNaissance": 2,
    "codeEtablissement": "0931190N",
    "anneeScolaire": "2024"
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
        "nom": "Dupond",
        "prenom": "Nicolas",
        "sexe": "M",
        "date_naissance": "2002-02-02"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0931190N",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupond' -d 'prenoms[]=Nicolas' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'codeEtablissement=0931190N' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_hamilton.yaml](non_boursier_hamilton.yaml)

  Status `200`

  Élève non boursier - Hamilton Nicole

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Hamilton",
    "prenoms": [
      "Nicole"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 7,
    "jourDateNaissance": 18,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Hamilton",
        "prenom": "Nicole",
        "sexe": "F",
        "date_naissance": "2002-07-18"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Hamilton' -d 'prenoms[]=Nicole' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=7' -d 'jourDateNaissance=18' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_lopez.yaml](non_boursier_lopez.yaml)

  Status `200`

  Élève non boursier - Lopez Sofia (moins de 16 ans)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Lopez",
    "prenoms": [
      "Sofia"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 2,
    "jourDateNaissance": 14,
    "codeEtablissement": "0131367R",
    "anneeScolaire": "2025"
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
        "nom": "Lopez",
        "prenom": "Sofia",
        "sexe": "F",
        "date_naissance": "2010-02-14"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0131367R",
        "nom": "Collège Saint-Louis",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lopez' -d 'prenoms[]=Sofia' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=2' -d 'jourDateNaissance=14' -d 'codeEtablissement=0131367R' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_randri.yaml](non_boursier_randri.yaml)

  Status `200`

  Élève non boursier - Randri Ishan

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Randri",
    "prenoms": [
      "Ishan"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2003,
    "moisDateNaissance": 6,
    "jourDateNaissance": 17,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Randri",
        "prenom": "Ishan",
        "sexe": "M",
        "date_naissance": "2003-06-17"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Randri' -d 'prenoms[]=Ishan' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=6' -d 'jourDateNaissance=17' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_ronaldo.yaml](non_boursier_ronaldo.yaml)

  Status `200`

  Élève non boursier - Ronaldo Marie Davida

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Ronaldo",
    "prenoms": [
      "Marie Davida"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2001,
    "moisDateNaissance": 5,
    "jourDateNaissance": 16,
    "codeEtablissement": "0782567S",
    "anneeScolaire": "2024"
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
        "nom": "Ronaldo",
        "prenom": "Marie Davida",
        "sexe": "F",
        "date_naissance": "2001-05-16"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0782567S",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Ronaldo' -d 'prenoms[]=Marie+Davida' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=5' -d 'jourDateNaissance=16' -d 'codeEtablissement=0782567S' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_sales.yaml](non_boursier_sales.yaml)

  Status `200`

  Élève non boursier - Sales Lisa

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Sales",
    "prenoms": [
      "Lisa"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 2,
    "jourDateNaissance": 12,
    "codeEtablissement": "0911028Y",
    "anneeScolaire": "2024"
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
        "nom": "Sales",
        "prenom": "Lisa",
        "sexe": "F",
        "date_naissance": "2000-02-12"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "3EME GENERALE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0911028Y",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Sales' -d 'prenoms[]=Lisa' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=2' -d 'jourDateNaissance=12' -d 'codeEtablissement=0911028Y' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_zidane.yaml](non_boursier_zidane.yaml)

  Status `200`

  Élève non boursier - Zidane Hamid

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Zidane",
    "prenoms": [
      "Hamid"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 12,
    "jourDateNaissance": 13,
    "codeEtablissement": "0931190N",
    "anneeScolaire": "2024"
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
        "nom": "Zidane",
        "prenom": "Hamid",
        "sexe": "M",
        "date_naissance": "2005-12-13"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10010012110",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
      },
      "annee_scolaire": "2024-2025",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0931190N",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Zidane' -d 'prenoms[]=Hamid' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=12' -d 'jourDateNaissance=13' -d 'codeEtablissement=0931190N' -d 'anneeScolaire=2024' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
