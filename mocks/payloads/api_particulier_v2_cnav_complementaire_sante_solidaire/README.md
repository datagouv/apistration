# Statut complémentaire santé solidaire (C2S)
* [200-beneficiaire_avec_participation-feminin.yaml](200-beneficiaire_avec_participation-feminin.yaml)

  Status `200`

  ## Bénéficiaire AVEC participation financière - féminin

Ce cas permet de tester :
- [Param. appel] lieu de naissance en France
- [Param. appel] sexe féminin
- [Param. appel] Deux prénoms
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire AVEC participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "F",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "JEANNE",
      "LAURE"
    ],
    "anneeDateDeNaissance": 1993,
    "moisDateDeNaissance": 8
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire_avec_participation_financiere",
    "dateDebut": "2023-06-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' -d 'nomNaissance=DUPONT' -d 'prenoms[]=JEANNE' -d 'prenoms[]=LAURE' -d 'anneeDateDeNaissance=1993' -d 'moisDateDeNaissance=8' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200-beneficiaire_sans_participation-masculin-pays_etranger.yaml](200-beneficiaire_sans_participation-masculin-pays_etranger.yaml)

  Status `200`

  ## Bénéficiaire SANS participation financière - masculin - né dans un pays étranger

Ce cas permet de tester :
- [Param. appel] Pays de naissance autre que la France
- [Param. appel] sexe masculin
- [Param. appel] Deux prénoms
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "08481",
    "codePaysLieuDeNaissance": "99127",
    "sexe": "M",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "PIERRE",
      "PAUL"
    ],
    "anneeDateDeNaissance": 1984,
    "moisDateDeNaissance": 12
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2023-02-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'codeInseeLieuDeNaissance=08481' -d 'codePaysLieuDeNaissance=99127' -d 'sexe=M' -d 'nomNaissance=DUPONT' -d 'prenoms[]=PIERRE' -d 'prenoms[]=PAUL' -d 'anneeDateDeNaissance=1984' -d 'moisDateDeNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200-non-beneficiaire_masculin.yaml](200-non-beneficiaire_masculin.yaml)

  Status `200`

  ## Non bénéficiaire - masculin

