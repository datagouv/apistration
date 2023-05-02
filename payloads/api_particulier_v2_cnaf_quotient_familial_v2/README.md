# Quotient familial CAF & MSA
* [200.yaml](200.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codePaysLieuDeNaissance": "99100",
    "sexe": "M",
    "nomUsage": "JACQUES",
    "prenoms": [
      "JEAN-PIERRE",
      "THOMAS"
    ],
    "anneeDateDeNaissance": 2000,
    "moisDateDeNaissance": 1
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
        "anneeDateDeNaissance": "1937",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "27",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "JACQUES",
        "nomUsage": "JACQUES",
        "prenoms": "TRISTAN HENRI",
        "anneeDateDeNaissance": "1970",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur JEAN-PIERRE JACQUES",
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
    -G -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' -d 'nomUsage=JACQUES' -d 'prenoms[]=JEAN-PIERRE' -d 'prenoms[]=THOMAS' -d 'anneeDateDeNaissance=2000' -d 'moisDateDeNaissance=1' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
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
    "sexe": "F"
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
    -G -d 'codePaysLieuDeNaissance=99404' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
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
    "sexe": "F"
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
    -G -d 'codePaysLieuDeNaissance=99500' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
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
    "sexe": "F"
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
    -G -d 'codePaysLieuDeNaissance=99503' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
