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
    "nomNaissance": "ROUX",
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
        "nomUsuel": null,
        "prenoms": "JEANNE STEPHANIE",
        "anneeDateDeNaissance": "1987",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      },
      {
        "nomNaissance": "ROUX",
        "nomUsuel": null,
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
        "nomUsuel": null,
        "prenoms": "ALEXIS VINCENT",
        "anneeDateDeNaissance": "2006",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      },
      {
        "nomNaissance": "ROUX",
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=ROUX' -d 'prenoms[]=JEANNE' -d 'prenoms[]=STEPHANIE' -d 'anneeDateDeNaissance=1987' -d 'moisDateDeNaissance=6' -d 'annee=2023' -d 'mois=5' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-couple-2_enfants-qf_msa_150_sept2024.yaml](200-couple-2_enfants-qf_msa_150_sept2024.yaml)

  Status `200`

  ## Couple avec deux enfants - allocataire masculin - QF MSA de 200 en septembre 2024

Ce cas permet de tester : 
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe masculin
- [Param. appel] 1 prénom
- [Réponse] Tableau d'informations car couple
- [Réponse] Tableau d'informations car deux enfants
- [Réponse] Régime MSA
- [Réponse] Quotient familial de 200
- [Réponse] Quotient familial ancien de septembre 2024

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "51108",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "M",
    "nomNaissance": "Martin",
    "prenoms": [
      "Pierre"
    ],
    "anneeDateDeNaissance": 1987,
    "moisDateDeNaissance": 6,
    "jourDateDeNaissance": 27
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
        "nomNaissance": "MARTIN",
        "nomUsuel": null,
        "prenoms": "PIERRE ALEXIS FRANÇOIS",
        "anneeDateDeNaissance": "1978",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "27",
        "sexe": "M"
      },
      {
        "nomNaissance": "LEROUGE",
        "nomUsuel": "MARTIN",
        "prenoms": "JUSTINE ÉLISE",
        "anneeDateDeNaissance": "1979",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "19",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "MARTIN",
        "nomUsuel": null,
        "prenoms": "ALEXIS VINCENT",
        "anneeDateDeNaissance": "2006",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      },
      {
        "nomNaissance": "MARTIN",
        "nomUsuel": null,
        "prenoms": "FLEUR EDITH",
        "anneeDateDeNaissance": "2010",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "20",
        "sexe": "F"
      }
    ],
    "adresse": {
      "identite": "Monsieur MARTIN Pierre",
      "complementInformation": "Bâtiment B",
      "complementInformationGeographique": "Résidence Alouette",
      "numeroLibelleVoie": "12 AVENUE DU GÉNÉRAL DE GAULLE",
      "lieuDit": null,
      "codePostalVille": "51000 CHÂLONS-EN-CHAMPAGNE",
      "pays": "FRANCE"
    },
    "quotientFamilial": 200,
    "annee": 2024,
    "mois": 9
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codeInseeLieuDeNaissance=51108' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' -d 'nomNaissance=Martin' -d 'prenoms[]=Pierre' -d 'anneeDateDeNaissance=1987' -d 'moisDateDeNaissance=6' -d 'jourDateDeNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-etranger-celibataire-2_enfants-qf_cnaf_300_sept2024.yaml](200-etranger-celibataire-2_enfants-qf_cnaf_300_sept2024.yaml)

  Status `200`

  ## célibataire né aux Etats Unis avec deux enfants - allocataire féminin - QF CNAF de 300 en aout 2024

Ce cas permet de tester : 
- [Param. appel] Lieu de naissance en France
- [Param. appel] Sexe féminin
- [Param. appel] 1 prénom
- [Réponse] Tableau d'informations 1 seul allocataire
- [Réponse] Tableau d'informations car deux enfants
- [Réponse] Régime CNAF
- [Réponse] Quotient familial de 300
- [Réponse] Quotient familial ancien de aout 2024

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codePaysLieuDeNaissance": "99404",
    "sexe": "F",
    "nomNaissance": "SIMPSON",
    "prenoms": [
      "Marge"
    ],
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 15
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
        "nomNaissance": "BROWN",
        "nomUsuel": null,
        "prenoms": "Marge",
        "anneeDateDeNaissance": "1980",
        "moisDateDeNaissance": "11",
        "jourDateDeNaissance": "15",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "BROWN",
        "nomUsuel": null,
        "prenoms": "Bart",
        "anneeDateDeNaissance": "2012",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "28",
        "sexe": "M"
      },
      {
        "nomNaissance": "SIMPSON",
        "nomUsuel": null,
        "prenoms": "LISA",
        "anneeDateDeNaissance": "2013",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "01",
        "sexe": "F"
      }
    ],
    "adresse": {
      "identite": "Madame SIMPSON Marge",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 PLACE DE L'HÔTEL DE VILLE'",
      "lieuDit": null,
      "codePostalVille": "51000 CHÂLONS-EN-CHAMPAGNE",
      "pays": "FRANCE"
    },
    "quotientFamilial": 300,
    "annee": 2024,
    "mois": 8
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codePaysLieuDeNaissance=99404' -d 'sexe=F' -d 'nomNaissance=SIMPSON' -d 'prenoms[]=Marge' -d 'anneeDateDeNaissance=1980' -d 'moisDateDeNaissance=11' -d 'jourDateDeNaissance=15' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-identite-cas-etranger.yaml](200-identite-cas-etranger.yaml)

  Status `200`

  ## IDENTITÉ CAS ETRANGER

