# Statut élève scolarisé et boursier
* [200_eleve_boursier.yaml](200_eleve_boursier.yaml)

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
    --url "https://staging.particulier.api.gouv.fr/v4/men/scolarites/identite"
  ```

  </p>
  </details>
* [200_eleve_non_boursier.yaml](200_eleve_non_boursier.yaml)

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
    --url "https://staging.particulier.api.gouv.fr/v4/men/scolarites/identite"
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
    --url "https://staging.particulier.api.gouv.fr/v4/men/scolarites/identite"
  ```

  </p>
  </details>
