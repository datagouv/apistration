# Statut élève scolarisé et boursier
* [200.yaml](200.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Dubois",
    "prenom": "Camille",
    "sexe": "m",
    "date_naissance": "2000-01-20",
    "code_etablissement": "0890003V",
    "annee_scolaire": "2022"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "eleve": {
      "nom": "Dubois",
      "prenom": "Camille",
      "sexe": "F",
      "date_naissance": "2000-01-20"
    },
    "code_etablissement": "0890003V",
    "annee_scolaire": "2022-2023",
    "est_scolarise": true,
    "est_boursier": true,
    "status_eleve": {
      "code": "ST",
      "libelle": "Scolaire"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nom=Dubois' -d 'prenom=Camille' -d 'sexe=m' -d 'date_naissance=2000-01-20' -d 'code_etablissement=0890003V' -d 'annee_scolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [400.yaml](400.yaml)

  Status `400`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Dubois",
    "prenom": "Camille",
    "sexe": "not_valid",
    "date_naissance": "2000-01-20",
    "code_etablissement": "0890003V",
    "annee_scolaire": "2022"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "unprocessable_entity_error_gender_error",
    "reason": "Entité non traitable",
    "message": "Le sexe n'est pas correctement formaté (m ou f)"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nom=Dubois' -d 'prenom=Camille' -d 'sexe=not_valid' -d 'date_naissance=2000-01-20' -d 'code_etablissement=0890003V' -d 'annee_scolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Martin",
    "prenom": "Camille",
    "sexe": "f",
    "date_naissance": "2000-01-20",
    "code_etablissement": "0890003V",
    "annee_scolaire": "2022"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "not_found",
    "reason": "Student not found",
    "message": "Aucun étudiant n'a pu être trouvé avec les critères de recherche fournis"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nom=Martin' -d 'prenom=Camille' -d 'sexe=f' -d 'date_naissance=2000-01-20' -d 'code_etablissement=0890003V' -d 'annee_scolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [503.yaml](503.yaml)

  Status `503`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Depardieu",
    "prenom": "Francis",
    "sexe": "m",
    "date_naissance": "2000-01-20",
    "code_etablissement": "0890003V",
    "annee_scolaire": "2022"
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
    -G -d 'nom=Depardieu' -d 'prenom=Francis' -d 'sexe=m' -d 'date_naissance=2000-01-20' -d 'code_etablissement=0890003V' -d 'annee_scolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Faure",
    "prenom": "Felix",
    "sexe": "m",
    "date_naissance": "2000-01-20",
    "code_etablissement": "0890003V",
    "annee_scolaire": "2022"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "dummy",
    "reason": "dummy",
    "message": "dummy"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nom=Faure' -d 'prenom=Felix' -d 'sexe=m' -d 'date_naissance=2000-01-20' -d 'code_etablissement=0890003V' -d 'annee_scolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
