# [Identité] Statut service civique
* [200-volontaire-actif.yaml](200-volontaire-actif.yaml)

  Status `200`

  ## VOLONTAIRE EN SERVICE CIVIQUE ACTIF

Ce cas représente une personne actuellement engagée dans un service civique.
La mission est en cours auprès de la DINUM.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "MARIE",
      "LOUISE"
    ],
    "anneeDateNaissance": 1998,
    "moisDateNaissance": 3,
    "jourDateNaissance": 15
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "organisme_accueil": {
        "siret": "13002526500013"
      },
      "dates": {
        "debut": "2025-09-01",
        "fin": null,
        "en_cours": true
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=MARIE' -d 'prenoms[]=LOUISE' -d 'anneeDateNaissance=1998' -d 'moisDateNaissance=3' -d 'jourDateNaissance=15' \
    --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/identite"
  ```

  </p>
  </details>
* [200-volontaire-passe.yaml](200-volontaire-passe.yaml)

  Status `200`

  ## ANCIEN VOLONTAIRE SERVICE CIVIQUE

Ce cas représente une personne ayant effectué un service civique par le passé.
La mission est terminée.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTIN",
    "prenoms": [
      "JEAN",
      "PIERRE"
    ],
    "anneeDateNaissance": 1995,
    "moisDateNaissance": 7,
    "jourDateNaissance": 22
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "organisme_accueil": {
        "siret": "77567227221138"
      },
      "dates": {
        "debut": "2022-01-10",
        "fin": "2022-09-09",
        "en_cours": false
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTIN' -d 'prenoms[]=JEAN' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1995' -d 'moisDateNaissance=7' -d 'jourDateNaissance=22' \
    --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/identite"
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
    "nomNaissance": "INCONNU",
    "prenoms": [
      "PERSONNE"
    ],
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=INCONNU' -d 'prenoms[]=PERSONNE' -d 'anneeDateNaissance=1990' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' \
    --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/identite"
  ```

  </p>
  </details>
* [422.yaml](422.yaml)

  Status `422`

  Identité ambiguë - correspond à plusieurs personnes

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DURAND",
    "prenoms": [
      "JEAN"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 6,
    "jourDateNaissance": 15
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
        "code": "31563",
        "title": "Identité ambiguë pour le fournisseur de données",
        "detail": "Les paramètres d'identité fournis correspondent à plusieurs personnes chez le fournisseur de données.",
        "source": null,
        "meta": {}
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DURAND' -d 'prenoms[]=JEAN' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' \
    --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/identite"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  Erreur du fournisseur GIP-MDS

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "ERREUR",
    "prenoms": [
      "FOURNISSEUR"
    ],
    "anneeDateNaissance": 1992,
    "moisDateNaissance": 2,
    "jourDateNaissance": 2
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
        "code": "31999",
        "title": "Erreur inconnue du fournisseur de données",
        "detail": "La réponse retournée par le fournisseur de données est invalide et inconnue de notre service. L'équipe technique a été notifiée de cette erreur pour investigation.",
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=ERREUR' -d 'prenoms[]=FOURNISSEUR' -d 'anneeDateNaissance=1992' -d 'moisDateNaissance=2' -d 'jourDateNaissance=2' \
    --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/identite"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  Timeout du fournisseur GIP-MDS

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "TIMEOUT",
    "prenoms": [
      "SERVEUR"
    ],
    "anneeDateNaissance": 1993,
    "moisDateNaissance": 3,
    "jourDateNaissance": 3
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
        "code": "31002",
        "title": "Intermédiaire hors-délai",
        "detail": "Temps d'attente d'une réponse du fournisseur de données écoulé.",
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=TIMEOUT' -d 'prenoms[]=SERVEUR' -d 'anneeDateNaissance=1993' -d 'moisDateNaissance=3' -d 'jourDateNaissance=3' \
    --url "https://staging.particulier.api.gouv.fr/v3/gip_mds/service_civique/identite"
  ```

  </p>
  </details>
