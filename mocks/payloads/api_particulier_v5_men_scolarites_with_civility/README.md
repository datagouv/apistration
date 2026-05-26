# Statut élève scolarisé et boursier
* [200-eleve-boursier-amine-benali_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-amine-benali_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BENALI' -d 'prenoms[]=AMINE' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2015' -d 'moisDateNaissance=12' -d 'jourDateNaissance=11' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-chloe-riviere_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-chloe-riviere_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RIVIERE' -d 'prenoms[]=CHLOE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2016' -d 'moisDateNaissance=7' -d 'jourDateNaissance=6' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-elise-ferrand_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-elise-ferrand_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=FERRAND' -d 'prenoms[]=ELISE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2014' -d 'moisDateNaissance=9' -d 'jourDateNaissance=27' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-emma-rossi_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-emma-rossi_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "ROSSI",
    "prenoms": [
      "EMMA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 3,
    "jourDateNaissance": 17,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "ROSSI",
        "prenom": "EMMA",
        "sexe": "F",
        "date_naissance": "2011-03-17"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010001610",
        "libelle": "5EME"
      },
      "annee_scolaire": "2025-2026",
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
      "est_boursier": true,
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ROSSI' -d 'prenoms[]=EMMA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=3' -d 'jourDateNaissance=17' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-ilyes-bensaid_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-ilyes-bensaid_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "BENSAID",
    "prenoms": [
      "ILYES"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 3,
    "jourDateNaissance": 25,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "BENSAID",
        "prenom": "ILYES",
        "sexe": "M",
        "date_naissance": "2010-03-25"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010002410",
        "libelle": "2NDE GENERALE ET TECHNOLOGIQUE"
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BENSAID' -d 'prenoms[]=ILYES' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=3' -d 'jourDateNaissance=25' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-ines-fernandes_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-ines-fernandes_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "FERNANDES",
    "prenoms": [
      "INES"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 5,
    "jourDateNaissance": 3,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "FERNANDES",
        "prenom": "INES",
        "sexe": "F",
        "date_naissance": "2010-05-03"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010001410",
        "libelle": "3EME"
      },
      "annee_scolaire": "2025-2026",
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
      "est_boursier": true,
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=FERNANDES' -d 'prenoms[]=INES' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=5' -d 'jourDateNaissance=3' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-ines-romero_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-ines-romero_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "ROMERO",
    "prenoms": [
      "INES"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 5,
    "jourDateNaissance": 30,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "ROMERO",
        "prenom": "INES",
        "sexe": "F",
        "date_naissance": "2012-05-30"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010002510",
        "libelle": "5EME"
      },
      "annee_scolaire": "2025-2026",
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ROMERO' -d 'prenoms[]=INES' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=5' -d 'jourDateNaissance=30' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-leyna-haddad_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-leyna-haddad_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "HADDAD",
    "prenoms": [
      "LEYNA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 11,
    "jourDateNaissance": 6,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "HADDAD",
        "prenom": "LEYNA",
        "sexe": "F",
        "date_naissance": "2010-11-06"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010001710",
        "libelle": "3EME"
      },
      "annee_scolaire": "2025-2026",
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=HADDAD' -d 'prenoms[]=LEYNA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=11' -d 'jourDateNaissance=6' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-louise-dupont_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-louise-dupont_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=LOUISE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=6' -d 'jourDateNaissance=22' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-lucas-martinez_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-lucas-martinez_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTINEZ",
    "prenoms": [
      "LUCAS"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 9,
    "jourDateNaissance": 22,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "MARTINEZ",
        "prenom": "LUCAS",
        "sexe": "M",
        "date_naissance": "2011-09-22"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010001310",
        "libelle": "4EME"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0133374X",
        "nom": "Collège Ami",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTINEZ' -d 'prenoms[]=LUCAS' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=9' -d 'jourDateNaissance=22' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-maxime-dupont_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-maxime-dupont_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=MAXIME' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2015' -d 'moisDateNaissance=9' -d 'jourDateNaissance=1' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-maya-ferreira_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-maya-ferreira_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "FERREIRA",
    "prenoms": [
      "MAYA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2017,
    "moisDateNaissance": 12,
    "jourDateNaissance": 19,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "FERREIRA",
        "prenom": "MAYA",
        "sexe": "F",
        "date_naissance": "2017-12-19"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010002310",
        "libelle": "4EME"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0131593L",
        "nom": "Ecole élémentaire Raoul Ortollan",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=FERREIRA' -d 'prenoms[]=MAYA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2017' -d 'moisDateNaissance=12' -d 'jourDateNaissance=19' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-nour-diallo_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-nour-diallo_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DIALLO",
    "prenoms": [
      "NOUR"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 1,
    "jourDateNaissance": 14,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "DIALLO",
        "prenom": "NOUR",
        "sexe": "F",
        "date_naissance": "2012-01-14"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010001910",
        "libelle": "6EME"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0131290G",
        "nom": "Centre d'information et d'orientation d'Aubagne",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": true,
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DIALLO' -d 'prenoms[]=NOUR' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=1' -d 'jourDateNaissance=14' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-samy-aitali_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-samy-aitali_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "AITALI",
    "prenoms": [
      "SAMY"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 8,
    "jourDateNaissance": 28,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "AITALI",
        "prenom": "SAMY",
        "sexe": "M",
        "date_naissance": "2011-08-28"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010001810",
        "libelle": "4EME"
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=AITALI' -d 'prenoms[]=SAMY' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=8' -d 'jourDateNaissance=28' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-sarah-giraud_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-sarah-giraud_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=GIRAUD' -d 'prenoms[]=SARAH' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=7' -d 'jourDateNaissance=12' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-yanis-saidi_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-yanis-saidi_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "SAIDI",
    "prenoms": [
      "YANIS"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 7,
    "jourDateNaissance": 10,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "SAIDI",
        "prenom": "YANIS",
        "sexe": "M",
        "date_naissance": "2012-07-10"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010001510",
        "libelle": "6EME"
      },
      "annee_scolaire": "2025-2026",
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SAIDI' -d 'prenoms[]=YANIS' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=7' -d 'jourDateNaissance=10' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-boursier-yassine-caron_recherche_par_region_academique_PACA.yaml](200-eleve-boursier-yassine-caron_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=CARON' -d 'prenoms[]=YASSINE' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-adam-saydou_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-adam-saydou_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SAYDOU' -d 'prenoms[]=ADAM' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2017' -d 'moisDateNaissance=6' -d 'jourDateNaissance=3' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-enzo-perez_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-enzo-perez_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "PEREZ",
    "prenoms": [
      "ENZO"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 6,
    "jourDateNaissance": 16,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "PEREZ",
        "prenom": "ENZO",
        "sexe": "M",
        "date_naissance": "2010-06-16"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010002110",
        "libelle": "3EME"
      },
      "annee_scolaire": "2025-2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=PEREZ' -d 'prenoms[]=ENZO' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=6' -d 'jourDateNaissance=16' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-felixia-diallo_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-felixia-diallo_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DIALLO",
    "prenoms": [
      "FELIXIA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 9,
    "jourDateNaissance": 30,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "DIALLO",
        "prenom": "FELIXIA",
        "sexe": "F",
        "date_naissance": "2010-09-30"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000310",
        "libelle": "3EME"
      },
      "annee_scolaire": "2025-2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DIALLO' -d 'prenoms[]=FELIXIA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=9' -d 'jourDateNaissance=30' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-hugo-leroy_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-hugo-leroy_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LEROY' -d 'prenoms[]=HUGO' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2008' -d 'moisDateNaissance=6' -d 'jourDateNaissance=18' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-ines-dupont_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-ines-dupont_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=INES' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2016' -d 'moisDateNaissance=12' -d 'jourDateNaissance=3' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-justine-martine_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-justine-martine_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTINE' -d 'prenoms[]=JUSTINE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=1' -d 'jourDateNaissance=15' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-lana-benzarte_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-lana-benzarte_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "BENZARTE",
    "prenoms": [
      "LANA"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2018,
    "moisDateNaissance": 11,
    "jourDateNaissance": 18,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "BENZARTE",
        "prenom": "LANA",
        "sexe": "F",
        "date_naissance": "2018-11-18"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000110",
        "libelle": "5EME"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0133034C",
        "nom": "Ecole maternelle Virginie Dedieu",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BENZARTE' -d 'prenoms[]=LANA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2018' -d 'moisDateNaissance=11' -d 'jourDateNaissance=18' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-lea-giraud_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-lea-giraud_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=GIRAUD' -d 'prenoms[]=LEA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2018' -d 'moisDateNaissance=11' -d 'jourDateNaissance=25' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-lou-mercier_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-lou-mercier_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MERCIER",
    "prenoms": [
      "LOU"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 10,
    "jourDateNaissance": 4,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "MERCIER",
        "prenom": "LOU",
        "sexe": "F",
        "date_naissance": "2011-10-04"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010002010",
        "libelle": "5EME"
      },
      "annee_scolaire": "2025-2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MERCIER' -d 'prenoms[]=LOU' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=10' -d 'jourDateNaissance=4' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-louis-petit_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-louis-petit_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=PETIT' -d 'prenoms[]=LOUIS' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=4' -d 'jourDateNaissance=9' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-luca-rossi_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-luca-rossi_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "ROSSI",
    "prenoms": [
      "LUCA"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 6,
    "jourDateNaissance": 15,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "ROSSI",
        "prenom": "LUCA",
        "sexe": "M",
        "date_naissance": "2011-06-15"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000410",
        "libelle": "6EME"
      },
      "annee_scolaire": "2025-2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ROSSI' -d 'prenoms[]=LUCA' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-mateo-garcia_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-mateo-garcia_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "GARCIA",
    "prenoms": [
      "MATEO"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 3,
    "jourDateNaissance": 7,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "GARCIA",
        "prenom": "MATEO",
        "sexe": "M",
        "date_naissance": "2012-03-07"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000210",
        "libelle": "4EME"
      },
      "annee_scolaire": "2025-2026",
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
      "est_boursier": false,
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=GARCIA' -d 'prenoms[]=MATEO' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=3' -d 'jourDateNaissance=7' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-non-scolarise-elise-ferrand_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-non-scolarise-elise-ferrand_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=FERRAND' -d 'prenoms[]=ELISE' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=9' -d 'jourDateNaissance=27' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-samy-aitali_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-samy-aitali_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "AITALI",
    "prenoms": [
      "SAMY"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 1,
    "jourDateNaissance": 21,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "AITALI",
        "prenom": "SAMY",
        "sexe": "M",
        "date_naissance": "2012-01-21"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010000510",
        "libelle": "5EME"
      },
      "annee_scolaire": "2025-2026",
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
      "est_boursier": false,
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=AITALI' -d 'prenoms[]=SAMY' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=1' -d 'jourDateNaissance=21' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200-eleve-non-boursier-sarah-khelifi_recherche_par_region_academique_PACA.yaml](200-eleve-non-boursier-sarah-khelifi_recherche_par_region_academique_PACA.yaml)

  Status `200`

  Élève scolaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "KHELIFI",
    "prenoms": [
      "SARAH"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2012,
    "moisDateNaissance": 2,
    "jourDateNaissance": 8,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
        "nom": "KHELIFI",
        "prenom": "SARAH",
        "sexe": "F",
        "date_naissance": "2012-02-08"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "20010002210",
        "libelle": "6EME"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0130143K",
        "nom": "Lycée polyvalent Paul Langevin",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=KHELIFI' -d 'prenoms[]=SARAH' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=2' -d 'jourDateNaissance=8' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_eleve_boursier.yaml](200_eleve_boursier.yaml)

  Status `200`

  Élève boursier - recherche par code établissement

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
      "echelon_bourse": 1,
      "regime_pensionnat": {
        "code": "2",
        "libelle": "Demi-pensionnaire dans l'établissement"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTIN' -d 'prenoms[]=EMMA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=8' -d 'jourDateNaissance=15' -d 'codeEtablissement=0132733A' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_eleve_boursier_recherche_par_region_academique_PACA.yaml](200_eleve_boursier_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": {
        "code": "2",
        "libelle": "Demi-pensionnaire dans l'établissement"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTIN' -d 'prenoms[]=EMMA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=8' -d 'jourDateNaissance=15' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_eleve_non_boursier.yaml](200_eleve_non_boursier.yaml)

  Status `200`

  Élève non boursier - recherche par code établissement

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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ROBERT' -d 'prenoms[]=CLARA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=9' -d 'jourDateNaissance=21' -d 'codeEtablissement=0130039X' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_eleve_non_boursier_recherche_par_region_academique_PACA.yaml](200_eleve_non_boursier_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ROBERT' -d 'prenoms[]=CLARA' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=9' -d 'jourDateNaissance=21' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_recherche_par_departement.yaml](200_recherche_par_departement.yaml)

  Status `200`

  Recherche par département

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "LEFEVRE",
    "prenoms": [
      "SARAH"
    ],
    "sexeEtatCivil": "F",
    "anneeDateNaissance": 2014,
    "moisDateNaissance": 11,
    "jourDateNaissance": 5,
    "degreEtablissement": "1D",
    "codesBcnDepartements": [
      "075"
    ],
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
        "nom": "LEFEVRE",
        "prenom": "SARAH",
        "sexe": "F",
        "date_naissance": "2014-11-05"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "01110001110",
        "libelle": "CM1"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0750001A",
        "nom": "École élémentaire Victor Hugo",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null,
      "regime_pensionnat": {
        "code": "0",
        "libelle": "Externe"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LEFEVRE' -d 'prenoms[]=SARAH' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2014' -d 'moisDateNaissance=11' -d 'jourDateNaissance=5' -d 'degreEtablissement=1D' -d 'codesBcnDepartements[]=075' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_recherche_par_region_academique.yaml](200_recherche_par_region_academique.yaml)

  Status `200`

  Recherche par région académique

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "LUCAS"
    ],
    "sexeEtatCivil": "M",
    "anneeDateNaissance": 2010,
    "moisDateNaissance": 3,
    "jourDateNaissance": 12,
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "10"
    ],
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
        "prenom": "LUCAS",
        "sexe": "M",
        "date_naissance": "2010-03-12"
      },
      "module_elementaire_formation": {
        "code_mef_stat": "10310019110",
        "libelle": "5EME"
      },
      "annee_scolaire": "2025-2026",
      "est_scolarise": true,
      "statut_eleve": {
        "code": "ST",
        "libelle": "Scolaire"
      },
      "etablissement": {
        "code_uai": "0750652B",
        "nom": "Collège Georges Brassens",
        "code_ministere_tutelle": "06"
      },
      "est_boursier": false,
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=LUCAS' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=3' -d 'jourDateNaissance=12' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=10' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_recherche_par_region_academique_PACA.yaml](200_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Martin' -d 'prenoms[]=Justine' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
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
    "sexeEtatCivil": "M",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Martin' -d 'prenoms[]=Jerome' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [404_recherche_par_region_academique_PACA.yaml](404_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Martin' -d 'prenoms[]=Jerome' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [504_recherche_par_region_academique_PACA.yaml](504_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Faure' -d 'prenoms[]=Felix' -d 'sexe=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=20' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon1_dupont_2026_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon1_dupont_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupont' -d 'prenoms[]=Nouhe' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=12' -d 'jourDateNaissance=9' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon1_dupont_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon1_dupont_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupont' -d 'prenoms[]=Nouhe' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=12' -d 'jourDateNaissance=9' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon1_thomas_2026_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon1_thomas_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Thomas' -d 'prenoms[]=Kevin' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=7' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon1_thomas_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon1_thomas_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Thomas' -d 'prenoms[]=Kevin' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=7' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon2_bispo_2026_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon2_bispo_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bispo-Antoinette' -d 'prenoms[]=Hanan' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=1999' -d 'moisDateNaissance=12' -d 'jourDateNaissance=24' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon2_bispo_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon2_bispo_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bispo-Antoinette' -d 'prenoms[]=Hanan' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=1999' -d 'moisDateNaissance=12' -d 'jourDateNaissance=24' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon2_depuis_2026_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon2_depuis_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Depuis' -d 'prenoms[]=Scavi' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=8' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon2_depuis_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon2_depuis_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Depuis' -d 'prenoms[]=Scavi' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=8' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon3_carey_2026_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon3_carey_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Carey' -d 'prenoms[]=Abdelhay' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=7' -d 'jourDateNaissance=11' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon3_carey_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon3_carey_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Carey' -d 'prenoms[]=Abdelhay' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=7' -d 'jourDateNaissance=11' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon3_el_2026_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon3_el_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=EL' -d 'prenoms[]=Nass' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=9' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_collegien_echelon3_el_recherche_par_region_academique_PACA.yaml](boursier_collegien_echelon3_el_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=EL' -d 'prenoms[]=Nass' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=9' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_garcia_recherche_par_region_academique_PACA.yaml](boursier_garcia_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Garcia' -d 'prenoms[]=Mateo' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2012' -d 'moisDateNaissance=3' -d 'jourDateNaissance=7' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon1_delin_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon1_delin_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Delin' -d 'prenoms[]=Antoine' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=3' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon1_delin_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon1_delin_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Delin' -d 'prenoms[]=Antoine' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=3' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon1_perrier_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon1_perrier_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Perrier' -d 'prenoms[]=Alex' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon1_perrier_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon1_perrier_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 1,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Perrier' -d 'prenoms[]=Alex' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon2_bob_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon2_bob_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bob' -d 'prenoms[]=Nassima' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=12' -d 'jourDateNaissance=4' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon2_bob_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon2_bob_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 2,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bob' -d 'prenoms[]=Nassima' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2004' -d 'moisDateNaissance=12' -d 'jourDateNaissance=4' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon3_herve_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon3_herve_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Herve' -d 'prenoms[]=Lena' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=3' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon3_herve_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon3_herve_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Herve' -d 'prenoms[]=Lena' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=3' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon3_pereira_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon3_pereira_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Pereira' -d 'prenoms[]=Maoris' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=8' -d 'jourDateNaissance=5' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon3_pereira_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon3_pereira_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 3,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Pereira' -d 'prenoms[]=Maoris' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=8' -d 'jourDateNaissance=5' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon4_bouti_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon4_bouti_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 4,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bouti' -d 'prenoms[]=Siham' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=4' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon4_bouti_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon4_bouti_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 4,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Bouti' -d 'prenoms[]=Siham' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=4' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon4_nom_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon4_nom_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 4,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Nom' -d 'prenoms[]=Narjes' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=1' -d 'jourDateNaissance=6' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon4_nom_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon4_nom_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 4,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Nom' -d 'prenoms[]=Narjes' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=1' -d 'jourDateNaissance=6' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon5_boucher_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon5_boucher_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 5,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Boucher' -d 'prenoms[]=Gabrielle' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=5' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon5_boucher_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon5_boucher_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 5,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Boucher' -d 'prenoms[]=Gabrielle' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=5' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon5_lunette_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon5_lunette_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 5,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lunette' -d 'prenoms[]=Zahid' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=7' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon5_lunette_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon5_lunette_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 5,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lunette' -d 'prenoms[]=Zahid' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=7' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon6_dupre_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon6_dupre_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 6,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupr%C3%A9' -d 'prenoms[]=Hind' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=8' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon6_dupre_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon6_dupre_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 6,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupr%C3%A9' -d 'prenoms[]=Hind' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=12' -d 'jourDateNaissance=8' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon6_louki_2026_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon6_louki_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": 6,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Louki' -d 'prenoms[]=Ahmed' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=6' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_lyceen_echelon6_louki_recherche_par_region_academique_PACA.yaml](boursier_lyceen_echelon6_louki_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": 6,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Louki' -d 'prenoms[]=Ahmed' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=6' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [boursier_nguyen_recherche_par_region_academique_PACA.yaml](boursier_nguyen_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Nguyen' -d 'prenoms[]=Adam' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=1' -d 'jourDateNaissance=5' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_benzarte_recherche_par_region_academique_PACA.yaml](non_boursier_benzarte_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Benzarte' -d 'prenoms[]=Lana' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=11' -d 'jourDateNaissance=18' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_caravelle_2026_recherche_par_region_academique_PACA.yaml](non_boursier_caravelle_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Caravelle' -d 'prenoms[]=Marc-Antoine' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=4' -d 'jourDateNaissance=15' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_caravelle_recherche_par_region_academique_PACA.yaml](non_boursier_caravelle_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Caravelle' -d 'prenoms[]=Marc-Antoine' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=4' -d 'jourDateNaissance=15' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_decarvalho_2026_recherche_par_region_academique_PACA.yaml](non_boursier_decarvalho_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=De+Carvalho' -d 'prenoms[]=Alexandra' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=3' -d 'jourDateNaissance=14' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_decarvalho_recherche_par_region_academique_PACA.yaml](non_boursier_decarvalho_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=De+Carvalho' -d 'prenoms[]=Alexandra' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=3' -d 'jourDateNaissance=14' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_diallo_recherche_par_region_academique_PACA.yaml](non_boursier_diallo_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Diallo' -d 'prenoms[]=Felixia' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=9' -d 'jourDateNaissance=30' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_dupond_2026_recherche_par_region_academique_PACA.yaml](non_boursier_dupond_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupond' -d 'prenoms[]=Nicolas' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_dupond_recherche_par_region_academique_PACA.yaml](non_boursier_dupond_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupond' -d 'prenoms[]=Nicolas' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_hamilton_2026_recherche_par_region_academique_PACA.yaml](non_boursier_hamilton_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Hamilton' -d 'prenoms[]=Nicole' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=7' -d 'jourDateNaissance=18' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_hamilton_recherche_par_region_academique_PACA.yaml](non_boursier_hamilton_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Hamilton' -d 'prenoms[]=Nicole' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=7' -d 'jourDateNaissance=18' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_lopez_recherche_par_region_academique_PACA.yaml](non_boursier_lopez_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lopez' -d 'prenoms[]=Sofia' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2010' -d 'moisDateNaissance=2' -d 'jourDateNaissance=14' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_randri_2026_recherche_par_region_academique_PACA.yaml](non_boursier_randri_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Randri' -d 'prenoms[]=Ishan' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=6' -d 'jourDateNaissance=17' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_randri_recherche_par_region_academique_PACA.yaml](non_boursier_randri_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Randri' -d 'prenoms[]=Ishan' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2003' -d 'moisDateNaissance=6' -d 'jourDateNaissance=17' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_ronaldo_2026_recherche_par_region_academique_PACA.yaml](non_boursier_ronaldo_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Ronaldo' -d 'prenoms[]=Marie+Davida' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=5' -d 'jourDateNaissance=16' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_ronaldo_recherche_par_region_academique_PACA.yaml](non_boursier_ronaldo_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Ronaldo' -d 'prenoms[]=Marie+Davida' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2001' -d 'moisDateNaissance=5' -d 'jourDateNaissance=16' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_sales_2026_recherche_par_region_academique_PACA.yaml](non_boursier_sales_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Sales' -d 'prenoms[]=Lisa' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=2' -d 'jourDateNaissance=12' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_sales_recherche_par_region_academique_PACA.yaml](non_boursier_sales_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Sales' -d 'prenoms[]=Lisa' -d 'sexeEtatCivil=F' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=2' -d 'jourDateNaissance=12' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_zidane_2026_recherche_par_region_academique_PACA.yaml](non_boursier_zidane_2026_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
    "anneeScolaire": "2026"
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
      "annee_scolaire": "2026",
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Zidane' -d 'prenoms[]=Hamid' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=12' -d 'jourDateNaissance=13' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2026' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
* [non_boursier_zidane_recherche_par_region_academique_PACA.yaml](non_boursier_zidane_recherche_par_region_academique_PACA.yaml)

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
    "degreEtablissement": "2D",
    "codesBcnRegions": [
      "18"
    ],
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
      "echelon_bourse": null,
      "regime_pensionnat": null
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Zidane' -d 'prenoms[]=Hamid' -d 'sexeEtatCivil=M' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=12' -d 'jourDateNaissance=13' -d 'degreEtablissement=2D' -d 'codesBcnRegions[]=18' -d 'anneeScolaire=2025' \
    --url "https://staging.particulier.api.gouv.fr/v5/men/scolarites/identite"
  ```

  </p>
  </details>
