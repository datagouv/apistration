# Statut élève scolarisé et boursier
* [200-eleve-boursier-amine-benali.yaml](200-eleve-boursier-amine-benali.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "BENALI",
    "prenoms": [
      "AMINE"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2015,
    "moisDateNaissance": 12,
    "jourDateNaissance": 11,
    "codeEtablissement": "0132634T",
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
        "nom": "BENALI",
        "prenom": "AMINE",
        "sexe": "M",
        "date_naissance": "2015-12-11"
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
        "code_uai": "0132634T",
        "nom": "Collège André Malraux",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BENALI' -d 'prenoms[]=AMINE' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2015' -d 'moisDateNaissance=12' -d 'jourDateNaissance=11' -d 'codeEtablissement=0132634T' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-chloe-riviere.yaml](200-eleve-boursier-chloe-riviere.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "RIVIERE",
    "prenoms": [
      "CHLOE"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2016,
    "moisDateNaissance": 7,
    "jourDateNaissance": 6,
    "codeEtablissement": "0131328Y",
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
        "nom": "RIVIERE",
        "prenom": "CHLOE",
        "sexe": "F",
        "date_naissance": "2016-07-06"
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
        "code_uai": "0131328Y",
        "nom": "Lycée Paul Melizan",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RIVIERE' -d 'prenoms[]=CHLOE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2016' -d 'moisDateNaissance=7' -d 'jourDateNaissance=6' -d 'codeEtablissement=0131328Y' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-elise-ferrand.yaml](200-eleve-boursier-elise-ferrand.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "FERRAND",
    "prenoms": [
      "ELISE"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2014,
    "moisDateNaissance": 9,
    "jourDateNaissance": 27,
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
        "nom": "FERRAND",
        "prenom": "ELISE",
        "sexe": "F",
        "date_naissance": "2014-09-27"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=FERRAND' -d 'prenoms[]=ELISE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2014' -d 'moisDateNaissance=9' -d 'jourDateNaissance=27' -d 'codeEtablissement=0132733A' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
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
* [200-eleve-boursier-maxime-dupont.yaml](200-eleve-boursier-maxime-dupont.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "MAXIME"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2015,
    "moisDateNaissance": 9,
    "jourDateNaissance": 1,
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
        "prenom": "MAXIME",
        "sexe": "M",
        "date_naissance": "2015-09-01"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=MAXIME' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2015' -d 'moisDateNaissance=9' -d 'jourDateNaissance=1' -d 'codeEtablissement=0130002G' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-sarah-giraud.yaml](200-eleve-boursier-sarah-giraud.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "GIRAUD",
    "prenoms": [
      "SARAH"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 7,
    "jourDateNaissance": 12,
    "codeEtablissement": "0132409Y",
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
        "nom": "GIRAUD",
        "prenom": "SARAH",
        "sexe": "F",
        "date_naissance": "2012-07-12"
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
        "code_uai": "0132409Y",
        "nom": "Collège Alphonse Daudet",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=GIRAUD' -d 'prenoms[]=SARAH' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=7' -d 'jourDateNaissance=12' -d 'codeEtablissement=0132409Y' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-yassine-caron.yaml](200-eleve-boursier-yassine-caron.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "CARON",
    "prenoms": [
      "YASSINE"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 2,
    "jourDateNaissance": 2,
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
        "nom": "CARON",
        "prenom": "YASSINE",
        "sexe": "M",
        "date_naissance": "2010-02-02"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=CARON' -d 'prenoms[]=YASSINE' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'codeEtablissement=0132733A' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-adam-saydou.yaml](200-eleve-non-boursier-adam-saydou.yaml)

  Status `200`

  Élève non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "SAYDOU",
    "prenoms": [
      "ADAM"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2017,
    "moisDateNaissance": 6,
    "jourDateNaissance": 3,
    "codeEtablissement": "0132326H",
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
        "nom": "SAYDOU",
        "prenom": "ADAM",
        "sexe": "M",
        "date_naissance": "2017-06-03"
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
        "code_uai": "0132326H",
        "nom": "Collège Albert Camus",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SAYDOU' -d 'prenoms[]=ADAM' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2017' -d 'moisDateNaissance=6' -d 'jourDateNaissance=3' -d 'codeEtablissement=0132326H' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-clara-robert.yaml](200-eleve-non-boursier-clara-robert.yaml)

  Status `200`

  Élève non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "ROBERT",
    "prenoms": [
      "CLARA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 9,
    "jourDateNaissance": 21,
    "codeEtablissement": "0130039X",
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
        "nom": "ROBERT",
        "prenom": "CLARA",
        "sexe": "F",
        "date_naissance": "2005-09-21"
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
        "code_uai": "0130039X",
        "nom": "Lycée Saint-Charles",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ROBERT' -d 'prenoms[]=CLARA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=9' -d 'jourDateNaissance=21' -d 'codeEtablissement=0130039X' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-hugo-leroy.yaml](200-eleve-non-boursier-hugo-leroy.yaml)

  Status `200`

  Élève non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "LEROY",
    "prenoms": [
      "HUGO"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2008,
    "moisDateNaissance": 6,
    "jourDateNaissance": 18,
    "codeEtablissement": "0130136C",
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
        "nom": "LEROY",
        "prenom": "HUGO",
        "sexe": "M",
        "date_naissance": "2008-06-18"
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
        "code_uai": "0130136C",
        "nom": "Collège Vieux Port",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LEROY' -d 'prenoms[]=HUGO' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2008' -d 'moisDateNaissance=6' -d 'jourDateNaissance=18' -d 'codeEtablissement=0130136C' -d 'anneeScolaire=2025' \
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
* [200-eleve-non-boursier-justine-martine.yaml](200-eleve-non-boursier-justine-martine.yaml)

  Status `200`

  Élève non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTINE",
    "prenoms": [
      "JUSTINE"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2006,
    "moisDateNaissance": 1,
    "jourDateNaissance": 15,
    "codeEtablissement": "0130040Y",
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
        "nom": "MARTINE",
        "prenom": "JUSTINE",
        "sexe": "F",
        "date_naissance": "2006-01-15"
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
        "code_uai": "0130040Y",
        "nom": "Lycée Thiers",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTINE' -d 'prenoms[]=JUSTINE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=1' -d 'jourDateNaissance=15' -d 'codeEtablissement=0130040Y' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-lea-giraud.yaml](200-eleve-non-boursier-lea-giraud.yaml)

  Status `200`

  Élève non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "GIRAUD",
    "prenoms": [
      "LEA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2018,
    "moisDateNaissance": 11,
    "jourDateNaissance": 25,
    "codeEtablissement": "0132409Y",
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
        "nom": "GIRAUD",
        "prenom": "LEA",
        "sexe": "F",
        "date_naissance": "2018-11-25"
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
        "code_uai": "0132409Y",
        "nom": "Collège Alphonse Daudet",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=GIRAUD' -d 'prenoms[]=LEA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2018' -d 'moisDateNaissance=11' -d 'jourDateNaissance=25' -d 'codeEtablissement=0132409Y' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v3/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-louis-petit.yaml](200-eleve-non-boursier-louis-petit.yaml)

  Status `200`

  Élève non boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "PETIT",
    "prenoms": [
      "LOUIS"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2007,
    "moisDateNaissance": 4,
    "jourDateNaissance": 9,
    "codeEtablissement": "0132327J",
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
        "nom": "PETIT",
        "prenom": "LOUIS",
        "sexe": "M",
        "date_naissance": "2007-04-09"
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
        "code_uai": "0132327J",
        "nom": "Collège Miramaris",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=PETIT' -d 'prenoms[]=LOUIS' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=4' -d 'jourDateNaissance=9' -d 'codeEtablissement=0132327J' -d 'anneeScolaire=2025' \
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
      "annee_scolaire": "2025",
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
