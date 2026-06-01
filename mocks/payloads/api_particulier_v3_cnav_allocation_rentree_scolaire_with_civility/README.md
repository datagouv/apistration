# [Identité] Statut allocation de rentrée scolaire (ARS)
* [200_allocataire.yaml](200_allocataire.yaml)

  Status `200`

  ## Bénéficiaire (allocataire)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "PIERRE"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 3,
    "jourDateNaissance": 12,
    "codeCogInseeCommuneNaissance": "75112",
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
      "status": "allocataire",
      "date_debut_droit": "2024-08-09"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUPONT' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=3' -d 'jourDateNaissance=12' -d 'codeCogInseeCommuneNaissance=75112' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnav/allocation_rentree_scolaire/identite"
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
    "nomNaissance": "BERNARD",
    "prenoms": [
      "LUCAS"
    ],
    "anneeDateNaissance": 1978,
    "moisDateNaissance": 1,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "13055",
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
      "status": "non_beneficiaire",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=BERNARD' -d 'prenoms[]=LUCAS' -d 'anneeDateNaissance=1978' -d 'moisDateNaissance=1' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnav/allocation_rentree_scolaire/identite"
  ```

  </p>
  </details>
* [200_ouvrant_droit.yaml](200_ouvrant_droit.yaml)

  Status `200`

  ## Ouvrant droit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTIN",
    "prenoms": [
      "SOPHIE",
      "MARIE"
    ],
    "anneeDateNaissance": 1990,
    "moisDateNaissance": 7,
    "jourDateNaissance": 22,
    "codeCogInseeCommuneNaissance": "69123",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "status": "ouvrant_droit",
      "date_debut_droit": "2024-08-09"
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTIN' -d 'prenoms[]=SOPHIE' -d 'prenoms[]=MARIE' -d 'anneeDateNaissance=1990' -d 'moisDateNaissance=7' -d 'jourDateNaissance=22' -d 'codeCogInseeCommuneNaissance=69123' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnav/allocation_rentree_scolaire/identite"
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
    "anneeDateNaissance": 1972,
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUBOCHE' -d 'prenoms[]=JEROME' -d 'anneeDateNaissance=1972' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnav/allocation_rentree_scolaire/identite"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  ## Erreur fournisseur

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DELANOUE",
    "prenoms": [
      "Jean-Marie"
    ],
    "anneeDateNaissance": 1980,
    "moisDateNaissance": 6,
    "jourDateNaissance": 15,
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DELANOUE' -d 'prenoms[]=Jean-Marie' -d 'anneeDateNaissance=1980' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/cnav/allocation_rentree_scolaire/identite"
  ```

  </p>
  </details>
