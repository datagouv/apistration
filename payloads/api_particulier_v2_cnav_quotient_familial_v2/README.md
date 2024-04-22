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
    "recipient": "13002526500013",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=ROUX' -d 'prenoms[]=JEANNE' -d 'prenoms[]=STEPHANIE' -d 'anneeDateDeNaissance=1987' -d 'moisDateDeNaissance=6' -d 'annee=2023' -d 'mois=5' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-identite-cas-limite-erreur-phonetique.yaml](200-identite-cas-limite-erreur-phonetique.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui ne changent pas la phonétique. Ici, il y a suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEXI",
      "GEROME",
      "JEN-PHILIPE"
    ],
    "anneeDateDeNaissance": 1982,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 27
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
        "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
        "anneeDateDeNaissance": "1982",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXI' -d 'prenoms[]=GEROME' -d 'prenoms[]=JEN-PHILIPE' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-identite-cas-limite-faute-de-frappe.yaml](200-identite-cas-limite-faute-de-frappe.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui changent la phonétique. Ici, il y a suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEIXS",
      "GRÉÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateDeNaissance": 1982,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 27
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
        "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
        "anneeDateDeNaissance": "1982",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEIXS' -d 'prenoms[]=GR%C3%89%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-identite-cas-nominal-peu-de-donnee-naissance.yaml](200-identite-cas-nominal-peu-de-donnee-naissance.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Les données de jour et de mois de naissance ont été retiré.

Il y a suffisament de données de nom/prénoms dans les paramètres pour compenser
l'absence des données de naissance.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEXIS",
      "GÉRÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateDeNaissance": 1982
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
        "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
        "anneeDateDeNaissance": "1982",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-identite-cas-nominal-peu-de-donnée-prenom.yaml](200-identite-cas-nominal-peu-de-donnée-prenom.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Les deuxième et troisième prenoms ont été retiré des données

Il y suffisament de donnée de naissance dans cet ensemble de paramètre pour permettre
de compenser les données manquantes

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEXIS"
    ],
    "anneeDateDeNaissance": 1982,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 27
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
        "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
        "anneeDateDeNaissance": "1982",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-identite-cas-nominal.yaml](200-identite-cas-nominal.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas est le cas nominal de l'ensemble des cas de test d'identité/limite.
Il a pour but de décrire une personne fictive avec l'ensemble de ses paramètres
et la réponse lorsque celui ci est trouvé.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEXIS",
      "GÉRÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateDeNaissance": 1982,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 27
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
        "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
        "anneeDateDeNaissance": "1982",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur LEFEBVRE ALEXIS GÉRÔME JEAN-PHILIPPE",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
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
    "recipient": "13002526500013",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=BERNARD' -d 'prenoms[]=ELODIE' -d 'anneeDateDeNaissance=1990' -d 'moisDateDeNaissance=3' \
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
    "recipient": "13002526500013",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [404-identite-cas-limite-erreur-phonetique.yaml](404-identite-cas-limite-erreur-phonetique.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui changent ne change pas ou peu la phonétique. Ici, il n'y a pas suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEXI",
      "GEROME",
      "JEN-PHILIPE"
    ],
    "anneeDateDeNaissance": 1982
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXI' -d 'prenoms[]=GEROME' -d 'prenoms[]=JEN-PHILIPE' -d 'anneeDateDeNaissance=1982' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [404-identite-cas-limite-faute-de-frappe.yaml](404-identite-cas-limite-faute-de-frappe.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas est un cas limite de l'ensemble des cas de test d'identité/limite.

Il comporte des erreurs dans les prenoms qui changent la phonétique. Ici, il n'y a pas suffisament
de donnée de naissance pour compenser les erreurs et retrouver l'identité.

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEIXS",
      "GRÉÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateDeNaissance": 1982
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEIXS' -d 'prenoms[]=GR%C3%89%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [404-identite-cas-nominal-trop-peu-de-donnee-naissance.yaml](404-identite-cas-nominal-trop-peu-de-donnee-naissance.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Les données concernant la date de naissance ont été retirée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomUsage": "LEFEBVRE",
    "prenoms": [
      "ALEXIS",
      "GÉRÔME",
      "JEAN-PHILIPPE"
    ]
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomUsage=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [404-identite-cas-nominal-trop-peu-de-donnee-prenom.yaml](404-identite-cas-nominal-trop-peu-de-donnee-prenom.yaml)

  Status `404`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Le nom ainsi que les deuxième et troisième prenoms ont été retiré des données

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "recipient": "13002526500013",
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "prenoms": [
      "ALEXIS"
    ],
    "anneeDateDeNaissance": 1982,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 27
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'prenoms[]=ALEXIS' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
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
    "recipient": "13002526500013",
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
    -G -d 'recipient=13002526500013' -d 'codeInseeLieuDeNaissance=00404' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
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
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [fake_france_connect_cnaf.yml](fake_france_connect_cnaf.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/cnaf_qfv2.yml).
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
    "regime": "CNAF",
    "allocataires": [
      {
        "nomNaissance": "CNAF",
        "nomUsage": "MARTIN",
        "prenoms": "GEORGES",
        "anneeDateDeNaissance": "2002",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur CNAF MARTIN",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002",
      "pays": "FRANCE"
    },
    "quotientFamilial": 2550,
    "annee": 2024,
    "mois": 2
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_cnaf.yml](france_connect_cnaf.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
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
    "regime": "CNAF",
    "allocataires": [
      {
        "nomNaissance": "DUBOIS",
        "nomUsage": "DUBOIS",
        "prenoms": "ANGELA",
        "anneeDateDeNaissance": "1962",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "24",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Madame DUBOIS ANGELA",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002",
      "pays": "FRANCE"
    },
    "quotientFamilial": 2550,
    "annee": 2024,
    "mois": 2
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2?recipient=13002526500013"
  ```

  </p>
  </details>
