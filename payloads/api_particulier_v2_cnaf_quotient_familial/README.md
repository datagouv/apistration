# Informations concernant la famille
* [200.yaml](200.yaml)

  Status `200`

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
