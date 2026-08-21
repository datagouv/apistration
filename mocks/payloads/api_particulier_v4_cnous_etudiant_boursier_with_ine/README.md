# [INE] Statut étudiant boursier
* [200_boursier.yaml](200_boursier.yaml)

  Status `200`

  Boursier avec INE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2023-09-01",
        "duree": 10
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Université Toulouse III - Paul Sabatier"
      },
      "echelon_bourse": {
        "echelon": "4",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "etudiant@univ-tlse3.fr",
      "identite": {
        "nom": "LEROY",
        "prenoms": [
          "THOMAS"
        ],
        "date_naissance": "2001-05-18",
        "nom_commune_naissance": "Toulouse",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567890A' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_annee_n1_fille_dupont.yaml](200_boursier_annee_n1_fille_dupont.yaml)

  Status `200`

  Boursier sur année N-1 - Fille Dupont - Dijon Carnot

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321M"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2025-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "Carnot"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "fille@dupont.com",
      "identite": {
        "nom": "DUPONT",
        "prenoms": [
          "FILLE"
        ],
        "date_naissance": "2003-10-01",
        "nom_commune_naissance": "Marseille",
        "sexe": "F"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321M' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_annee_n2_fille_b_dupont.yaml](200_boursier_annee_n2_fille_b_dupont.yaml)

  Status `200`

  Boursier sur année N-2 - Fille B Dupont - Dijon Carnot

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321N"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2024-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "Carnot"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "filleb@dupont.com",
      "identite": {
        "nom": "DUPONT",
        "prenoms": [
          "FILLE B"
        ],
        "date_naissance": "2003-10-01",
        "nom_commune_naissance": "Marseille",
        "sexe": "F"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321N' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_campagne_anterieure.yaml](200_boursier_campagne_anterieure.yaml)

  Status `200`

  Boursier sur une campagne antérieure ciblée via campaignYear

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "1234567890A",
    "campaignYear": 2022
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2022-09-01",
        "duree": 10
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Université Toulouse III - Paul Sabatier"
      },
      "echelon_bourse": {
        "echelon": "3",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "etudiant@univ-tlse3.fr",
      "identite": {
        "nom": "LEROY",
        "prenoms": [
          "THOMAS"
        ],
        "date_naissance": "2001-05-18",
        "nom_commune_naissance": "Toulouse",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=1234567890A' -d 'campaignYear=2022' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_commune_accentuee_minnie_mouse.yaml](200_boursier_commune_accentuee_minnie_mouse.yaml)

  Status `200`

  Boursière avec commune accentuée et tirets - Minnie Mouse - Marsannay-la-Côte BSB

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-20",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Marsannay-la-Côte",
        "nom_etablissement": "BSB"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "minnie@mouse.fr",
      "identite": {
        "nom": "MOUSE",
        "prenoms": [
          "MINNIE"
        ],
        "date_naissance": "2001-02-05",
        "nom_commune_naissance": "Dole",
        "sexe": "F"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321F' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_commune_naissance_typo_mickey_mouse.yaml](200_boursier_commune_naissance_typo_mickey_mouse.yaml)

  Status `200`

  Boursier avec commune de naissance mal orthographiée (Bordeau) - Mickey Mouse - Dijon IAE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321E"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-10",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "IAE"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "mickey@mouse.fr",
      "identite": {
        "nom": "MOUSE",
        "prenoms": [
          "MICKEY"
        ],
        "date_naissance": "2009-12-30",
        "nom_commune_naissance": "Bordeau",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321E' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_daisy_duck.yaml](200_boursier_daisy_duck.yaml)

  Status `200`

  Boursière - Daisy Duck - Saint-Apollinaire BSB

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321D"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-15",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Saint-Apollinaire",
        "nom_etablissement": "BSB"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "daisy@duck.com",
      "identite": {
        "nom": "DUCK",
        "prenoms": [
          "DAISY"
        ],
        "date_naissance": "2002-08-17",
        "nom_commune_naissance": "Aix-en-Provence",
        "sexe": "F"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321D' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_hors_dijon_donald_duck.yaml](200_boursier_hors_dijon_donald_duck.yaml)

  Status `200`

  Boursier hors Dijon (Toulouse) - Donald Duck - Toulouse Baudelaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321H"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-25",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Toulouse",
        "nom_etablissement": "Baudelaire"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "donald@duck.fr",
      "identite": {
        "nom": "DUCK",
        "prenoms": [
          "DONALD"
        ],
        "date_naissance": "2001-05-18",
        "nom_commune_naissance": "Rennes",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321H' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_naissance_1947_balthazar_picsou.yaml](200_boursier_naissance_1947_balthazar_picsou.yaml)

  Status `200`

  Boursier avec date de naissance atypique (1947) - Balthazar Picsou - Dijon IAE

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321G"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-05",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "IAE"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "balthazar@piscou.com",
      "identite": {
        "nom": "PICSOU",
        "prenoms": [
          "BALTHAZAR"
        ],
        "date_naissance": "1947-11-14",
        "nom_commune_naissance": "Dijon",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321G' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_pat_hibulaire.yaml](200_boursier_pat_hibulaire.yaml)

  Status `200`

  Boursier - Pat Hibulaire - Dijon BSB

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "123456789AB"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-15",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "BSB"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "pat@hibulaire.com",
      "identite": {
        "nom": "PAT",
        "prenoms": [
          "HIBULAIRE"
        ],
        "date_naissance": "2006-06-30",
        "nom_commune_naissance": "La Rochelle",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=123456789AB' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_prenom_compose_espace_anne_marie_robert.yaml](200_boursier_prenom_compose_espace_anne_marie_robert.yaml)

  Status `200`

  Boursière avec prénom composé avec espace - Anne Marie Robert - Dijon Carnot

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321K"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "Carnot"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "annemarie@michel.com",
      "identite": {
        "nom": "ROBERT",
        "prenoms": [
          "ANNE MARIE"
        ],
        "date_naissance": "2006-06-26",
        "nom_commune_naissance": "Marseille",
        "sexe": "F"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321K' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_prenom_compose_tiret_jean_michel_robert.yaml](200_boursier_prenom_compose_tiret_jean_michel_robert.yaml)

  Status `200`

  Boursier avec prénom composé avec tiret - Jean-Michel Robert - Dijon Carnot

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321J"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "Carnot"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "robet@jean-michel.com",
      "identite": {
        "nom": "ROBERT",
        "prenoms": [
          "JEAN-MICHEL"
        ],
        "date_naissance": "2003-01-08",
        "nom_commune_naissance": "Colmar",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321J' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_regional_provisoire_loulou_duck.yaml](200_boursier_regional_provisoire_loulou_duck.yaml)

  Status `200`

  Boursier avec échelon régional provisoire et commune accentuée - Loulou Duck - Fontaine-Lès-Dijon Carnot

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321C"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-10-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Fontaine-Lès-Dijon",
        "nom_etablissement": "Carnot"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": true
      },
      "email": "loulou@duck.com",
      "identite": {
        "nom": "DUCK",
        "prenoms": [
          "LOULOU"
        ],
        "date_naissance": "2001-06-21",
        "nom_commune_naissance": "Strasbourg",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321C' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_boursier_riri_duck.yaml](200_boursier_riri_duck.yaml)

  Status `200`

  Boursier standard - Riri Duck - Dijon Carnot

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321A"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": true,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-01",
        "duree": 12
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "Carnot"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "riri@duck.com",
      "identite": {
        "nom": "DUCK",
        "prenoms": [
          "RIRI"
        ],
        "date_naissance": "2004-03-11",
        "nom_commune_naissance": "Morez",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321A' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_non_boursier_fifi_duck.yaml](200_non_boursier_fifi_duck.yaml)

  Status `200`

  Non boursier avec INE - Fifi Duck - Dijon Carnot

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321L"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": false,
        "est_radie": false,
        "date_radiation": null
      },
      "periode_versement_bourse": {
        "date_rentree": "2026-09-01",
        "duree": 0
      },
      "etablissement_etudes": {
        "nom_commune": "Dijon",
        "nom_etablissement": "Carnot"
      },
      "echelon_bourse": {
        "echelon": "6",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "fifi@duck.com",
      "identite": {
        "nom": "DUCK",
        "prenoms": [
          "FIFI"
        ],
        "date_naissance": "2003-11-06",
        "nom_commune_naissance": "Ahuy",
        "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321L' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
* [200_radie.yaml](200_radie.yaml)

  Status `200`

  Boursier radié

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "ine": "0987654321B"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_boursier": {
        "est_boursier": false,
        "est_radie": true,
        "date_radiation": "2023-12-01"
      },
      "periode_versement_bourse": {
        "date_rentree": "2023-09-01",
        "duree": 3
      },
      "etablissement_etudes": {
        "nom_commune": "Bordeaux",
        "nom_etablissement": "Université de Bordeaux"
      },
      "echelon_bourse": {
        "echelon": "2",
        "echelon_bourse_regionale_provisoire": false
      },
      "email": "etudiant@u-bordeaux.fr",
      "identite": {
        "nom": "PETIT",
        "prenoms": [
          "CAMILLE"
        ],
        "date_naissance": "2000-11-03",
        "nom_commune_naissance": "Bordeaux",
        "sexe": "F"
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
    -G -d 'recipient=13002526500013' -d 'ine=0987654321B' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
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
    "ine": "9999999999Z"
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
        "code": "26003",
        "title": "Entité non trouvée",
        "detail": "Aucun étudiant boursier n'a pu être trouvé avec les critères de recherche fournis. Veuillez vérifier que l'identifiant correspond au périmètre couvert par l'API.",
        "source": null,
        "meta": {
          "provider": "CNOUS"
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
    -G -d 'recipient=13002526500013' -d 'ine=9999999999Z' \
    --url "https://staging.particulier.api.gouv.fr/v4/cnous/etudiant_boursier/ine"
  ```

  </p>
  </details>
