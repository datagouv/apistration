# Quotient familial CAF
* [200.yaml](200.yaml)

  Status `200`

  Couple avec deux enfants (2022)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroAllocataire": 1234567,
    "codePostal": 75001
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "quotientFamilial": 1234,
    "mois": 7,
    "annee": 2022,
    "allocataires": [
      {
        "nomPrenom": "MARIE DUPONT",
        "dateDeNaissance": "01031988",
        "sexe": "F"
      },
      {
        "nomPrenom": "JEAN DUPONT",
        "dateDeNaissance": "01041990",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomPrenom": "JACQUES DUPONT",
        "dateDeNaissance": "01012010",
        "sexe": "M"
      },
      {
        "nomPrenom": "JEANNE DUPONT",
        "dateDeNaissance": "01022012",
        "sexe": "F"
      }
    ],
    "adresse": {
      "identite": "Monsieur JEAN DUPONT",
      "complementIdentite": "APPARTEMENT 51",
      "complementIdentiteGeo": "RESIDENCE DES COLOMBES",
      "numeroRue": "42 RUE DE LA PAIX",
      "lieuDit": "ILOTS DES OISEAUX",
      "codePostalVille": "75002 PARIS",
      "pays": "FRANCE"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'numeroAllocataire=1234567' -d 'codePostal=75001' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Dossier non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroAllocataire": 1234567,
    "codePostal": 33404
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
    -G -d 'numeroAllocataire=1234567' -d 'codePostal=33404' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale"
  ```

  </p>
  </details>
* [500.yaml](500.yaml)

  Status `500`

  Erreur interne du serveur

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroAllocataire": 1234567,
    "codePostal": 33500
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
    -G -d 'numeroAllocataire=1234567' -d 'codePostal=33500' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale"
  ```

  </p>
  </details>
* [503.yaml](503.yaml)

  Status `503`

  Erreur inconnue du fournisseur de données

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroAllocataire": 1234567,
    "codePostal": 33503
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "data_provider_error",
    "reason": "Unknown error code 134",
    "message": "Erreur inconnue du fournisseur de donnée CAF"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'numeroAllocataire=1234567' -d 'codePostal=33503' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale"
  ```

  </p>
  </details>