Ce cas permet de tester :
- [Param. appel] lieu de naissance en France
- [Param. appel] sexe masculin
- [Réponse] statut non-bénéficiaire de la complémentaire santé solidaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeInseeLieuDeNaissance": "08480",
    "codePaysLieuDeNaissance": "99100",
    "sexe": "M",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "PIERRE"
    ],
    "anneeDateDeNaissance": 1966,
    "moisDateDeNaissance": 6
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "non_beneficiaire_css",
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
    -G -d 'codeInseeLieuDeNaissance=08480' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' -d 'nomNaissance=DUPONT' -d 'prenoms[]=PIERRE' -d 'anneeDateDeNaissance=1966' -d 'moisDateDeNaissance=6' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_participation_financiere_femme_2.yaml](200_beneficiaire_sans_participation_financiere_femme_2.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "TOUR",
    "prenoms": [
      "LIDIA"
    ],
    "anneeDateDeNaissance": 1970,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2025-01-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=TOUR' -d 'prenoms[]=LIDIA' -d 'anneeDateDeNaissance=1970' -d 'moisDateDeNaissance=1' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_participation_financiere_femme_3.yaml](200_beneficiaire_sans_participation_financiere_femme_3.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "LILLE",
    "prenoms": [
      "SARA"
    ],
    "anneeDateDeNaissance": 1958,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2021-03-12",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=LILLE' -d 'prenoms[]=SARA' -d 'anneeDateDeNaissance=1958' -d 'moisDateDeNaissance=1' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_participation_financiere_femme_4.yaml](200_beneficiaire_sans_participation_financiere_femme_4.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "SABRI",
    "nomNaissance": "CHANI",
    "prenoms": [
      "LOLA"
    ],
    "anneeDateDeNaissance": 1970,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2023-05-31",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=SABRI' -d 'nomNaissance=CHANI' -d 'prenoms[]=LOLA' -d 'anneeDateDeNaissance=1970' -d 'moisDateDeNaissance=1' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_participation_financiere_femme_5.yaml](200_beneficiaire_sans_participation_financiere_femme_5.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "BOULIN",
    "prenoms": [
      "LAURA"
    ],
    "anneeDateDeNaissance": 1999,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-02-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=BOULIN' -d 'prenoms[]=LAURA' -d 'anneeDateDeNaissance=1999' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_participation_financiere_femme_6.yaml](200_beneficiaire_sans_participation_financiere_femme_6.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MATEUS",
    "prenoms": [
      "SOPHIA"
    ],
    "anneeDateDeNaissance": 1990,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 12,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-01-15",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=MATEUS' -d 'prenoms[]=SOPHIA' -d 'anneeDateDeNaissance=1990' -d 'moisDateDeNaissance=11' -d 'jourDateDeNaissance=12' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_participation_financiere_femme_7.yaml](200_beneficiaire_sans_participation_financiere_femme_7.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "CARENA",
    "prenoms": [
      "EMMA"
    ],
    "anneeDateDeNaissance": 1998,
    "moisDateDeNaissance": 7,
    "jourDateDeNaissance": 18,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-09-01",
    "dateFin": "2025-09-01"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=CARENA' -d 'prenoms[]=EMMA' -d 'anneeDateDeNaissance=1998' -d 'moisDateDeNaissance=7' -d 'jourDateDeNaissance=18' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [200_beneficiaire_sans_participation_financiere_femme_8.yaml](200_beneficiaire_sans_participation_financiere_femme_8.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "TATOUILLE",
    "prenoms": [
      "LAURA"
    ],
    "anneeDateDeNaissance": 1996,
    "moisDateDeNaissance": 2,
    "jourDateDeNaissance": 11,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-08-01",
    "dateFin": "2025-08-01"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=TATOUILLE' -d 'prenoms[]=LAURA' -d 'anneeDateDeNaissance=1996' -d 'moisDateDeNaissance=2' -d 'jourDateDeNaissance=11' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [400.yaml](400.yaml)

  Status `400`

  # Bad Request - 400
Ce cas permet de tester :
  - [Param. appel] Nom de naissance
  - [Param. appel] Prénom
  - [Param. appel] Date de naissance (jour,mois,année)
  - [Param. appel] sexe féminin
  - [Réponse] mauvaise requête

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUPONT",
    "prenoms": [
      "LAURE"
    ],
    "anneeDateDeNaissance": 1970,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "error": "bad_request",
    "reason": " Le serveur ne peut pas la requête en raison de quelque chose qui est perçu comme une erreur du client.",
    "message": "Le serveur ne peut pas la requête en raison de quelque chose qui est perçu comme une erreur du client."
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=DUPONT' -d 'prenoms[]=LAURE' -d 'anneeDateDeNaissance=1970' -d 'moisDateDeNaissance=1' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
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
    "nomNaissance": "DUBOCHE",
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
    -G -d 'nomNaissance=DUBOCHE' -d 'codeInseeLieuDeNaissance=00404' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
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
    "nomNaissance": "DUBOCHE",
    "prenoms": [
      "JEROME"
    ],
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
    -G -d 'nomNaissance=DUBOCHE' -d 'prenoms[]=JEROME' -d 'codeInseeLieuDeNaissance=00503' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  # Gateway Timeout - 504
