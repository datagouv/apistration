# [Identité] Statut allocation de soutien familial (ASF)
* [200_beneficiaire.yaml](200_beneficiaire.yaml)

  Status `200`

  ## Bénéficiaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "LALANNE",
    "prenoms": [
      "FRANCIS",
      "GERARD"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 11,
    "jourDateNaissance": 1,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "est_beneficiaire": true,
      "date_debut_droit": "1992-11-29"
    },
    "links": {},
    "meta": {}
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LALANNE' -d 'prenoms[]=FRANCIS' -d 'prenoms[]=GERARD' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=11' -d 'jourDateNaissance=1' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_soutien_familial/identite"
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
    "prenoms": [
      "CYRANO"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 11,
    "jourDateNaissance": 1,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "est_beneficiaire": false,
      "date_debut_droit": null
    },
    "links": {},
    "meta": {}
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=DEPARDIEU' -d 'nomNaissance=BERGERAC' -d 'prenoms[]=CYRANO' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=11' -d 'jourDateNaissance=1' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_soutien_familial/identite"
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
    "prenoms": [
      "JEROME"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 12,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
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
        "code": "37003",
        "title": "Entité non trouvée",
        "detail": "Dossier allocataire inexistant. Le document ne peut être édité.",
        "source": null,
        "meta": {
          "provider": "CNAV"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUBOCHE' -d 'prenoms[]=JEROME' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_soutien_familial/identite"
  ```

  </p>
  </details>
* [429.yaml](429.yaml)

  Status `429`

  ## Allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DESFOUIN",
    "prenoms": [
      "René"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 12,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
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
        "code": "00429",
        "title": "Trop de requêtes",
        "detail": "Vous avez effectué trop de requêtes",
        "source": null,
        "meta": {}
      }
    ]
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DESFOUIN' -d 'prenoms[]=Ren%C3%A9' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_soutien_familial/identite"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  ## Allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DELANOUE",
    "prenoms": [
      "Jean-Marie"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 12,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
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
        "code": "37999",
        "title": "Erreur inconnue du fournisseur de données",
        "detail": "La réponse retournée par le fournisseur de données est invalide et inconnue de notre service. L'équipe technique a été notifiée de cette erreur pour investigation.",
        "source": null,
        "meta": {
          "provider": "CNAV"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DELANOUE' -d 'prenoms[]=Jean-Marie' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_soutien_familial/identite"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  ## Allocataire non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "SITUDI",
    "prenoms": [
      "Clément"
    ],
    "anneeDateNaissance": 2002,
    "moisDateNaissance": 12,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M"
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
        "code": "37002",
        "title": "Intermédiaire hors-délai",
        "detail": "Temps d’attente d’une réponse du fournisseur de données écoulé.",
        "source": null,
        "meta": {
          "provider": "CNAV"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SITUDI' -d 'prenoms[]=Cl%C3%A9ment' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/allocation_soutien_familial/identite"
  ```

  </p>
  </details>
