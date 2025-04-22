# [Identité] API Service National
* [200_en_regle.yaml](200_en_regle.yaml)

  Status `200`

  Personne en règle avec ses obligations

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "78516753564212",
    "nomNaissance": "MARTIN",
    "prenoms[]": [
      "JEAN",
      "MICHEL"
    ],
    "anneeDateNaissance": 1990,
    "moisDateNaissance": 1,
    "jourDateNaissance": 15,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "75056"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_service_national": "en_regle",
      "commmentaires": "Journée Défense et Citoyenneté effectuée le 15/06/2008"
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
    -G -d 'recipient=13002526500013' -d 'recipient=78516753564212' -d 'nomNaissance=MARTIN' -d 'prenoms[][]=JEAN' -d 'prenoms[][]=MICHEL' -d 'anneeDateNaissance=1990' -d 'moisDateNaissance=1' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=75056' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [200_indetermine.yaml](200_indetermine.yaml)

  Status `200`

  Statut indéterminé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "30380471503681",
    "nomNaissance": "PETIT",
    "prenoms[]": [
      "MARIE",
      "CLARA"
    ],
    "anneeDateNaissance": 1992,
    "moisDateNaissance": 11,
    "jourDateNaissance": 8,
    "sexeEtatCivil": "F",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "13055"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_service_national": "indetermine",
      "commmentaires": "Situation en cours de traitement"
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
    -G -d 'recipient=13002526500013' -d 'recipient=30380471503681' -d 'nomNaissance=PETIT' -d 'prenoms[][]=MARIE' -d 'prenoms[][]=CLARA' -d 'anneeDateNaissance=1992' -d 'moisDateNaissance=11' -d 'jourDateNaissance=8' -d 'sexeEtatCivil=F' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=13055' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [200_non_concerne.yaml](200_non_concerne.yaml)

  Status `200`

  Personne non concernée par les obligations

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "86074581130864",
    "nomNaissance": "RICHARD",
    "prenoms[]": [
      "SOPHIE"
    ],
    "anneeDateNaissance": 1971,
    "moisDateNaissance": 3,
    "jourDateNaissance": 29,
    "sexeEtatCivil": "F",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "33063"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_service_national": "non_concerne",
      "commmentaires": "Personne née avant 1978, non concernée par les obligations de service national"
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
    -G -d 'recipient=13002526500013' -d 'recipient=86074581130864' -d 'nomNaissance=RICHARD' -d 'prenoms[][]=SOPHIE' -d 'anneeDateNaissance=1971' -d 'moisDateNaissance=3' -d 'jourDateNaissance=29' -d 'sexeEtatCivil=F' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=33063' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [200_pas_en_regle.yaml](200_pas_en_regle.yaml)

  Status `200`

  Personne pas en règle avec ses obligations

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "26459558916366",
    "nomNaissance": "DUBOIS",
    "prenoms[]": [
      "THOMAS"
    ],
    "anneeDateNaissance": 1995,
    "moisDateNaissance": 6,
    "jourDateNaissance": 22,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "69123"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "statut_service_national": "pas_en_regle",
      "commmentaires": "Journée Défense et Citoyenneté non effectuée. Convocation prévue le 12/09/2023"
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
    -G -d 'recipient=13002526500013' -d 'recipient=26459558916366' -d 'nomNaissance=DUBOIS' -d 'prenoms[][]=THOMAS' -d 'anneeDateNaissance=1995' -d 'moisDateNaissance=6' -d 'jourDateNaissance=22' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=69123' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [403_access_denied.yaml](403_access_denied.yaml)

  Status `403`

  Accès refusé - problème d'autorisation

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "26459558916365",
    "nomNaissance": "LEROY",
    "prenoms[]": [
      "ANTOINE"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 4,
    "jourDateNaissance": 5,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "69123"
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
        "code": "39001",
        "title": "Accès refusé",
        "detail": "Le SIRET n'est pas autorisé à accéder à l'API",
        "source": null,
        "meta": {
          "provider": "DSNJ"
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
    -G -d 'recipient=13002526500013' -d 'recipient=26459558916365' -d 'nomNaissance=LEROY' -d 'prenoms[][]=ANTOINE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=4' -d 'jourDateNaissance=5' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=69123' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [404_not_found.yaml](404_not_found.yaml)

  Status `404`

  Personne non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "78516753564212",
    "nomNaissance": "INCONNU",
    "prenoms[]": [
      "PERSONNAGE"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "75056"
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
        "code": "39003",
        "title": "Entité non trouvée",
        "detail": "Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que l'identifiant correspond au périmètre couvert par l'API.",
        "source": null,
        "meta": {
          "provider": "DSNJ"
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
    -G -d 'recipient=13002526500013' -d 'recipient=78516753564212' -d 'nomNaissance=INCONNU' -d 'prenoms[][]=PERSONNAGE' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=75056' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [429_quota_exceeded.yaml](429_quota_exceeded.yaml)

  Status `429`

  Trop de requêtes - quota dépassé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "86074581130863",
    "nomNaissance": "DUPONT",
    "prenoms[]": [
      "PIERRE"
    ],
    "anneeDateNaissance": 1992,
    "moisDateNaissance": 7,
    "jourDateNaissance": 14,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "35238"
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
        "code": "39004",
        "title": "Quota dépassé",
        "detail": "Le quota de requêtes autorisées a été dépassé. Veuillez réessayer plus tard.",
        "source": null,
        "meta": {
          "provider": "DSNJ"
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
    -G -d 'recipient=13002526500013' -d 'recipient=86074581130863' -d 'nomNaissance=DUPONT' -d 'prenoms[][]=PIERRE' -d 'anneeDateNaissance=1992' -d 'moisDateNaissance=7' -d 'jourDateNaissance=14' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=35238' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [502_bad_gateway.yaml](502_bad_gateway.yaml)

  Status `502`

  Erreur serveur - mauvaise passerelle

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "78516753564212",
    "nomNaissance": "DURAND",
    "prenoms[]": [
      "PAUL"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 8,
    "jourDateNaissance": 10,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "75056"
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
        "code": "39002",
        "title": "Erreur serveur",
        "detail": "Une erreur est survenue lors de la connexion au service distant.",
        "source": null,
        "meta": {
          "provider": "DSNJ"
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
    -G -d 'recipient=13002526500013' -d 'recipient=78516753564212' -d 'nomNaissance=DURAND' -d 'prenoms[][]=PAUL' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=8' -d 'jourDateNaissance=10' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=75056' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
* [504_gateway_timeout.yaml](504_gateway_timeout.yaml)

  Status `504`

  Temps d'attente dépassé - gateway timeout

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "26459558916365",
    "nomNaissance": "BERNARD",
    "prenoms[]": [
      "JULIEN"
    ],
    "anneeDateNaissance": 1988,
    "moisDateNaissance": 5,
    "jourDateNaissance": 20,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "92012"
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
        "code": "39005",
        "title": "Temps d'attente dépassé",
        "detail": "Le service distant n'a pas répondu dans le temps imparti.",
        "source": null,
        "meta": {
          "provider": "DSNJ"
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
    -G -d 'recipient=13002526500013' -d 'recipient=26459558916365' -d 'nomNaissance=BERNARD' -d 'prenoms[][]=JULIEN' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=5' -d 'jourDateNaissance=20' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' -d 'codeCogInseeCommuneNaissance=92012' \
    --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/identite"
  ```

  </p>
  </details>
