# France Connect

Les payloads renvoyées par FranceConnect ici ne sont jamais directement
renvoyées par l'API Particulier: celles-ci sont utilisées pour appeler les
fournisseurs de données dans le cadre des API FranceConnectés.

Plus d'infos dans le [README du projet](../../#cas-de-franceconnect)

* [all_fc.yml](all_fc.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher l'ensemble des réponses aux apis france connectée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "all_fc"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "revenu_solidarite_active",
      "revenu_solidarite_active_majoration",
      "prime_activite",
      "prime_activite_majoration",
      "allocation_soutien_familial",
      "allocation_adulte_handicape",
      "complementaire_sante_solidaire",
      "cnaf_quotient_familial",
      "cnaf_allocataires",
      "cnaf_enfants",
      "cnaf_adresse",
      "eaje_allocataires",
      "eaje_enfants",
      "eaje_adresse",
      "eaje_parametres_calcul_participation_familial",
      "cnous_statut_boursier",
      "cnous_echelon_bourse",
      "cnous_email",
      "cnous_periode_versement",
      "cnous_statut_bourse",
      "cnous_ville_etudes",
      "cnous_identite",
      "mesri_identifiant",
      "mesri_identite",
      "mesri_inscription_etudiant",
      "mesri_inscription_autre",
      "mesri_admission",
      "mesri_etablissements",
      "mesri_admissions",
      "mesri_admission_inscrit",
      "mesri_admission_regime_formation",
      "mesri_admission_commune_etudes",
      "mesri_admission_etablissement_etudes",
      "dsnj_statut_service_national",
      "ants_extrait_immatriculation_vehicule_identite_particulier",
      "ants_extrait_immatriculation_vehicule_adresse_particulier",
      "ants_extrait_immatriculation_vehicule_statut_rattachement",
      "ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule",
      "ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Thomas",
      "family_name": "Delatour",
      "birthdate": "1994-04-16",
      "gender": "male",
      "birthplace": "75111",
      "birthcountry": "99100",
      "preferred_username": "Delamouette"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer all_fc" --url "https://staging.particulier.api.gouv.fr/v2/composition-familiale-v2?recipient=13002526500013"
  ```

  </p>
  </details>
* [ants.yml](ants.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de l'API ANTS Extrait Immatriculation Véhicule

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "ants"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "ants_extrait_immatriculation_vehicule_identite_particulier",
      "ants_extrait_immatriculation_vehicule_adresse_particulier",
      "ants_extrait_immatriculation_vehicule_statut_rattachement",
      "ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule",
      "ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Thomas",
      "family_name": "Delatour",
      "birthdate": "1994-04-16",
      "gender": "male",
      "birthplace": "75111",
      "birthcountry": "99100",
      "preferred_username": "Delamouette"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer ants" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [cnaf_css.yml](cnaf_css.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/complementaire-sante-solidaire` suivante](../api_particulier_v2_cnaf_complementaire_sante_solidaire/fake_france_connect_cnaf.yml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "cnaf_css"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "complementaire_sante_solidaire"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Georges",
      "family_name": "CNAF",
      "birthdate": "2002-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "MARTIN"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer cnaf_css" --url "https://staging.particulier.api.gouv.fr/v2/complementaire-sante-solidaire?recipient=13002526500013"
  ```

  </p>
  </details>
* [cnaf_eaje.yml](cnaf_eaje.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v3/dss/participation_familiale_eaje/france_connect` suivante](../api_particulier_v3_cnav_participation_familiale_eaje_with_france_connect/fake_france_connect_cnaf.yaml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "cnaf_eaje"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "cnaf_quotient_familial",
      "cnaf_allocataires",
      "cnaf_enfants",
      "cnaf_adresse"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Georges",
      "family_name": "CNAF",
      "birthdate": "2002-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "MARTIN"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer cnaf_eaje" --url "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [cnaf_qfv2.yml](cnaf_qfv2.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/composition-familiale-v2` suivante](../api_particulier_v2_cnav_quotient_familial_v2/fake_france_connect_cnaf.yaml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "cnaf_qfv2"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "cnaf_quotient_familial",
      "cnaf_allocataires",
      "cnaf_enfants",
      "cnaf_adresse"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Georges",
      "family_name": "CNAF",
      "birthdate": "2002-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "MARTIN"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer cnaf_qfv2" --url "https://staging.particulier.api.gouv.fr/v2/composition-familiale-v2?recipient=13002526500013"
  ```

  </p>
  </details>
* [cnous.yaml](cnous.yaml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/etudiants-boursiers` suivante](../api_particulier_v2_cnous_student_scholarship/france_connect_cnous.yml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "cnous"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "cnous_statut_boursier",
      "cnous_echelon_bourse",
      "cnous_email",
      "cnous_periode_versement",
      "cnous_statut_bourse",
      "cnous_ville_etudes",
      "cnous_identite"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Jean",
      "family_name": "MARTIN",
      "birthdate": "2001-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "jmartin_cnous"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer cnous" --url "https://staging.particulier.api.gouv.fr/v2/etudiants-boursiers?recipient=13002526500013"
  ```

  </p>
  </details>
* [cnous_with_less_scopes.yaml](cnous_with_less_scopes.yaml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/etudiants-boursiers` suivante](../api_particulier_v2_cnous_student_scholarship/france_connect_cnous_with_less_scopes.yml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "cnous_with_less_scopes"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "cnous_statut_boursier",
      "cnous_echelon_bourse",
      "cnous_email",
      "cnous_periode_versement",
      "cnous_statut_bourse",
      "cnous_ville_etudes"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Jean",
      "family_name": "MARTIN",
      "birthdate": "2001-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "jmartin_cnous_with_less_scopes"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer cnous_with_less_scopes" --url "https://staging.particulier.api.gouv.fr/v2/etudiants-boursiers?recipient=13002526500013"
  ```

  </p>
  </details>
* [mesri.yml](mesri.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse de [`/v2/etudiants` suivante](../api_particulier_v2_mesri_student_status/france_connect.yml)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "mesri"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "scope": [
      "openid",
      "identite_pivot",
      "mesri_identifiant",
      "mesri_identite",
      "mesri_inscription_etudiant",
      "mesri_inscription_autre",
      "mesri_admission",
      "mesri_etablissements",
      "mesri_admissions",
      "mesri_admission_inscrit",
      "mesri_admission_regime_formation",
      "mesri_admission_commune_etudes",
      "mesri_admission_etablissement_etudes"
    ],
    "client": {
      "client_id": "client_id",
      "client_name": "client_name"
    },
    "identity": {
      "given_name": "Jean",
      "family_name": "MESRI",
      "birthdate": "2002-01-01",
      "gender": "male",
      "birthplace": "75002",
      "birthcountry": "99100",
      "preferred_username": "jean_mesri"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer mesri" --url "https://staging.particulier.api.gouv.fr/v2/etudiants?recipient=13002526500013"
  ```

  </p>
  </details>
