# Allocation de Soutien Familial
* [200_beneficiaire.yaml](200_beneficiaire.yaml)

  Status `200`

  ## Bénéficiaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "LALANNE",
    "prenoms[]": [
      "FRANCIS",
      "GERARD"
    ],
    "anneeDateDeNaissance": 2002,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "M"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire",
    "dateDebut": "1992-11-29",
    "dateFin": "1993-11-29"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=LALANNE' -d 'prenoms[][]=FRANCIS' -d 'prenoms[][]=GERARD' -d 'anneeDateDeNaissance=2002' -d 'moisDateDeNaissance=11' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/allocation-soutien-familial"
  ```

  </p>
  </details>
* [200_non_beneficiaire.yaml](200_non_beneficiaire.yaml)

  Status `200`

  ## Non bénéficiaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "DEPARDIEU",
    "nomNaissance": "BERGERAC",
    "prenoms[]": [
      "CYRANO"
    ],
    "anneeDateDeNaissance": 2002,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "M"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "non_beneficiaire",
    "dateDebut": null,
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=DEPARDIEU' -d 'nomNaissance=BERGERAC' -d 'prenoms[][]=CYRANO' -d 'anneeDateDeNaissance=2002' -d 'moisDateDeNaissance=11' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/allocation-soutien-familial"
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
    "recipient": "13002526500013",
    "nomNaissance": "DUBOCHE",
    "prenoms[]": [
      "JEROME"
    ],
    "anneeDateDeNaissance": 2002,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 5,
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "M"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUBOCHE' -d 'prenoms[][]=JEROME' -d 'anneeDateDeNaissance=2002' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=5' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/allocation-soutien-familial"
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
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "00503",
    "codePaysLieuDeNaissance": "99100",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=00503' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/allocation-soutien-familial"
  ```

  </p>
  </details>
* [fake_france_connect_cnaf.yml](fake_france_connect_cnaf.yml)

  Status `200`

  Cas de test avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/cnaf_css.yml).
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "given_name": "Georges",
    "family_name": "CNAF",
    "birthdate": "2002-01-01",
    "gender": "male",
    "birthplace": "75002",
    "birthcountry": "99100",
    "preferred_username": "MARTIN"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire",
    "dateDebut": "2021-05-05",
    "dateFin": "2022-05-05"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/allocation-soutien-familial?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_cnaf.yaml](france_connect_cnaf.yaml)

  Status `200`

  Cas de test avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "given_name": "Angela",
    "family_name": "DUBOIS",
    "birthdate": "1962-08-24",
    "gender": "female",
    "birthplace": "75107",
    "birthcountry": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire",
    "dateDebut": "2023-02-01",
    "dateFin": "2023-02-01"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/allocation-soutien-familial?recipient=13002526500013"
  ```

  </p>
  </details>
