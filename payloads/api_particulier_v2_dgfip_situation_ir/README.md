# Service de vérification de l'avis d'impôt sur le revenu
* __Retour par défaut de l'API__

  Lors d'un appel avec des paramètres valides ne correspondant à aucun des examples dans ce dossier, l'API renvoie systématiquement cette réponse :


  <details><summary>Réponse par défault de l'API</summary>
  <p>

  ```json
  {
    "declarant1": {
      "nom": "MARTIN",
      "nomNaissance": "MARTIN",
      "prenoms": "JEAN"
    },
    "declarant2": {
      "nom": "MARTIN",
      "nomNaissance": "MARTIN",
      "prenoms": "JEAN"
    },
    "foyerFiscal": {
      "adresse": "21 RUE DES MARMOTS 75001 PARIS",
      "annee": 2022
    },
    "dateRecouvrement": "31/07/2021",
    "dateEtablissement": "06/07/2021",
    "nombreParts": 1.0,
    "situationFamille": "Marié(e)s",
    "revenuBrutGlobal": 30000,
    "revenuImposable": 29000,
    "impotRevenuNetAvantCorrections": 36,
    "montantImpot": 5,
    "revenuFiscalReference": 29000,
    "nombrePersonnesCharge": 3,
    "anneeImpots": "2021",
    "anneeRevenus": "2020",
    "erreurCorrectif": "",
    "situationPartielle": ""
  }
  ```

  </p>
  </details>

* [200.yaml](200.yaml)

  Status `200`

  API Dépréciée - ne plus intégrer

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroFiscal": "1111111111111",
    "referenceAvis": "1111111111111"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "dateRecouvrement": "31/07/2022",
    "dateEtablissement": "08/07/2022",
    "nombreParts": 1.0,
    "revenuBrutGlobal": 9001,
    "revenuImposable": 9001,
    "impotRevenuNetAvantCorrections": null,
    "montantImpot": 100,
    "revenuFiscalReference": 9001,
    "anneeRevenus": "2021",
    "erreurCorrectif": "",
    "situationPartielle": "",
    "declarant1": {
      "nom": "DUPONT",
      "nomNaissance": "DUPONT",
      "prenoms": "JEAN MARTIN",
      "dateNaissance": "19/01/1980"
    },
    "declarant2": {
      "nom": "",
      "nomNaissance": "",
      "prenoms": "",
      "dateNaissance": ""
    },
    "foyerFiscal": {
      "adresse": "42 RUE DE LA PAIX 75002 PARIS",
      "annee": 2022
    },
    "situationFamille": "Célibataire",
    "nombrePersonnesCharge": 1,
    "anneeImpots": "2022"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'numeroFiscal=1111111111111' -d 'referenceAvis=1111111111111' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/avis-imposition"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  API Dépréciée - ne plus intégrer

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroFiscal": "1111111111404",
    "referenceAvis": "1111111111404"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "not_found",
    "reason": "Les paramètres fournis sont incorrects ou ne correspondent pas à un avis",
    "message": "Les paramètres fournis sont incorrects ou ne correspondent pas à un avis"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'numeroFiscal=1111111111404' -d 'referenceAvis=1111111111404' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/avis-imposition"
  ```

  </p>
  </details>
* [500.yaml](500.yaml)

  Status `500`

  API Dépréciée - ne plus intégrer

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroFiscal": "1111111111500",
    "referenceAvis": "1111111111500"
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
    -G -d 'numeroFiscal=1111111111500' -d 'referenceAvis=1111111111500' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/avis-imposition"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  API Dépréciée - ne plus intégrer

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroFiscal": "1111111111502",
    "referenceAvis": "1111111111502"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "invalid_response",
    "reason": "Data provider returned an invalid data format.",
    "message": "La réponse du fournisseur de donnée est inexploitable"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'numeroFiscal=1111111111502' -d 'referenceAvis=1111111111502' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/avis-imposition"
  ```

  </p>
  </details>
* [503.yaml](503.yaml)

  Status `503`

  API Dépréciée - ne plus intégrer

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroFiscal": "1111111111503",
    "referenceAvis": "1111111111503"
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
    -G -d 'numeroFiscal=1111111111503' -d 'referenceAvis=1111111111503' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/avis-imposition"
  ```

  </p>
  </details>
* [509.yaml](509.yaml)

  Status `509`

  API Dépréciée - ne plus intégrer

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "numeroFiscal": "1111111111509",
    "referenceAvis": "1111111111509"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "error": "rate_limited",
    "reason": "DGFIP error rate limit exceeded",
    "message": "Le fournisseur de donnée a rejeté la demande en raison d'un trop grand nombre d'échecs antérieurs."
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'numeroFiscal=1111111111509' -d 'referenceAvis=1111111111509' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/avis-imposition"
  ```

  </p>
  </details>
