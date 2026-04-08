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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot revenu_solidarite_active revenu_solidarite_active_majoration prime_activite prime_activite_majoration allocation_soutien_familial allocation_adulte_handicape complementaire_sante_solidaire cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse eaje_allocataires eaje_enfants eaje_adresse eaje_parametres_calcul_participation_familial cnous_statut_boursier cnous_echelon_bourse cnous_email cnous_periode_versement cnous_statut_bourse cnous_ville_etudes cnous_identite mesri_identifiant mesri_identite mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements mesri_admissions mesri_admission_inscrit mesri_admission_regime_formation mesri_admission_commune_etudes mesri_admission_etablissement_etudes dsnj_statut_service_national ants_extrait_immatriculation_vehicule_identite_particulier ants_extrait_immatriculation_vehicule_adresse_particulier ants_extrait_immatriculation_vehicule_statut_rattachement ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule gip_mds_service_civique_statut_actuel gip_mds_service_civique_statut_passe gip_mds_service_civique_organisme_accueil gip_mds_service_civique_dates",
      "gender": "male",
      "family_name": "Delatour",
      "given_name": "Thomas",
      "given_name_array": [
        "Thomas"
      ],
      "birthdate": "1994-04-16",
      "birthplace": "75111",
      "birthcountry": "99100"
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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot ants_extrait_immatriculation_vehicule_identite_particulier ants_extrait_immatriculation_vehicule_adresse_particulier ants_extrait_immatriculation_vehicule_statut_rattachement ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule",
      "gender": "male",
      "family_name": "Delatour",
      "given_name": "Thomas",
      "given_name_array": [
        "Thomas"
      ],
      "birthdate": "1994-04-16",
      "birthplace": "75111",
      "birthcountry": "99100"
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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot complementaire_sante_solidaire",
      "gender": "male",
      "family_name": "CNAF",
      "given_name": "Georges",
      "given_name_array": [
        "Georges"
      ],
      "birthdate": "2002-01-01",
      "birthplace": "75002",
      "birthcountry": "99100"
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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse",
      "gender": "male",
      "family_name": "CNAF",
      "given_name": "Georges",
      "given_name_array": [
        "Georges"
      ],
      "birthdate": "2002-01-01",
      "birthplace": "75002",
      "birthcountry": "99100"
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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse",
      "gender": "male",
      "family_name": "CNAF",
      "given_name": "Georges",
      "given_name_array": [
        "Georges"
      ],
      "birthdate": "2002-01-01",
      "birthplace": "75002",
      "birthcountry": "99100"
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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot cnous_statut_boursier cnous_echelon_bourse cnous_email cnous_periode_versement cnous_statut_bourse cnous_ville_etudes cnous_identite",
      "gender": "male",
      "family_name": "MARTIN",
      "given_name": "Jean",
      "given_name_array": [
        "Jean"
      ],
      "birthdate": "2001-01-01",
      "birthplace": "75002",
      "birthcountry": "99100"
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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot cnous_statut_boursier cnous_echelon_bourse cnous_email cnous_periode_versement cnous_statut_bourse cnous_ville_etudes",
      "gender": "male",
      "family_name": "MARTIN",
      "given_name": "Jean",
      "given_name_array": [
        "Jean"
      ],
      "birthdate": "2001-01-01",
      "birthplace": "75002",
      "birthcountry": "99100"
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
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot mesri_identifiant mesri_identite mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements mesri_admissions mesri_admission_inscrit mesri_admission_regime_formation mesri_admission_commune_etudes mesri_admission_etablissement_etudes",
      "gender": "male",
      "family_name": "MESRI",
      "given_name": "Jean",
      "given_name_array": [
        "Jean"
      ],
      "birthdate": "2002-01-01",
      "birthplace": "75002",
      "birthcountry": "99100"
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
* [service_civique.yml](service_civique.yml)

  Status `200`

  Réponse FranceConnect permettant de déclencher la réponse des endpoints Service Civique

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "token": "service_civique"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "aud": "423dcbdc5a15ece61ed00ff5989d72379c26d9ed4c8e4e05a87cffae019586e0",
    "iat": 1704965332,
    "iss": "https://fcp-low.integ01.dev-franceconnect.fr/api/v2",
    "token_introspection": {
      "active": true,
      "aud": "6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950",
      "sub": "2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1",
      "iat": 1704965328,
      "exp": 1704965388,
      "acr": "eidas1",
      "jti": "Wn5igB6_frAVBXQgShzI0znLE3fid2cWZHR9TWtqxZM",
      "scope": "openid identite_pivot gip_mds_service_civique_statut_actuel gip_mds_service_civique_statut_passe gip_mds_service_civique_organisme_accueil gip_mds_service_civique_dates",
      "gender": "male",
      "family_name": "Service Civique",
      "given_name": "Jean",
      "given_name_array": [
        "Jean"
      ],
      "birthdate": "2002-01-01",
      "birthplace": "75002",
      "birthcountry": "99100"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer service_civique" --url "https://staging.particulier.api.gouv.fr/v2/service-civique?recipient=13002526500013"
  ```

  </p>
  </details>
