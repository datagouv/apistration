# Recherche de la situation Pôle Emploi d'un particulier
* [default.yaml](default.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "default"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "identifiant": "default",
    "civilite": "M.",
    "nom": "DUPONT",
    "nomUsage": null,
    "prenom": "JEAN",
    "sexe": "Masculin",
    "codeCertificationCNAV": "VC",
    "libelleCategorieInscription": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS",
    "email": "jean.dupont@france.fr",
    "telephone": "0636656565",
    "telephone2": null,
    "adresse": {
      "INSEECommune": "75107",
      "codePostal": "75007",
      "ligneComplementAdresse": null,
      "ligneComplementDestinataire": "APPARTEMENT 42",
      "ligneComplementDistribution": null,
      "ligneNom": "DUPONT",
      "ligneVoie": "42 RUE DE LA PAIX",
      "localite": "75001 PARIS"
    },
    "dateNaissance": "1990-01-01",
    "dateInscription": "2020-01-01",
    "dateCessationInscription": null,
    "codeCategorieInscription": 1
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=default' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/situations-pole-emploi"
  ```

  </p>
  </details>