Ce cas est le cas personne étrangère de l'ensemble des cas de test d'identité/limite.
Il a pour but de décrire une personne fictive avec l'ensemble de ses paramètres
et la réponse lorsque celui ci est trouvé.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codePaysLieuDeNaissance": "99350",
    "sexe": "M",
    "nomNaissance": "FAKIR",
    "prenoms": [
      "EYMEN",
      "MOHAMED"
    ],
    "anneeDateDeNaissance": 1992,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 14
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
        "nomNaissance": "FAKIR",
        "nomUsuel": null,
        "prenoms": "EYMEN MOHAMED",
        "anneeDateDeNaissance": "1992",
        "moisDateDeNaissance": "11",
        "jourDateDeNaissance": "14",
        "sexe": "F"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur FAKOR EYMEN MOHAMED",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "19 RUE ARISTIDE BRIAND",
      "lieuDit": null,
      "codePostalVille": "92330 SCEAUX",
      "pays": "FRANCE"
    },
    "quotientFamilial": 4270,
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
    -G -d 'codePaysLieuDeNaissance=99350' -d 'sexe=M' -d 'nomNaissance=FAKIR' -d 'prenoms[]=EYMEN' -d 'prenoms[]=MOHAMED' -d 'anneeDateDeNaissance=1992' -d 'moisDateDeNaissance=11' -d 'jourDateDeNaissance=14' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXI' -d 'prenoms[]=GEROME' -d 'prenoms[]=JEN-PHILIPE' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEIXS' -d 'prenoms[]=GR%C3%89%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2"
  ```

  </p>
  </details>
* [200-identite-cas-nominal-peu-de-donnee-prenom.yaml](200-identite-cas-nominal-peu-de-donnee-prenom.yaml)

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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
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
    "nomNaissance": "BERNARD",
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
        "nomUsuel": null,
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
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=BERNARD' -d 'prenoms[]=ELODIE' -d 'anneeDateDeNaissance=1990' -d 'moisDateDeNaissance=3' \
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
    "nomNaissance": "LEFEBVRE",
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
        "nomUsuel": null,
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
      "codePostalVille": "75002 PARIS",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXI' -d 'prenoms[]=GEROME' -d 'prenoms[]=JEN-PHILIPE' -d 'anneeDateDeNaissance=1982' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEIXS' -d 'prenoms[]=GR%C3%89%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateDeNaissance=1982' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "LEFEBVRE",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' \
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
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "DUPONT",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=DUPONT' -d 'prenoms[]=ALEXIS' -d 'anneeDateDeNaissance=1982' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=27' \
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
    "nomNaissance": "LEFEBVRE",
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
    -G -d 'nomNaissance=LEFEBVRE' -d 'codeInseeLieuDeNaissance=00404' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
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
    "nomNaissance": "LEFEBVRE",
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
    -G -d 'nomNaissance=LEFEBVRE' -d 'codeInseeLieuDeNaissance=00503' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
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
    "prenoms": [
      "Georges"
    ],
    "nomNaissance": "CNAF",
    "nomUsage": "MARTIN",
    "anneeDateDeNaissance": 2002,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
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
    "regime": "CNAF",
    "allocataires": [
      {
        "nomNaissance": "CNAF",
        "nomUsuel": "MARTIN",
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
      "codePostalVille": "75002 PARIS",
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
* [fake_france_connect_cnaf_2.yml](fake_france_connect_cnaf_2.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/cnaf_qfv2.yml).
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Thomas"
    ],
    "nomNaissance": "Delatour",
    "nomUsage": "Delamouette",
    "anneeDateDeNaissance": 1994,
    "moisDateDeNaissance": 4,
    "jourDateDeNaissance": 16,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "75111",
    "codePaysLieuDeNaissance": "99100"
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
        "nomUsuel": "MARTIN",
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
      "codePostalVille": "75002 PARIS",
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
* [france_connect_200_cnaf_1_parent_3_mineurs.yml](france_connect_200_cnaf_1_parent_3_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Pierre"
    ],
    "nomNaissance": "MERCIER",
    "anneeDateDeNaissance": 1969,
    "moisDateDeNaissance": 3,
    "jourDateDeNaissance": 17,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "95277",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "MERCIER",
        "nomUsuel": "MERCIER",
        "prenoms": "PIERRE",
        "anneeDateDeNaissance": "1969",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "17",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "MERCIER",
        "nomUsuel": "MERCIER",
        "prenoms": "PIERRE",
        "anneeDateDeNaissance": "2018",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "10",
        "sexe": "M"
      },
      {
        "nomNaissance": "MERCIER",
        "nomUsuel": "MERCIER",
        "prenoms": "ROBERT",
        "anneeDateDeNaissance": "2020",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "15",
        "sexe": "M"
      },
      {
        "nomNaissance": "MERCIER",
        "nomUsuel": "MERCIER",
        "prenoms": "HENRY",
        "anneeDateDeNaissance": "2022",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur MERCIER PIERRE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002 PARIS",
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
* [france_connect_200_cnaf_2_parents_0_enfant.yml](france_connect_200_cnaf_2_parents_0_enfant.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Anne-Laure"
    ],
    "nomNaissance": "HUCHE",
    "anneeDateDeNaissance": 1945,
    "moisDateDeNaissance": 9,
    "jourDateDeNaissance": 30,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "31555",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "HUCHE",
        "nomUsuel": "MERCIER",
        "prenoms": "ANNE-LAURE",
        "anneeDateDeNaissance": "1945",
        "moisDateDeNaissance": "09",
        "jourDateDeNaissance": "30",
        "sexe": "F"
      },
      {
        "nomNaissance": "MERCIER",
        "nomUsuel": "MERCIER",
        "prenoms": "JEAN LOUIS",
        "anneeDateDeNaissance": "1945",
        "moisDateDeNaissance": "10",
        "jourDateDeNaissance": "12",
        "sexe": "M"
      }
    ],
    "enfants": [
  
    ],
    "adresse": {
      "identite": "Monsieur MERCIER JEAN",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002 PARIS",
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
* [france_connect_200_cnaf_2_parents_1_mineur_2_majeurs.yml](france_connect_200_cnaf_2_parents_1_mineur_2_majeurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Melissandre",
      "Juliette"
    ],
    "nomNaissance": "TROIS-DUPRE",
    "anneeDateDeNaissance": 1981,
    "moisDateDeNaissance": 7,
    "jourDateDeNaissance": 27,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "13012",
    "codePaysLieuDeNaissance": "99100"
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
        "nomUsuel": "TROIS-DUPRE",
        "prenoms": "MELISSANDRE JULIETTE",
        "anneeDateDeNaissance": "1981",
        "moisDateDeNaissance": "07",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      },
      {
        "nomNaissance": "TROIS-DUPRE",
        "nomUsuel": "TROIS-DUPRE",
        "prenoms": "PAUL",
        "anneeDateDeNaissance": "1963",
        "moisDateDeNaissance": "10",
        "jourDateDeNaissance": "12",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "TROIS-DUPRE",
        "nomUsuel": "TROIS-DUPRE",
        "prenoms": "PIERRE",
        "anneeDateDeNaissance": "2004",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "10",
        "sexe": "M"
      },
      {
        "nomNaissance": "TROIS-DUPRE",
        "nomUsuel": "TROIS-DUPRE",
        "prenoms": "LOU",
        "anneeDateDeNaissance": "2015",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "15",
        "sexe": "F"
      },
      {
        "nomNaissance": "TROIS-DUPRE",
        "nomUsuel": "TROIS-DUPRE",
        "prenoms": "HENRY",
        "anneeDateDeNaissance": "2022",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur TROIS-DUPRE PAUL",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002 PARIS",
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
* [france_connect_200_cnaf_2_parents_2_mineurs.yml](france_connect_200_cnaf_2_parents_2_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Joëlle",
      "Françoise"
    ],
    "nomNaissance": "DUBINÔRE",
    "anneeDateDeNaissance": 1992,
    "moisDateDeNaissance": 8,
    "jourDateDeNaissance": 15,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "75117",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "DUBINÔRE",
        "nomUsuel": "LENOTRE",
        "prenoms": "Joëlle Françoise",
        "anneeDateDeNaissance": "1990",
        "moisDateDeNaissance": "09",
        "jourDateDeNaissance": "25",
        "sexe": "F"
      },
      {
        "nomNaissance": "LENOTRE",
        "nomUsuel": "LENOTRE",
        "prenoms": "Léon",
        "anneeDateDeNaissance": "1990",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "LENOTRE",
        "nomUsuel": "LENOTRE",
        "prenoms": "Gustave",
        "anneeDateDeNaissance": "2015",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "07",
        "sexe": "M"
      },
      {
        "nomNaissance": "LENOTRE",
        "nomUsuel": "LENOTRE",
        "prenoms": "Alphonse",
        "anneeDateDeNaissance": "2015",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "07",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur Léon LENOTRE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "20 AVENUE DE SEGUR",
      "lieuDit": null,
      "codePostalVille": "75107 PARIS",
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
* [france_connect_200_cnaf_2_parents_3_mineurs.yml](france_connect_200_cnaf_2_parents_3_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Paul",
      "Louis"
    ],
    "nomNaissance": "DUPONT",
    "anneeDateDeNaissance": 1962,
    "moisDateDeNaissance": 8,
    "jourDateDeNaissance": 24,
    "sexe": "M",
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
    "regime": "CNAF",
    "allocataires": [
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
        "prenoms": "PAUL LOUIS",
        "anneeDateDeNaissance": "1962",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "24",
        "sexe": "M"
      },
      {
        "nomNaissance": "DURAND",
        "nomUsuel": "DUBOIS",
        "prenoms": "ANGELA LOUISE",
        "anneeDateDeNaissance": "1963",
        "moisDateDeNaissance": "10",
        "jourDateDeNaissance": "12",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
        "prenoms": "PIERRE",
        "anneeDateDeNaissance": "2018",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "10",
        "sexe": "M"
      },
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
        "prenoms": "ROBERT",
        "anneeDateDeNaissance": "2020",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "15",
        "sexe": "M"
      },
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
        "prenoms": "HENRY",
        "anneeDateDeNaissance": "2022",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "20",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur DUPONT PAUL",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE MONTORGUEIL",
      "lieuDit": null,
      "codePostalVille": "75002 PARIS",
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
* [france_connect_200_cnaf_2_parents_3_mineurs_1_nom_avec_caracteres_speciaux.yml](france_connect_200_cnaf_2_parents_3_mineurs_1_nom_avec_caracteres_speciaux.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Olivier",
      "Martin"
    ],
    "nomNaissance": "ANO'NYMOS-LONS",
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 5,
    "jourDateDeNaissance": 24,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "95491",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "ANO'NYMOS-LONS",
        "nomUsuel": "ANO'NYMOS-LONS",
        "prenoms": "OLIVIER",
        "anneeDateDeNaissance": "1980",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "24",
        "sexe": "M"
      },
      {
        "nomNaissance": "ANO'NYMOS-LONS",
        "nomUsuel": "ROUSSEAU",
        "prenoms": "LAURENCE",
        "anneeDateDeNaissance": "1981",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "01",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "ANO'NYMOS-LONS",
        "nomUsuel": "ANO'NYMOS-LONS",
        "prenoms": "Gabriel",
        "anneeDateDeNaissance": "2010",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "02",
        "sexe": "M"
      },
      {
        "nomNaissance": "ANO'NYMOS-LONS",
        "nomUsuel": "ANO'NYMOS-LONS",
        "prenoms": "Jules",
        "anneeDateDeNaissance": "2013",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "03",
        "sexe": "M"
      },
      {
        "nomNaissance": "ANO'NYMOS-LONS",
        "nomUsuel": "ANO'NYMOS-LONS",
        "prenoms": "Simon",
        "anneeDateDeNaissance": "2017",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "05",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur et Madame Olivier ANO'NYMOS-LONS",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "9 R DES MONTS DE LA MADELEINE",
      "lieuDit": null,
      "codePostalVille": "42300 LONS-LE-SAUNIER",
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
* [france_connect_200_cnaf_2_parents_3_mineurs_1_prenom_compose_sans_tiret.yml](france_connect_200_cnaf_2_parents_3_mineurs_1_prenom_compose_sans_tiret.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Emmanuel",
      "Alexandre",
      "Nicolas"
    ],
    "nomNaissance": "DELALALALANDE",
    "anneeDateDeNaissance": 1991,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 7,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "75101",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "DELALALALANDE",
        "nomUsuel": "DELALALALANDE",
        "prenoms": "EMMANUEL ALEXANDRE",
        "anneeDateDeNaissance": "1991",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "07",
        "sexe": "M"
      },
      {
        "nomNaissance": "CARPENTIER",
        "nomUsuel": "DELALALALANDE",
        "prenoms": "FLORENCE",
        "anneeDateDeNaissance": "1990",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "30",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "DELALALALANDE",
        "nomUsuel": "DELALALALANDE",
        "prenoms": "Alex",
        "anneeDateDeNaissance": "2015",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "15",
        "sexe": "M"
      },
      {
        "nomNaissance": "DELALALALANDE",
        "nomUsuel": "DELALALALANDE",
        "prenoms": "Léo",
        "anneeDateDeNaissance": "2017",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "02",
        "sexe": "M"
      },
      {
        "nomNaissance": "DELALALALANDE",
        "nomUsuel": "DELALALALANDE",
        "prenoms": "Laura",
        "anneeDateDeNaissance": "2019",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "31",
        "sexe": "F"
      }
    ],
    "adresse": {
      "identite": "Monsieur et Madame Emmanuel DELALALALANDE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "20 AVENUE DE SEGUR",
      "lieuDit": null,
      "codePostalVille": "75107 PARIS",
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
* [france_connect_200_cnaf_2_parents_3_mineurs_dont_1_naissance_inconnue_null.yml](france_connect_200_cnaf_2_parents_3_mineurs_dont_1_naissance_inconnue_null.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Sophie",
      "Suzanne"
    ],
    "nomNaissance": "YOGO",
    "anneeDateDeNaissance": 1981,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 1,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "50528",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "YOGO",
        "nomUsuel": "BOBO",
        "prenoms": "Sophie Suzanne",
        "anneeDateDeNaissance": "1981",
        "moisDateDeNaissance": "11",
        "jourDateDeNaissance": "01",
        "sexe": "F"
      },
      {
        "nomNaissance": "LALI",
        "nomUsuel": "LALI",
        "prenoms": "Mohamed",
        "anneeDateDeNaissance": "1983",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "15",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "LALI",
        "nomUsuel": "LALI",
        "prenoms": "Inès",
        "anneeDateDeNaissance": "2010",
        "moisDateDeNaissance": "07",
        "jourDateDeNaissance": "10",
        "sexe": "F"
      },
      {
        "nomNaissance": "LALI",
        "nomUsuel": "LALI",
        "prenoms": "Amir",
        "anneeDateDeNaissance": "2012",
        "moisDateDeNaissance": "09",
        "jourDateDeNaissance": "09",
        "sexe": "M"
      },
      {
        "nomNaissance": "LALI",
        "nomUsuel": "LALI",
        "prenoms": "Ibrahim",
        "anneeDateDeNaissance": "2020",
        "moisDateDeNaissance": null,
        "jourDateDeNaissance": null,
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur et Madame Mohamed LALI",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "Cours des 50 Otages",
      "lieuDit": null,
      "codePostalVille": "44109 NANTES",
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
* [france_connect_200_cnaf_2_parents_4_mineurs_1_majeur.yml](france_connect_200_cnaf_2_parents_4_mineurs_1_majeur.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "FABIEN"
    ],
    "nomNaissance": "PENDERIE",
    "anneeDateDeNaissance": 1986,
    "moisDateDeNaissance": 3,
    "jourDateDeNaissance": 25,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "83028",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "PENDERIE",
        "nomUsuel": "PENDERIE",
        "prenoms": "FABIEN",
        "anneeDateDeNaissance": "1986",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "25",
        "sexe": "M"
      },
      {
        "nomNaissance": "SUVE",
        "nomUsuel": "PENDERIE",
        "prenoms": "LUCIE",
        "anneeDateDeNaissance": "1987",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "08",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "PENDERIE",
        "nomUsuel": "PENDERIE",
        "prenoms": "Léo",
        "anneeDateDeNaissance": "2020",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "PENDERIE",
        "nomUsuel": "PENDERIE",
        "prenoms": "Léa",
        "anneeDateDeNaissance": "2021",
        "moisDateDeNaissance": "07",
        "jourDateDeNaissance": "17",
        "sexe": "F"
      },
      {
        "nomNaissance": "PENDERIE",
        "nomUsuel": "PENDERIE",
        "prenoms": "Hugo",
        "anneeDateDeNaissance": "2022",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "08",
        "sexe": "M"
      },
      {
        "nomNaissance": "PENDERIE",
        "nomUsuel": "PENDERIE",
        "prenoms": "Bérénice",
        "anneeDateDeNaissance": "2024",
        "moisDateDeNaissance": "10",
        "jourDateDeNaissance": "25",
        "sexe": "F"
      },
      {
        "nomNaissance": "PENDERIE",
        "nomUsuel": "PENDERIE",
        "prenoms": "Paul",
        "anneeDateDeNaissance": "2004",
        "moisDateDeNaissance": "11",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur Fabien PENDERIE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "20 AVENUE DE SEGUR",
      "lieuDit": null,
      "codePostalVille": "75107 PARIS",
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
* [france_connect_200_cnaf_2_parents_dont_1_avec_jour_00_3_mineurs.yml](france_connect_200_cnaf_2_parents_dont_1_avec_jour_00_3_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Jacob",
      "Henri"
    ],
    "nomNaissance": "BOBO",
    "anneeDateDeNaissance": 1981,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 2,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "21331",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "BOBO",
        "nomUsuel": "BOBO",
        "prenoms": "Jacob Henri",
        "anneeDateDeNaissance": "1981",
        "moisDateDeNaissance": "11",
        "jourDateDeNaissance": "00",
        "sexe": "M"
      },
      {
        "nomNaissance": "MIZUKI",
        "nomUsuel": "BOBO",
        "prenoms": "Akari",
        "anneeDateDeNaissance": "1995",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "12",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "BOBO",
        "nomUsuel": "BOBO",
        "prenoms": "Aiko",
        "anneeDateDeNaissance": "2017",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "03",
        "sexe": "F"
      },
      {
        "nomNaissance": "BOBO",
        "nomUsuel": "BOBO",
        "prenoms": "Izumi",
        "anneeDateDeNaissance": "2019",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "15",
        "sexe": "F"
      },
      {
        "nomNaissance": "BOBO",
        "nomUsuel": "BOBO",
        "prenoms": "Arata",
        "anneeDateDeNaissance": "2021",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "05",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur et Madame Jacob BOBO",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "1 RUE DE LILLE",
      "lieuDit": null,
      "codePostalVille": "75001 PARIS",
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
* [france_connect_200_msa_1_parent_1_mineur_2_majeurs.yml](france_connect_200_msa_1_parent_1_mineur_2_majeurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "ELSA"
    ],
    "nomNaissance": "PLACARD",
    "anneeDateDeNaissance": 1987,
    "moisDateDeNaissance": 4,
    "jourDateDeNaissance": 13,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "59226",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "PLACARD",
        "nomUsuel": "DUBOIS",
        "prenoms": "ELSA",
        "anneeDateDeNaissance": "1987",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "13",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
        "prenoms": "Alex",
        "anneeDateDeNaissance": "1999",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
        "prenoms": "Léo",
        "anneeDateDeNaissance": "2000",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
        "prenoms": "Alice",
        "anneeDateDeNaissance": "2024",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "02",
        "sexe": "F"
      }
    ],
    "adresse": {
      "identite": "Monsieur Elsa DUBOIS",
      "complementInformation": "Batiment 2",
      "complementInformationGeographique": "Porte 8",
      "numeroLibelleVoie": "20 AVENUE DE SEGUR",
      "lieuDit": "Lieu dit",
      "codePostalVille": "75107 PARIS",
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
* [france_connect_200_msa_2_parents_3_mineurs_1_prenom_compose_tiret.yml](france_connect_200_msa_2_parents_3_mineurs_1_prenom_compose_tiret.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "PIERRE-ALAIN",
      "MURIEL",
      "FLORIANT"
    ],
    "nomNaissance": "ECETINSI",
    "anneeDateDeNaissance": 2009,
    "moisDateDeNaissance": 7,
    "jourDateDeNaissance": 14,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "63220",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "ECETINSI",
        "nomUsuel": "ECETINSI",
        "prenoms": "PIERRE-ALAIN MURIEL FLORIANT",
        "anneeDateDeNaissance": "2009",
        "moisDateDeNaissance": "07",
        "jourDateDeNaissance": "14",
        "sexe": "M"
      },
      {
        "nomNaissance": "SUVE",
        "nomUsuel": "ECETINSI",
        "prenoms": "MELINDA",
        "anneeDateDeNaissance": "2009",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "14",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "ECETINSI",
        "nomUsuel": "ECETINSI",
        "prenoms": "Alberto",
        "anneeDateDeNaissance": "2024",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "ECETINSI",
        "nomUsuel": "ECETINSI",
        "prenoms": "Henrico",
        "anneeDateDeNaissance": "2023",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "ECETINSI",
        "nomUsuel": "ECETINSI",
        "prenoms": "Gustave",
        "anneeDateDeNaissance": "2021",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "12",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur et Madame Pierre-Alain ECETINSI",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "6 Rue Firmin Gillot",
      "lieuDit": null,
      "codePostalVille": "75015 PARIS",
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
* [france_connect_200_msa_2_parents_3_mineurs_dont_1_naissance_00.yml](france_connect_200_msa_2_parents_3_mineurs_dont_1_naissance_00.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Titouan"
    ],
    "nomNaissance": "REVEIL",
    "anneeDateDeNaissance": 1998,
    "moisDateDeNaissance": 6,
    "jourDateDeNaissance": 18,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "98729",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "REVEIL",
        "nomUsuel": "REVEIL",
        "prenoms": "Titouan",
        "anneeDateDeNaissance": "1998",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "18",
        "sexe": "M"
      },
      {
        "nomNaissance": "NGUYEN",
        "nomUsuel": "REVEIL",
        "prenoms": "LEE",
        "anneeDateDeNaissance": "1999",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "25",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "REVEIL",
        "nomUsuel": "REVEIL",
        "prenoms": "Cheng",
        "anneeDateDeNaissance": "2020",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "03",
        "sexe": "M"
      },
      {
        "nomNaissance": "REVEIL",
        "nomUsuel": "REVEIL",
        "prenoms": "Bo",
        "anneeDateDeNaissance": "2021",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "02",
        "sexe": "M"
      },
      {
        "nomNaissance": "REVEIL",
        "nomUsuel": "REVEIL",
        "prenoms": "Fu",
        "anneeDateDeNaissance": "2020",
        "moisDateDeNaissance": "00",
        "jourDateDeNaissance": "00",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur Titouan REVEIL",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "Cours des 50 Otages",
      "lieuDit": null,
      "codePostalVille": "44109 NANTES",
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
* [france_connect_200_msa_2_parents_3_mineurs_dont_1_naissance_inconnue_chaine_vide.yml](france_connect_200_msa_2_parents_3_mineurs_dont_1_naissance_inconnue_chaine_vide.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Lady",
      "Di"
    ],
    "nomNaissance": "NUM",
    "anneeDateDeNaissance": 1962,
    "moisDateDeNaissance": 8,
    "jourDateDeNaissance": 24,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "29200",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "NUM",
        "nomUsuel": "MASARU",
        "prenoms": "Lady Di",
        "anneeDateDeNaissance": "1962",
        "moisDateDeNaissance": "08",
        "jourDateDeNaissance": "24",
        "sexe": "F"
      },
      {
        "nomNaissance": "MASARU",
        "nomUsuel": "MASARU",
        "prenoms": "Emoto",
        "anneeDateDeNaissance": "1970",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "03",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "MASARU",
        "nomUsuel": "MASARU",
        "prenoms": "Rina",
        "anneeDateDeNaissance": "2016",
        "moisDateDeNaissance": "03",
        "jourDateDeNaissance": "01",
        "sexe": "F"
      },
      {
        "nomNaissance": "MASARU",
        "nomUsuel": "MASARU",
        "prenoms": "Akihiro",
        "anneeDateDeNaissance": "2014",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "08",
        "sexe": "M"
      },
      {
        "nomNaissance": "MASARU",
        "nomUsuel": "MASARU",
        "prenoms": "Haru",
        "anneeDateDeNaissance": "",
        "moisDateDeNaissance": "",
        "jourDateDeNaissance": "",
        "sexe": "M"
      }
    ],
    "adresse": {
      "identite": "Monsieur Emoto MASARU",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "Cours des 50 Otages",
      "lieuDit": null,
      "codePostalVille": "44109 NANTES",
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
* [france_connect_200_msa_2_parents_5_mineurs.yml](france_connect_200_msa_2_parents_5_mineurs.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "CINDY"
    ],
    "nomNaissance": "COMMODE",
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 6,
    "jourDateDeNaissance": 27,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "57431",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "COMMODE",
        "nomUsuel": "LEMAITRE",
        "prenoms": "CINDY",
        "anneeDateDeNaissance": "1980",
        "moisDateDeNaissance": "06",
        "jourDateDeNaissance": "27",
        "sexe": "F"
      },
      {
        "nomNaissance": "LEMAITRE",
        "nomUsuel": "LEMAITRE",
        "prenoms": "FRANCK",
        "anneeDateDeNaissance": "1990",
        "moisDateDeNaissance": "12",
        "jourDateDeNaissance": "30",
        "sexe": "M"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "LEMAITRE",
        "nomUsuel": "LEMAITRE",
        "prenoms": "Gaston",
        "anneeDateDeNaissance": "2021",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "LEMAITRE",
        "nomUsuel": "LEMAITRE",
        "prenoms": "Henri",
        "anneeDateDeNaissance": "2021",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "LEMAITRE",
        "nomUsuel": "LEMAITRE",
        "prenoms": "Robert",
        "anneeDateDeNaissance": "2021",
        "moisDateDeNaissance": "05",
        "jourDateDeNaissance": "01",
        "sexe": "M"
      },
      {
        "nomNaissance": "LEMAITRE",
        "nomUsuel": "LEMAITRE",
        "prenoms": "Hugo",
        "anneeDateDeNaissance": "2022",
        "moisDateDeNaissance": "04",
        "jourDateDeNaissance": "30",
        "sexe": "M"
      },
      {
        "nomNaissance": "LEMAITRE",
        "nomUsuel": "LEMAITRE",
        "prenoms": "Lucie",
        "anneeDateDeNaissance": "2023",
        "moisDateDeNaissance": "10",
        "jourDateDeNaissance": "01",
        "sexe": "F"
      }
    ],
    "adresse": {
      "identite": "Monsieur Franck LEMAITRE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "20 AVENUE DE SEGUR",
      "lieuDit": null,
      "codePostalVille": "75107 PARIS",
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
    "prenoms": [
      "Angela",
      "Claire",
      "Louise"
    ],
    "nomNaissance": "DUBOIS",
    "anneeDateDeNaissance": 1962,
    "moisDateDeNaissance": 8,
    "jourDateDeNaissance": 24,
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
    "regime": "CNAF",
    "allocataires": [
      {
        "nomNaissance": "DUBOIS",
        "nomUsuel": "DUBOIS",
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
      "codePostalVille": "75002 PARIS",
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
* [france_connect_error.yml](france_connect_error.yml)

  Status `200`

  Cas de test pour QFv2 avec jeton FranceConnect.
Les données proviennent des jetons de l'environnement de test FranceConnect.
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "THIBAULT"
    ],
    "nomNaissance": "TABLE",
    "anneeDateDeNaissance": 1990,
    "moisDateDeNaissance": 2,
    "jourDateDeNaissance": 13,
    "sexe": "M",
    "codeInseeLieuDeNaissance": "75116",
    "codePaysLieuDeNaissance": "99100"
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
        "nomNaissance": "TABLE",
        "nomUsuel": "TABLE",
        "prenoms": "THIBAULT",
        "anneeDateDeNaissance": "1990",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "13",
        "sexe": "M"
      },
      {
        "nomNaissance": "FIBRE",
        "nomUsuel": "TABLE",
        "prenoms": "Elodie",
        "anneeDateDeNaissance": "1989",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "02",
        "sexe": "F"
      }
    ],
    "enfants": [
      {
        "nomNaissance": "TABLE",
        "nomUsuel": "TABLE",
        "prenoms": "Emma",
        "anneeDateDeNaissance": "2020",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "F"
      },
      {
        "nomNaissance": "TABLE",
        "nomUsuel": "TABLE",
        "prenoms": "Rose",
        "anneeDateDeNaissance": "2022",
        "moisDateDeNaissance": "01",
        "jourDateDeNaissance": "01",
        "sexe": "F"
      },
      {
        "nomNaissance": "TABLE",
        "nomUsuel": "TABLE",
        "prenoms": "Jade",
        "anneeDateDeNaissance": "2024",
        "moisDateDeNaissance": "02",
        "jourDateDeNaissance": "02",
        "sexe": "F"
      }
    ],
    "adresse": {
      "identite": "Monsieur et Madame Thibault TABLE",
      "complementInformation": null,
      "complementInformationGeographique": null,
      "numeroLibelleVoie": "20 AVENUE DE SEGUR",
      "lieuDit": null,
      "codePostalVille": "75107 PARIS",
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
