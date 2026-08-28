# [Identité] Composition du foyer RSA
* [200-identite-cas-couple-sans-enfant.yaml](200-identite-cas-couple-sans-enfant.yaml)

  Status `200`

  Foyer RSA avec un couple allocataire/conjoint et aucune personne à charge

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Martin",
    "prenoms": [
      "alice"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 6,
    "jourDateNaissance": 15,
    "sexeEtatCivil": "F",
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
      "beneficiaires": [
        {
          "nom_naissance": "MARTIN",
          "nom_usage": null,
          "prenoms": "Alice",
          "date_naissance": "1985-06-15",
          "sexe": "F",
          "qualite": "allocataire"
        },
        {
          "nom_naissance": "PETIT",
          "nom_usage": "MARTIN",
          "prenoms": "Paul",
          "date_naissance": "1983-02-09",
          "sexe": "M",
          "qualite": "conjoint"
        }
      ],
      "personnes_a_charge": []
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Martin' -d 'prenoms[]=alice' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=F' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/foyer_rsa/identite"
  ```

  </p>
  </details>
* [200-identite-cas-nominal.yaml](200-identite-cas-nominal.yaml)

  Status `200`

  Foyer RSA avec un allocataire et une personne à charge

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Dupont",
    "prenoms": [
      "jean",
      "charlie"
    ],
    "anneeDateNaissance": 2008,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
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
      "beneficiaires": [
        {
          "nom_naissance": "DUPONT",
          "nom_usage": null,
          "prenoms": "Jean Charlie",
          "date_naissance": "2008-01-01",
          "sexe": "M",
          "qualite": "allocataire"
        }
      ],
      "personnes_a_charge": [
        {
          "nom_naissance": "DUPONT",
          "nom_usage": null,
          "prenoms": "Louna",
          "date_naissance": "2024-03-12",
          "sexe": "F"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Dupont' -d 'prenoms[]=jean' -d 'prenoms[]=charlie' -d 'anneeDateNaissance=2008' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/foyer_rsa/identite"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Dossier allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "Lefebvre",
    "prenoms": [
      "claire"
    ],
    "anneeDateNaissance": 2008,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "sexeEtatCivil": "M",
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=Lefebvre' -d 'prenoms[]=claire' -d 'anneeDateNaissance=2008' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'sexeEtatCivil=M' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/foyer_rsa/identite"
  ```

  </p>
  </details>
