# [FranceConnect] API Service national
* [200_en_regle.yaml](200_en_regle.yaml)

  Status `200`

  Personne en règle avec ses obligations via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "78516753564212"
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
      "commentaires": "Journée Défense et Citoyenneté effectuée le 15/06/2008"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [200_indetermine.yaml](200_indetermine.yaml)

  Status `200`

  Statut indéterminé via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "03038047150369"
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
      "commentaires": "Situation en cours de traitement"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [200_non_concerne.yaml](200_non_concerne.yaml)

  Status `200`

  Personne non concernée par les obligations via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "08607458113085"
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
      "commentaires": "Personne née avant 1978, non concernée par les obligations de service national"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [200_pas_en_regle.yaml](200_pas_en_regle.yaml)

  Status `200`

  Personne pas en règle avec ses obligations via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "02645955891635"
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
      "commentaires": "Journée Défense et Citoyenneté non effectuée. Convocation prévue le 12/09/2023"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [403_access_denied.yaml](403_access_denied.yaml)

  Status `403`

  Accès refusé - problème d'autorisation via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "86074581130863"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Personne non trouvée via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "30380471503680"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dsnj/service_national/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