Ce cas permet de tester :
  - [Réponse] Délai d’attente dépassé avec un flux partenaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTIN",
    "prenoms": [
      "PAUL"
    ],
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 6,
    "jourDateDeNaissance": 15,
    "codeInseeLieuDeNaissance": "75056",
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
    "error": "gateway_timeout",
    "reason": "Le serveur n’a pas reçu de réponse à temps d’un service tiers.",
    "message": "Le délai d’attente pour la réponse du partenaire a été dépassé."
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=MARTIN' -d 'prenoms[]=PAUL' -d 'anneeDateDeNaissance=1980' -d 'moisDateDeNaissance=6' -d 'jourDateDeNaissance=15' -d 'codeInseeLieuDeNaissance=75056' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [TST_404.yaml](TST_404.yaml)

  Status `404`

  ## retour 404

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 1 prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] 404

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "QUATRECENTQUATRE",
    "nomNaissance": "TEST",
    "prenoms": [
      "PRENOM"
    ],
    "anneeDateDeNaissance": 1978,
    "moisDateDeNaissance": 4,
    "jourDateDeNaissance": 4,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "error_404",
    "reason": "dossier_introuvable",
    "message": "dossier_introuvable"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=QUATRECENTQUATRE' -d 'nomNaissance=TEST' -d 'prenoms[]=PRENOM' -d 'anneeDateDeNaissance=1978' -d 'moisDateDeNaissance=4' -d 'jourDateDeNaissance=4' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_avec_participation_financiere_etranger_femme_200.yml](beneficiaire_avec_participation_financiere_etranger_femme_200.yml)

  Status `200`

  ## Bénéficiaire né à l'étranger sans participation financière femme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Deux prénoms
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "PLUSSE",
    "nomNaissance": "GERVINAT",
    "prenoms": [
      "MADELEINE",
      "LEA"
    ],
    "anneeDateDeNaissance": 1976,
    "moisDateDeNaissance": 8,
    "jourDateDeNaissance": 24,
    "codePaysLieuDeNaissance": "99131",
    "sexe": "F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-10-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=PLUSSE' -d 'nomNaissance=GERVINAT' -d 'prenoms[]=MADELEINE' -d 'prenoms[]=LEA' -d 'anneeDateDeNaissance=1976' -d 'moisDateDeNaissance=8' -d 'jourDateDeNaissance=24' -d 'codePaysLieuDeNaissance=99131' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_avec_participation_financiere_etranger_femme_200_2.yml](beneficiaire_avec_participation_financiere_etranger_femme_200_2.yml)

  Status `200`

  ## Bénéficiaire né à l'étranger sans participation financière femme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Un prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "MIREL",
    "nomNaissance": "VAUBAN",
    "prenoms": [
      "VICTOIRE"
    ],
    "anneeDateDeNaissance": 1966,
    "moisDateDeNaissance": 3,
    "jourDateDeNaissance": 5,
    "codePaysLieuDeNaissance": "99216",
    "sexe": "F"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2023-08-25",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=MIREL' -d 'nomNaissance=VAUBAN' -d 'prenoms[]=VICTOIRE' -d 'anneeDateDeNaissance=1966' -d 'moisDateDeNaissance=3' -d 'jourDateDeNaissance=5' -d 'codePaysLieuDeNaissance=99216' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_avec_participation_financiere_femme_200.yml](beneficiaire_avec_participation_financiere_femme_200.yml)

  Status `200`

  ## Bénéficiaire avec participation financière femme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Deux prénoms
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire AVEC participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "DUPUIS",
    "nomNaissance": "CARTIER",
    "prenoms": [
      "CELINE",
      "MARIE"
    ],
    "anneeDateDeNaissance": 1980,
    "moisDateDeNaissance": 10,
    "jourDateDeNaissance": 10,
    "codeInseeLieuDeNaissance": "75056",
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
    "status": "beneficiaire_avec_participation_financiere",
    "dateDebut": "2024-06-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=DUPUIS' -d 'nomNaissance=CARTIER' -d 'prenoms[]=CELINE' -d 'prenoms[]=MARIE' -d 'anneeDateDeNaissance=1980' -d 'moisDateDeNaissance=10' -d 'jourDateDeNaissance=10' -d 'codeInseeLieuDeNaissance=75056' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_femme_200_futur_proche.yml](beneficiaire_sans_participation_financiere_femme_200_futur_proche.yml)

  Status `200`

  ## Bénéficiaire sans participation financière femme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "KIRBO",
    "prenoms": [
      "ELOISE"
    ],
    "anneeDateDeNaissance": 1995,
    "moisDateDeNaissance": 6,
    "jourDateDeNaissance": 22,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-04-20",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=KIRBO' -d 'prenoms[]=ELOISE' -d 'anneeDateDeNaissance=1995' -d 'moisDateDeNaissance=6' -d 'jourDateDeNaissance=22' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200.yml](beneficiaire_sans_participation_financiere_homme_200.yml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 3 prénoms
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "LEDIEU",
    "nomNaissance": "FALLENDE",
    "prenoms": [
      "PIERRE",
      "GAUTIER",
      "HARRY"
    ],
    "anneeDateDeNaissance": 1950,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-08-25",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=LEDIEU' -d 'nomNaissance=FALLENDE' -d 'prenoms[]=PIERRE' -d 'prenoms[]=GAUTIER' -d 'prenoms[]=HARRY' -d 'anneeDateDeNaissance=1950' -d 'moisDateDeNaissance=1' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_10.yaml](beneficiaire_sans_participation_financiere_homme_200_10.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "ASSIN",
    "prenoms": [
      "MARC"
    ],
    "anneeDateDeNaissance": 2003,
    "moisDateDeNaissance": 2,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-06-10",
    "dateFin": "2025-06-10"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=ASSIN' -d 'prenoms[]=MARC' -d 'anneeDateDeNaissance=2003' -d 'moisDateDeNaissance=2' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_11.yaml](beneficiaire_sans_participation_financiere_homme_200_11.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DALORS",
    "prenoms": [
      "OMER"
    ],
    "anneeDateDeNaissance": 2003,
    "moisDateDeNaissance": 2,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-12-01",
    "dateFin": "2025-12-01"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=DALORS' -d 'prenoms[]=OMER' -d 'anneeDateDeNaissance=2003' -d 'moisDateDeNaissance=2' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_2.yml](beneficiaire_sans_participation_financiere_homme_200_2.yml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 1 prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "HUSTER",
    "nomNaissance": "BOISSON",
    "prenoms": [
      "FRANCIS"
    ],
    "anneeDateDeNaissance": 1978,
    "moisDateDeNaissance": 4,
    "jourDateDeNaissance": 4,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-08-25",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=HUSTER' -d 'nomNaissance=BOISSON' -d 'prenoms[]=FRANCIS' -d 'anneeDateDeNaissance=1978' -d 'moisDateDeNaissance=4' -d 'jourDateDeNaissance=4' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_3.yml](beneficiaire_sans_participation_financiere_homme_200_3.yml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 1 prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "TRIMARD",
    "prenoms": [
      "FAYCAL"
    ],
    "anneeDateDeNaissance": 2000,
    "moisDateDeNaissance": 9,
    "jourDateDeNaissance": 5,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-08-30",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=TRIMARD' -d 'prenoms[]=FAYCAL' -d 'anneeDateDeNaissance=2000' -d 'moisDateDeNaissance=9' -d 'jourDateDeNaissance=5' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_4.yml](beneficiaire_sans_participation_financiere_homme_200_4.yml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 1 prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DEVRED",
    "prenoms": [
      "MARC"
    ],
    "anneeDateDeNaissance": 1988,
    "moisDateDeNaissance": 7,
    "jourDateDeNaissance": 13,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-11-05",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=DEVRED' -d 'prenoms[]=MARC' -d 'anneeDateDeNaissance=1988' -d 'moisDateDeNaissance=7' -d 'jourDateDeNaissance=13' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_5.yaml](beneficiaire_sans_participation_financiere_homme_200_5.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200

Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] 1 prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "RECETTECOMMUNAUTAIRE",
    "prenoms": [
      "LEON"
    ],
    "anneeDateDeNaissance": 1968,
    "moisDateDeNaissance": 4,
    "jourDateDeNaissance": 5,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-09-05",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=RECETTECOMMUNAUTAIRE' -d 'prenoms[]=LEON' -d 'anneeDateDeNaissance=1968' -d 'moisDateDeNaissance=4' -d 'jourDateDeNaissance=5' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_6.yaml](beneficiaire_sans_participation_financiere_homme_200_6.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "PEUPLU",
    "prenoms": [
      "JEAN"
    ],
    "anneeDateDeNaissance": 2000,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-03-05",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=PEUPLU' -d 'prenoms[]=JEAN' -d 'anneeDateDeNaissance=2000' -d 'moisDateDeNaissance=1' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_7.yaml](beneficiaire_sans_participation_financiere_homme_200_7.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "COVER",
    "prenoms": [
      "HARRY"
    ],
    "anneeDateDeNaissance": 1999,
    "moisDateDeNaissance": 10,
    "jourDateDeNaissance": 12,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-03-31",
    "dateFin": "2025-03-31"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=COVER' -d 'prenoms[]=HARRY' -d 'anneeDateDeNaissance=1999' -d 'moisDateDeNaissance=10' -d 'jourDateDeNaissance=12' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_8.yaml](beneficiaire_sans_participation_financiere_homme_200_8.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "VAMAL",
    "prenoms": [
      "YVES"
    ],
    "anneeDateDeNaissance": 1987,
    "moisDateDeNaissance": 7,
    "jourDateDeNaissance": 13,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2025-06-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=VAMAL' -d 'prenoms[]=YVES' -d 'anneeDateDeNaissance=1987' -d 'moisDateDeNaissance=7' -d 'jourDateDeNaissance=13' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_9.yaml](beneficiaire_sans_participation_financiere_homme_200_9.yaml)

  Status `200`

  ## Bénéficiaire sans participation financière homme - 200


