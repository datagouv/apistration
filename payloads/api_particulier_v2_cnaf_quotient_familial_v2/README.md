# Quotient familial MSA & CAF
* [200-couple-2_enfants-qf_msa_150_mai23.yaml](200-couple-2_enfants-qf_msa_150_mai23.yaml)

  Status `200`

  ## Couple avec deux enfants - allocataire féminin - QF MSA de 150 en mai 2023

Ce cas permet de tester :
- [Param. appel] Mois et année du QF recherché 
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe feminin
- [Param. appel] Deux prénoms
- [Réponse] Tableau d'informations car couple
- [Réponse] Tableau d'informations car deux enfants
- [Réponse] Régime MSA
- [Réponse] Quotient familial de 150
- [Réponse] Quotient familial ancien de mai 2023

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "ROUX",
    "prenoms": [
      "JEANNE",
      "STEPHANIE"
    ],
    "anneeDateDeNaissance": 1987,
    "moisDateDeNaissance": 6,
    "annee": 2023,
    "mois": 5
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "regime": "MSA",
    "allocataires": [
      {
        "nomNaissance": "ROUX",
        "nomUsage": "ROUX",
        "prenoms": "JEANNE STEPHANIE",
        "anneeDateDeNaissance": "1987",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      },
      {
        "nomNaissance": "ROUX",
        "nomUsage": "ROUX",
        "prenoms": "LOIC NATHAN",
        "anneeDateDeNaissance": "1979",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "19",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "ROUX",
        "nomUsage": "ROUX",
        "prenoms": "ALEXIS VINCENT",
        "anneeDateDeNaissance": "2006",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      },
      {
        "nomNaissance": "ROUX",
        "nomUsage": "ROUX",
        "prenoms": "FLEUR EDITH",
        "anneeDateDeNaissance": "2004",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Madame ROUX JEANNE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002",
      "pays": "FRANCE"
    },
    "quotientFamilial": 150,
    "annee": 2023,
    "mois": 5
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=ROUX' -d 'prenoms[]=JEANNE' -d 'prenoms[]=STEPHANIE' -d 'anneeDateDeNaissance=1987' -d 'moisDateDeNaissance=6' -d 'annee=2023' -d 'mois=5' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-seul-1_enfant-qf_caf_650.yaml](200-seul-1_enfant-qf_caf_650.yaml)

  Status `200`

  ## Famille monoparentale avec un enfant - allocataire féminin - QF CAF en cours de 650

Ce cas permet de tester :
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe feminin
- [Réponse] Régime CAF
- [Réponse] Quotient familial de 650

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "BERNARD",
    "prenoms": [
      "ELODIE"
    ],
    "anneeDateDeNaissance": 1990,
    "moisDateDeNaissance": 3
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "regime": "CNAF",
    "allocataires": [
      {
        "nomNaissance": "BERNARD",
        "nomUsage": "BERNARD",
        "prenoms": "ELODIE JUDITH GERTRUDE",
        "anneeDateDeNaissance": "1990",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "18",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "BERNARD",
        "nomUsage": "BERNARD",
        "prenoms": "LEO",
        "anneeDateDeNaissance": "1990",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Madame BERNARD ELODIE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002",
      "pays": "FRANCE"
    },
    "quotientFamilial": 650,
    "annee": 2023,
    "mois": 6
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=BERNARD' -d 'prenoms[]=ELODIE' -d 'anneeDateDeNaissance=1990' -d 'moisDateDeNaissance=3' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-seul-sans_enfant-qf_caf_2550.yaml](200-seul-sans_enfant-qf_caf_2550.yaml)

  Status `200`

  ## Allocataire seul - masculin - QF CAF de 2550 du mois en cours

Ce cas permet de tester :
- [Param. appel] lieu de naissance en France
- [Param. appel] sexe masculin
- [Réponse] Régime CAF
- [Réponse] Quotient familial de 2550
- [Réponse] Quotient familial du mois en cours

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEXIS"
    ],
    "anneeDateDeNaissance": 1982,
    "moisDateDeNaissance": 12
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "regime": "CNAF",
    "allocataires": [
      {
        "nomNaissance": "LEFEBVRE",
        "nomUsage": "LEFEBVRE",
        "prenoms": "ALEXIS",
        "anneeDateDeNaissance": "1982",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur LEFEBVRE ALEXIS",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002",
      "pays": "FRANCE"
    },
    "quotientFamilial": 2550,
    "annee": 2023,
    "mois": 6
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Dossier non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "00404",
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
    -G -d 'codeInseeLieuDeNaissance=00404' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
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
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
