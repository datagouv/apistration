# Statut élève scolarisé et boursier
* [200-eleve-boursier-emma-martin.yaml](200-eleve-boursier-emma-martin.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTIN",
    "prenoms": [
      "EMMA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 8,
    "jourDateNaissance": 15,
    "codeEtablissement": "0132733A",
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
        "nom": "MARTIN",
        "prenom": "EMMA",
        "sexe": "F",
        "date_naissance": "2012-08-15"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "211324099991",
        "libelle": "1CAP1 STAFFEUR ORNEMANISTE"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0132733A",
        "nom": "Lycée Polyvalent Antonin Artaud",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTIN' -d 'prenoms[]=EMMA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=8' -d 'jourDateNaissance=15' -d 'codeEtablissement=0132733A' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-louise-dupont.yaml](200-eleve-boursier-louise-dupont.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "LOUISE"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 6,
    "jourDateNaissance": 22,
    "codeEtablissement": "0130043B",
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
        "nom": "DUPONT",
        "prenom": "LOUISE",
        "sexe": "F",
        "date_naissance": "2010-06-22"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "211324099991",
        "libelle": "1CAP1 STAFFEUR ORNEMANISTE"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0130043B",
        "nom": "Lycée Victor Hugo",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=LOUISE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=6' -d 'jourDateNaissance=22' -d 'codeEtablissement=0130043B' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-ines-dupont.yaml](200-eleve-non-boursier-ines-dupont.yaml)

  Status `200`

  Élève non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "INES"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2016,
    "moisDateNaissance": 12,
    "jourDateNaissance": 3,
    "codeEtablissement": "0130002G",
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
        "nom": "DUPONT",
        "prenom": "INES",
        "sexe": "F",
        "date_naissance": "2016-12-03"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "211324099991",
        "libelle": "1CAP1 STAFFEUR ORNEMANISTE"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0130002G",
        "nom": "Lycée Paul Cézanne",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=INES' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2016' -d 'moisDateNaissance=12' -d 'jourDateNaissance=3' -d 'codeEtablissement=0130002G' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-non-scolarise-elise-ferrand.yaml](200-eleve-non-boursier-non-scolarise-elise-ferrand.yaml)

  Status `200`

  Élève non boursier non scolarisé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "FERRAND",
    "prenoms": [
      "ELISE"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2004,
    "moisDateNaissance": 9,
    "jourDateNaissance": 27,
    "codeEtablissement": "0130001F",
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
        "nom": "FERRAND",
        "prenom": "ELISE",
        "sexe": "F",
        "date_naissance": "2004-09-27"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "211324099991",
        "libelle": "1CAP1 STAFFEUR ORNEMANISTE"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": false,
      "statut_eleve": {
        "code": "NS",
        "libelle": "Non scolarisé"
      },
      "etablissement": {
        "code_uai": "0130001F",
        "nom": "Lycée polyvalent Émile Zola",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=FERRAND' -d 'prenoms[]=ELISE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=9' -d 'jourDateNaissance=27' -d 'codeEtablissement=0130001F' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
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