Ce cas permet de tester :
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "TATOUILLE",
    "prenoms": [
      "RAT"
    ],
    "anneeDateDeNaissance": 2001,
    "moisDateDeNaissance": 3,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-08-01",
    "dateFin": "2025-08-01"
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=TATOUILLE' -d 'prenoms[]=RAT' -d 'anneeDateDeNaissance=2001' -d 'moisDateDeNaissance=3' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_futur.yml](beneficiaire_sans_participation_financiere_homme_200_futur.yml)

  Status `200`

  ## Bénéficiaire sans participation financière homme dans le futur - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 2 Prénoms
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "MOLIERE",
    "nomNaissance": "POQUELIN",
    "prenoms": [
      "JEAN",
      "BAPTISTE"
    ],
    "anneeDateDeNaissance": 1973,
    "moisDateDeNaissance": 2,
    "jourDateDeNaissance": 17,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2026-09-29",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=MOLIERE' -d 'nomNaissance=POQUELIN' -d 'prenoms[]=JEAN' -d 'prenoms[]=BAPTISTE' -d 'anneeDateDeNaissance=1973' -d 'moisDateDeNaissance=2' -d 'jourDateDeNaissance=17' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [beneficiaire_sans_participation_financiere_homme_200_futur_proche.yml](beneficiaire_sans_participation_financiere_homme_200_futur_proche.yml)

  Status `200`

  ## Bénéficiaire sans participation financière homme dans un futur trop proche - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire SANS participation financière

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "GARE",
    "nomNaissance": "GEANT",
    "prenoms": [
      "GARY"
    ],
    "anneeDateDeNaissance": 1950,
    "moisDateDeNaissance": 1,
    "jourDateDeNaissance": 1,
    "codeInseeLieuDeNaissance": "44109",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2024-03-02",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=GARE' -d 'nomNaissance=GEANT' -d 'prenoms[]=GARY' -d 'anneeDateDeNaissance=1950' -d 'moisDateDeNaissance=1' -d 'jourDateDeNaissance=1' -d 'codeInseeLieuDeNaissance=44109' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [dossier_allocataire_inexistant_404.yml](dossier_allocataire_inexistant_404.yml)

  Status `404`

  ## Dossier complémentaire inexistant - 404

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Un prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] Dossier complémentaire inexistant

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "LEGRAND",
    "nomNaissance": "LEROI",
    "prenoms": [
      "ARTHUR"
    ],
    "anneeDateDeNaissance": 1995,
    "moisDateDeNaissance": 12,
    "jourDateDeNaissance": 22,
    "codeInseeLieuDeNaissance": "75056",
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
    -G -d 'nomUsage=LEGRAND' -d 'nomNaissance=LEROI' -d 'prenoms[]=ARTHUR' -d 'anneeDateDeNaissance=1995' -d 'moisDateDeNaissance=12' -d 'jourDateDeNaissance=22' -d 'codeInseeLieuDeNaissance=75056' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [erreur_fournisseur_503.yml](erreur_fournisseur_503.yml)

  Status `503`

  ## Erreur du fournisseur - 503

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Un prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] 

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "LAGRANDE",
    "nomNaissance": "LAREINE",
    "prenoms": [
      "ELIZABETH"
    ],
    "anneeDateDeNaissance": 1988,
    "moisDateDeNaissance": 4,
    "jourDateDeNaissance": 2,
    "codeInseeLieuDeNaissance": "75056",
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
    "code": "37999",
    "title": "Erreur inconnue du fournisseur de données",
    "detail": "La réponse retournée par le fournisseur de données est invalide et inconnue de notre service. L'équipe technique a été notifiée de cette erreur pour investigation.",
    "source": null,
    "meta": {
      "provider": "CNAV"
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "X-Api-Key: $token" \
    -G -d 'nomUsage=LAGRANDE' -d 'nomNaissance=LAREINE' -d 'prenoms[]=ELIZABETH' -d 'anneeDateDeNaissance=1988' -d 'moisDateDeNaissance=4' -d 'jourDateDeNaissance=2' -d 'codeInseeLieuDeNaissance=75056' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=F' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
* [fake_france_connect_cnaf.yml](fake_france_connect_cnaf.yml)

  Status `200`

  Cas de test pour CSS avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/cnaf_css.yml).
