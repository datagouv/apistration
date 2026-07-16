# [FranceConnect] Statut allocation de rentrée scolaire (ARS)
* [200_allocataire.yaml](200_allocataire.yaml)

  Status `200`

  Ce cas permet de tester un appel à partir notamment des données de l'identité pivot France Connect.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MERCIER",
    "prenoms": [
      "PIERRE"
    ],
    "anneeDateNaissance": 1969,
    "moisDateNaissance": 3,
    "jourDateNaissance": 17,
    "codeCogInseeCommuneNaissance": "95277",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "status": "allocataire",
      "date_debut_droit": "2024-08-09"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_rentree_scolaire/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  ## Allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "LEROY",
    "prenoms": [
      "CLAUDE"
    ],
    "anneeDateNaissance": 1965,
    "moisDateNaissance": 9,
    "jourDateNaissance": 2,
    "codeCogInseeCommuneNaissance": "33063",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F"
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
        "code": "37003",
        "title": "Entité non trouvée",
        "detail": "Dossier allocataire inexistant. Le document ne peut être édité.",
        "source": null,
        "meta": {
          "provider": "CNAV"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_rentree_scolaire/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_all_fc.yaml](fake_france_connect_all_fc.yaml)

  Status `200`

  Cas de test avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/all_fc.yml).
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

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
    "jourDateNaissance": 16,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75111",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "status": "allocataire",
      "date_debut_droit": "2024-08-09"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_rentree_scolaire/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
