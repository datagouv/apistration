# Statut demandeur d'emploi
* [200.yaml](200.yaml)

  Status `200`

  Personne insrite

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
    "data": {
      "identifiant": "default",
      "identite": {
        "civilite": "M.",
        "nom_naissance": "DUPONT",
        "nom_usage": null,
        "prenom": "JEAN",
        "sexe": "Masculin",
        "date_naissance": "1990-01-01"
      },
      "contact": {
        "email": "jean.dupont@france.fr",
        "telephone": "0636656565",
        "telephone2": null
      },
      "adresse": {
        "code_cog_insee_commune": "75107",
        "code_postal": "75007",
        "ligne_complement_adresse": null,
        "ligne_complement_destinataire": "APPARTEMENT 42",
        "ligne_complement_distribution": null,
        "ligne_nom": "DUPONT",
        "ligne_voie": "42 RUE DE LA PAIX",
        "localite": "75001 PARIS"
      },
      "inscription": {
        "date_debut": "2020-01-01",
        "date_fin": null,
        "code_certification_cnav": "VC",
        "categorie": {
          "code": 1,
          "libelle": "PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS"
        }
      }
    },
    "links": {
    },
    "meta": {
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=default' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Personne non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "not_found"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "errors": [
      {
        "code": "24003",
        "title": "Entité non trouvée",
        "detail": "Aucune situation France Travail n'a pu être trouvée avec les critères de recherche fournis.",
        "source": null,
        "meta": {
          "provider": "France Travail"
        }
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'identifiant=not_found' \
    --url "https://staging.particulier.api.gouv.fr/v3/france_travail/statut/identifiant"
  ```

  </p>
  </details>
