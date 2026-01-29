# [FranceConnect] Statut service civique
* [200-volontaire-actif-et-passe.yaml](200-volontaire-actif-et-passe.yaml)

  Status `200`

  ## VOLONTAIRE AVEC CONTRAT ACTIF ET PASSÉ

Ce cas représente une personne ayant effectué un premier service civique
par le passé et actuellement engagée dans un second service civique.
Identité FranceConnect: Lucie PLACARD.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Lucie"
    ],
    "nomNaissance": "PLACARD",
    "anneeDateNaissance": 1987,
    "moisDateNaissance": 4,
    "jourDateNaissance": 13
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_actuel": {
        "contrat_trouve": true,
        "organisme_accueil": {
          "siret": "18009202500059",
          "raison_sociale": "MINISTERE DE L EDUCATION NATIONALE"
        },
        "date_debut_contrat": "2024-10-01",
        "date_fin_contrat": "2025-07-31"
      },
      "statut_passe": {
        "contrat_trouve": true,
        "organisme_accueil": {
          "siret": "42229566900026",
          "raison_sociale": "UNIS CITE"
        },
        "date_debut_contrat": "2021-03-15",
        "date_fin_contrat": "2021-11-14"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [200-volontaire-actif.yaml](200-volontaire-actif.yaml)

  Status `200`

  ## VOLONTAIRE EN SERVICE CIVIQUE ACTIF

Ce cas représente une personne actuellement engagée dans un service civique.
Le contrat est en cours auprès de la DINUM.
Identité FranceConnect: Angela DUBOIS.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Angela",
      "Claire",
      "Louise"
    ],
    "nomNaissance": "DUBOIS",
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
      "statut_actuel": {
        "contrat_trouve": true,
        "organisme_accueil": {
          "siret": "13002526500013",
          "raison_sociale": "DIRECTION INTERMINISTERIELLE DU NUMERIQUE"
        },
        "date_debut_contrat": "2024-09-01",
        "date_fin_contrat": "2025-06-30"
      },
      "statut_passe": {
        "contrat_trouve": false,
        "organisme_accueil": {
          "siret": null,
          "raison_sociale": null
        },
        "date_debut_contrat": null,
        "date_fin_contrat": null
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [200-volontaire-passe.yaml](200-volontaire-passe.yaml)

  Status `200`

  ## ANCIEN VOLONTAIRE SERVICE CIVIQUE

Ce cas représente une personne ayant effectué un service civique par le passé.
Le contrat est terminé, la personne n'a pas de contrat actif.
Identité FranceConnect: Jean MERCIER.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Jean"
    ],
    "nomNaissance": "MERCIER",
    "anneeDateNaissance": 1969,
    "moisDateNaissance": 3,
    "jourDateNaissance": 17
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_actuel": {
        "contrat_trouve": false,
        "organisme_accueil": {
          "siret": null,
          "raison_sociale": null
        },
        "date_debut_contrat": null,
        "date_fin_contrat": null
      },
      "statut_passe": {
        "contrat_trouve": true,
        "organisme_accueil": {
          "siret": "77567227221138",
          "raison_sociale": "CROIX ROUGE FRANCAISE"
        },
        "date_debut_contrat": "2022-01-10",
        "date_fin_contrat": "2022-09-09"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [200-volontaire-sans-contrat.yaml](200-volontaire-sans-contrat.yaml)

  Status `200`

  ## PERSONNE SANS CONTRAT SERVICE CIVIQUE

Ce cas représente une personne connue du système mais qui n'a jamais
effectué de service civique (ni actif, ni passé).
Identité FranceConnect: Marie COMMODE.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Marie"
    ],
    "nomNaissance": "COMMODE",
    "anneeDateNaissance": 1980,
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
      "statut_actuel": {
        "contrat_trouve": false,
        "organisme_accueil": {
          "siret": null,
          "raison_sociale": null
        },
        "date_debut_contrat": null,
        "date_fin_contrat": null
      },
      "statut_passe": {
        "contrat_trouve": false,
        "organisme_accueil": {
          "siret": null,
          "raison_sociale": null
        },
        "date_debut_contrat": null,
        "date_fin_contrat": null
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Personne non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Inconnu"
    ],
    "nomNaissance": "LEFEBVRE",
    "anneeDateNaissance": 1990,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1
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
        "code": "31003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "GIP-MDS"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_all_fc.yaml](fake_france_connect_all_fc.yaml)

  Status `200`

  ## VOLONTAIRE EN SERVICE CIVIQUE ACTIF (Token all_fc)

Ce cas représente une personne actuellement engagée dans un service civique.
Le contrat est en cours auprès de la DINUM.
Identité FranceConnect: Thomas DELATOUR (token all_fc).

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Thomas"
    ],
    "nomNaissance": "Delatour",
    "anneeDateNaissance": 1994,
    "moisDateNaissance": 4,
    "jourDateNaissance": 16
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_actuel": {
        "contrat_trouve": true,
        "organisme_accueil": {
          "siret": "13002526500013",
          "raison_sociale": "DIRECTION INTERMINISTERIELLE DU NUMERIQUE"
        },
        "date_debut_contrat": "2024-09-01",
        "date_fin_contrat": "2025-06-30"
      },
      "statut_passe": {
        "contrat_trouve": false,
        "organisme_accueil": {
          "siret": null,
          "raison_sociale": null
        },
        "date_debut_contrat": null,
        "date_fin_contrat": null
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_service_civique.yaml](fake_france_connect_service_civique.yaml)

  Status `200`

  ## VOLONTAIRE EN SERVICE CIVIQUE ACTIF (Token service_civique)

Ce cas représente une personne actuellement engagée dans un service civique.
Le contrat est en cours auprès de la DINUM.
Identité FranceConnect: Jean SERVICE CIVIQUE (token service_civique).

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Jean"
    ],
    "nomNaissance": "Service Civique",
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 1,
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
      "statut_actuel": {
        "contrat_trouve": true,
        "organisme_accueil": {
          "siret": "13002526500013",
          "raison_sociale": "DIRECTION INTERMINISTERIELLE DU NUMERIQUE"
        },
        "date_debut_contrat": "2024-09-01",
        "date_fin_contrat": "2025-06-30"
      },
      "statut_passe": {
        "contrat_trouve": false,
        "organisme_accueil": {
          "siret": null,
          "raison_sociale": null
        },
        "date_debut_contrat": null,
        "date_fin_contrat": null
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_service_civique.yaml](france_connect_service_civique.yaml)

  Status `200`

  ## VOLONTAIRE EN SERVICE CIVIQUE ACTIF (FranceConnect)

Ce cas représente une personne actuellement engagée dans un service civique.
Le contrat est en cours auprès de la DINUM.
Identité FranceConnect: Angela DUBOIS.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Angela",
      "Claire",
      "Louise"
    ],
    "nomNaissance": "DUBOIS",
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
      "statut_actuel": {
        "contrat_trouve": true,
        "organisme_accueil": {
          "siret": "13002526500013",
          "raison_sociale": "DIRECTION INTERMINISTERIELLE DU NUMERIQUE"
        },
        "date_debut_contrat": "2024-09-01",
        "date_fin_contrat": "2025-06-30"
      },
      "statut_passe": {
        "contrat_trouve": false,
        "organisme_accueil": {
          "siret": null,
          "raison_sociale": null
        },
        "date_debut_contrat": null,
        "date_fin_contrat": null
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
