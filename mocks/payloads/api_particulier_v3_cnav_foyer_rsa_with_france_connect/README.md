# [FranceConnect] Composition du foyer RSA
* [404.yaml](404.yaml)

  Status `404`

  Dossier allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "jean martin"
    ],
    "anneeDateNaissance": 2006,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75101",
    "codeCogInseePaysNaissance": "99100"
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
        "code": "40402",
        "title": "Dossier non trouvé",
        "detail": "Le dossier allocataire n'a pas été trouvé auprès de la CNAV.",
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/foyer_rsa/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_cnaf.yaml](france_connect_cnaf.yaml)

  Status `200`

  Cas de test avec l'identité pivot FranceConnect par défaut du bac à sable
d'intégration (Angela DUBOIS).

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUBOIS",
    "prenoms": [
      "Angela",
      "Claire",
      "Louise"
    ],
    "anneeDateNaissance": 1962,
    "moisDateNaissance": 8,
    "jourDateNaissance": 24,
    "codeCogInseeCommuneNaissance": "75107",
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
    "data": {
      "beneficiaires": [
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": null,
          "prenoms": "Angela Claire Louise",
          "date_naissance": "1962-08-24",
          "sexe": "F",
          "qualite": "allocataire"
        }
      ],
      "personnes_a_charge": [
        {
          "nom_naissance": "DUBOIS",
          "nom_usage": null,
          "prenoms": "Loic Thierry Simon",
          "date_naissance": "2004-01-20",
          "sexe": "M"
        }
      ]
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/dss/foyer_rsa/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
