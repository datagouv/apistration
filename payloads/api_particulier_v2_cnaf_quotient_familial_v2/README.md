# Quotient familial MSA x CNAF
* [200.yaml](200.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codePaysLieuDeNaissance": "99100",
    "genre": "M",
    "nomUsage": "JACQUES",
    "prenoms": [
      "JEAN-PIERRE",
      "THOMAS"
    ],
    "anneeDateDeNaissance": "2000",
    "moisDateDeNaissance": "01"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "regime": "MSA",
    "allocataires": [
      {
        "nomNaissance": "JACQUES",
        "nomUsage": "JACQUES",
        "prenoms": "JEAN-PIERRE THOMAS",
        "anneeDateDeNaissance": "2000",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "31",
        "genre": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "JACQUES",
        "nomUsage": "JACQUES",
        "prenoms": "JEAN-PIERRE THOMAS",
        "anneeDateDeNaissance": "2000",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "31",
        "genre": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur JEAN JACQUES",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE DE LA GARE",
      "lieuDit": null,
      "codePostalVille": "75002",
      "pays": "FRANCE"
    },
    "quotientFamilial": 1045,
    "annee": 2021,
    "mois": 6
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codePaysLieuDeNaissance=99100' -d 'genre=M' -d 'nomUsage=JACQUES' -d 'prenoms=%5B%22JEAN-PIERRE%22%2C+%22THOMAS%22%5D' -d 'anneeDateDeNaissance=2000' -d 'moisDateDeNaissance=01' \
    --url "https://staging.particulier.api.gouv.fr/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codePaysLieuDeNaissance": "99404",
    "genre": "F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "not_found",
    "reason": "Dossier allocataire inexistant. Le document ne peut être édité.",
    "message": "Dossier allocataire inexistant. Le document ne peut être édité."
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codePaysLieuDeNaissance=99404' -d 'genre=F' \
    --url "https://staging.particulier.api.gouv.fr/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [500.yaml](500.yaml)

  Status `500`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codePaysLieuDeNaissance": "99500",
    "genre": "F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "error",
    "reason": "Internal server error",
    "message": "Une erreur interne s'est produite, l'équipe a été prévenue."
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codePaysLieuDeNaissance=99500' -d 'genre=F' \
    --url "https://staging.particulier.api.gouv.fr/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [503.yaml](503.yaml)

  Status `503`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codePaysLieuDeNaissance": "99503",
    "genre": "F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "network_error",
    "reason": "timeout of 10000 ms exceeded",
    "message": "Une erreur est survenue lors de l'appel au fournisseur de donnée"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codePaysLieuDeNaissance=99503' -d 'genre=F' \
    --url "https://staging.particulier.api.gouv.fr/v2/composition-familiale-v2"
  ```

  </p>
  </details>