L'endpoint est appellé avec le jeton FranceConnect + le recipient.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "prenoms": [
      "Georges"
    ],
    "nomUsage": "MARTIN",
    "nomNaissance": "CNAF",
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2021-05-05",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_cnaf_2.yml](fake_france_connect_cnaf_2.yml)

  Status `200`

  Cas de test pour CSS avec jeton FranceConnect.
Les données proviennent de [nos propres jetons FranceConnect de test](../france_connect/cnaf_css.yml).
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2021-05-05",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_cnaf.yml](france_connect_cnaf.yml)

  Status `200`

  Cas de test pour CSS avec jeton FranceConnect.
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
    "status": "beneficiaire_sans_participation_financiere",
    "dateDebut": "2023-02-01",
    "dateFin": null
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire?recipient=13002526500013"
  ```

  </p>
  </details>
* [non_beneficaire_css_homme_200.yml](non_beneficaire_css_homme_200.yml)

  Status `200`

  ## Non-bénéficiaire homme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 2 prénoms
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Réponse] Non bénéficiaire de la complémentaire santé solidaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomUsage": "VERTIN",
    "nomNaissance": "HUBOT",
    "prenoms": [
      "PIERRE-MARIE",
      "JEREMY"
    ],
    "anneeDateDeNaissance": 1968,
    "moisDateDeNaissance": 11,
    "jourDateDeNaissance": 15,
    "codeInseeLieuDeNaissance": "33063",
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
    "status": "non_beneficiaire_css",
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
    -G -d 'nomUsage=VERTIN' -d 'nomNaissance=HUBOT' -d 'prenoms[]=PIERRE-MARIE' -d 'prenoms[]=JEREMY' -d 'anneeDateDeNaissance=1968' -d 'moisDateDeNaissance=11' -d 'jourDateDeNaissance=15' -d 'codeInseeLieuDeNaissance=33063' -d 'codePaysLieuDeNaissance=99100' -d 'sexe=M' \
    --url "https://staging.particulier.api.gouv.fr/api/v2/complementaire-sante-solidaire"
  ```

  </p>
  </details>
