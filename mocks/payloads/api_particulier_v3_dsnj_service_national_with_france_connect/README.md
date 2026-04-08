# [FranceConnect] API Service national
* [404.yaml](404.yaml)

  Status `404`

  Personne non trouvée via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "NOEL"
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
* [fake_france_connect_service_national.yaml](fake_france_connect_service_national.yaml)

  Status `200`

  FranceConnect: Boursier échelon 5 (scope complet)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Delatour",
    "prenoms": [
      "Thomas"
    ],
    "anneeDateNaissance": 1994,
    "moisDateNaissance": 4,
    "jourDateNaissance": 16,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "75111"
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
* [france_connect_service_national_moins_25ans.yaml](france_connect_service_national_moins_25ans.yaml)

  Status `200`

  Personne de moins de 25 ans en règle avec ses obligations via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "CUILLERE",
    "prenoms": [
      "Paul"
    ],
    "anneeDateNaissance": 2007,
    "moisDateNaissance": 1,
    "jourDateNaissance": 23,
    "sexeEtatCivil": "M",
    "codeCogInseePaysNaissance": "99100",
    "codeCogInseeCommuneNaissance": "42218"
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
      "commentaires": "Journée Défense et Citoyenneté effectuée le 15/06/2025"
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
