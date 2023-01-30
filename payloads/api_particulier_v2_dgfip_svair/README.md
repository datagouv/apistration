# Service de vérification de l'avis d'impôt sur le revenu
* [default.yaml](default.yaml)

  Status `200`

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
