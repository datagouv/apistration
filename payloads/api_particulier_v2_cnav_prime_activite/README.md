# Prime d'activité
* [200_beneficiaire_majoration.yaml](200_beneficiaire_majoration.yaml)

  Status `200`

  ## Bénéficiaire avec majoration

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTIN",
    "prenoms[]": [
      "SAMUEL"
    ],
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 9,
    "jourDateDeNaissance": 20,
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
    "majoration": true,
    "dateDebut": "1992-11-20",
    "dateFin": "1993-02-20"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=MARTIN' -d 'prenoms[][]=SAMUEL' -d 'anneeDateDeNaissance=1980' -d 'moisDateDeNaissance=9' -d 'jourDateDeNaissance=20' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/prime-activite"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_majoration.yaml](200_beneficiaire_sans_majoration.yaml)

  Status `200`

  ## Bénéficiaire sans majoration

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "GONTRAND",
    "prenoms[]": [
      "YVES"
    ],
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 9,
    "jourDateDeNaissance": 20,
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
    "majoration": false,
    "dateDebut": "1992-11-20",
    "dateFin": "1993-02-20"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=GONTRAND' -d 'prenoms[][]=YVES' -d 'anneeDateDeNaissance=1980' -d 'moisDateDeNaissance=9' -d 'jourDateDeNaissance=20' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/prime-activite"
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
    "nomNaissance": "LAGAFFE",
    "prenoms[]": [
      "GASTON"
    ],
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 9,
    "jourDateDeNaissance": 20,
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
    "majoration": null,
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
    -G -d 'nomNaissance=LAGAFFE' -d 'prenoms[][]=GASTON' -d 'anneeDateDeNaissance=1980' -d 'moisDateDeNaissance=9' -d 'jourDateDeNaissance=20' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/prime-activite"
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
    -G -d 'nomNaissance=DUBOCHE' -d 'prenoms[][]=JEROME' -d 'anneeDateDeNaissance=2002' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=5' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/prime-activite"
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
    -G -d 'codeInseeLieuDeNaissance=00503' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/prime-activite"
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
    "prenoms[]": [
      "Georges"
    ],
    "nomNaissance": "CNAF",
    "dateNaissance": "2002-01-01",
    "sexe": "M",
    "codeInseeLieuDeNaissance": "75002",
    "codePaysLieuDeNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire",
    "majoration": true,
    "dateDebut": "2021-05-05",
    "dateFin": "2021-08-05"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/prime-activite?recipient=13002526500013"
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
    "prenoms[]": [
      "Angela",
      "Claire",
      "Louise"
    ],
    "nomNaissance": "DUBOIS",
    "dateNaissance": "1962-08-24",
    "sexe": "F",
    "codeInseeLieuDeNaissance": "75107",
    "codePaysLieuDeNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire",
    "majoration": false,
    "dateDebut": "2023-02-01",
    "dateFin": "2023-05-01"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/prime-activite?recipient=13002526500013"
  ```

  </p>
  </details>
