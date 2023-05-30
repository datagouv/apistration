# Statut élève scolarisé et boursier
* __Retour par défaut de l'API__

  Lors d'un appel avec des paramètres valides ne correspondant à aucun des examples dans ce dossier, l'API renvoie systématiquement cette réponse :


  <details><summary>Réponse par défault de l'API</summary>
  <p>

  ```json
  {
    "eleve": {
      "nom": "Martin",
      "prenom": "Justine",
      "sexe": "F",
      "date_naissance": "2000-01-20"
    },
    "code_etablissement": "0210015C",
    "annee_scolaire": "2022-2023",
    "est_scolarise": true,
    "est_boursier": true,
    "status_eleve": {
      "code": "ST",
      "libelle": "SCOLAIRE"
    }
  }
  ```

  </p>
  </details>

* [200.yaml](200.yaml)

  Status `200`

  Élève boursier

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Martin",
    "prenom": "Justine",
    "sexe": "f",
    "dateNaissance": "2000-01-20",
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "eleve": {
      "nom": "Martin",
      "prenom": "Justine",
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
    -G -d 'nom=Martin' -d 'prenom=Justine' -d 'sexe=f' -d 'dateNaissance=2000-01-20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [400.yaml](400.yaml)

  Status `400`

  Erreur de paramètre (sexe invalide)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Martin",
    "prenom": "Justine",
    "sexe": "not_valid",
    "dateNaissance": "2000-01-20",
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
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
    -G -d 'nom=Martin' -d 'prenom=Justine' -d 'sexe=not_valid' -d 'dateNaissance=2000-01-20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Élève non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Martin",
    "prenom": "Jerome",
    "sexe": "f",
    "dateNaissance": "2000-01-20",
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
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
    -G -d 'nom=Martin' -d 'prenom=Jerome' -d 'sexe=f' -d 'dateNaissance=2000-01-20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [503.yaml](503.yaml)

  Status `503`

  Timeout - délai d'attente dépassé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Depardieu",
    "prenom": "Francis",
    "sexe": "m",
    "dateNaissance": "2000-01-20",
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
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
    -G -d 'nom=Depardieu' -d 'prenom=Francis' -d 'sexe=m' -d 'dateNaissance=2000-01-20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  Erreur serveur

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nom": "Faure",
    "prenom": "Felix",
    "sexe": "m",
    "dateNaissance": "2000-01-20",
    "codeEtablissement": "0890003V",
    "anneeScolaire": "2022"
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
    -G -d 'nom=Faure' -d 'prenom=Felix' -d 'sexe=m' -d 'dateNaissance=2000-01-20' -d 'codeEtablissement=0890003V' -d 'anneeScolaire=2022' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/scolarites"
  ```

  </p>
  </details>
