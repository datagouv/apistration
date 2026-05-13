# Statut élève scolarisé et boursier
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
