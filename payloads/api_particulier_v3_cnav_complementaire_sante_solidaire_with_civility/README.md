# [Identité] Statut complémentaire santé solidaire (C2S)
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
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "JEANNE",
      "LAURE"
    ],
    "anneeDateNaissance": 1993,
    "moisDateNaissance": 8
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
      "avec_participation": true,
      "date_debut_droit": "2023-06-01"
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
    -G -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=DUPONT' -d 'prenoms[]=JEANNE' -d 'prenoms[]=LAURE' -d 'anneeDateNaissance=1993' -d 'moisDateNaissance=8' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "codeCogInseeCommuneNaissance": "08481",
    "codeCogInseePaysNaissance": "99127",
    "sexeEtatCivil": "M",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "PIERRE",
      "PAUL"
    ],
    "anneeDateNaissance": 1984,
    "moisDateNaissance": 12
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
      "avec_participation": false,
      "date_debut_droit": "2023-02-01"
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
    -G -d 'codeCogInseeCommuneNaissance=08481' -d 'codeCogInseePaysNaissance=99127' -d 'sexeEtatCivil=M' -d 'nomNaissance=DUPONT' -d 'prenoms[]=PIERRE' -d 'prenoms[]=PAUL' -d 'anneeDateNaissance=1984' -d 'moisDateNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "DUPONT",
    "prenoms": [
      "PIERRE"
    ],
    "anneeDateNaissance": 1966,
    "moisDateNaissance": 6
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
      "avec_participation": false,
      "date_debut_droit": null
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
    -G -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=DUPONT' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1966' -d 'moisDateNaissance=6' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=DUBOCHE' -d 'prenoms[]=JEROME' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
        "meta": {
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
    -G -d 'nomNaissance=DESFOUIN' -d 'prenoms[]=Ren%C3%A9' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=DELANOUE' -d 'prenoms[]=Jean-Marie' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
  curl -H "X-Api-Key: $token" \
    -G -d 'nomNaissance=SITUDI' -d 'prenoms[]=Cl%C3%A9ment' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [beneficiaire_avec_participation_financiere_etranger_femme_200.yml](beneficiaire_avec_participation_financiere_etranger_femme_200.yml)

  Status `200`

  ## Bénéficiaire né à l'étranger avec participation financière femme - 200

Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] Deux prénoms
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe féminin
- [Réponse] statut bénéficiaire de la complémentaire santé solidaire participation financière

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
    "anneeDateNaissance": 1976,
    "moisDateNaissance": 8,
    "jourDateNaissance": 24,
    "codeCogInseePaysNaissance": "99131",
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
      "est_beneficiaire": true,
      "avec_participation": true,
      "date_debut_droit": "2024-10-01"
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
    -G -d 'nomUsage=PLUSSE' -d 'nomNaissance=GERVINAT' -d 'prenoms[]=MADELEINE' -d 'prenoms[]=LEA' -d 'anneeDateNaissance=1976' -d 'moisDateNaissance=8' -d 'jourDateNaissance=24' -d 'codeCogInseePaysNaissance=99131' -d 'sexeEtatCivil=F' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1966,
    "moisDateNaissance": 3,
    "jourDateNaissance": 5,
    "codeCogInseePaysNaissance": "99216",
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
      "est_beneficiaire": true,
      "avec_participation": true,
      "date_debut_droit": "2023-08-25"
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
    -G -d 'nomUsage=MIREL' -d 'nomNaissance=VAUBAN' -d 'prenoms[]=VICTOIRE' -d 'anneeDateNaissance=1966' -d 'moisDateNaissance=3' -d 'jourDateNaissance=5' -d 'codeCogInseePaysNaissance=99216' -d 'sexeEtatCivil=F' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1980,
    "moisDateNaissance": 10,
    "jourDateNaissance": 10,
    "codeCogInseeCommuneNaissance": "75056",
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
      "est_beneficiaire": true,
      "avec_participation": true,
      "date_debut_droit": "2024-06-01"
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
    -G -d 'nomUsage=DUPUIS' -d 'nomNaissance=CARTIER' -d 'prenoms[]=CELINE' -d 'prenoms[]=MARIE' -d 'anneeDateNaissance=1980' -d 'moisDateNaissance=10' -d 'jourDateNaissance=10' -d 'codeCogInseeCommuneNaissance=75056' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeNateNaissance": 1950,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "codeCogInseeCommuneNaissance": "44109",
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
      "avec_participation": false,
      "date_debut_droit": "2024-08-25"
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
    -G -d 'nomUsage=LEDIEU' -d 'nomNaissance=FALLENDE' -d 'prenoms[]=PIERRE' -d 'prenoms[]=GAUTIER' -d 'prenoms[]=HARRY' -d 'anneeNateNaissance=1950' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1978,
    "moisDateNaissance": 4,
    "jourDateNaissance": 4,
    "codeCogInseeCommuneNaissance": "44109",
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
      "avec_participation": false,
      "date_debut_droit": "2024-08-25"
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
    -G -d 'nomUsage=HUSTER' -d 'nomNaissance=BOISSON' -d 'prenoms[]=FRANCIS' -d 'anneeDateNaissance=1978' -d 'moisDateNaissance=4' -d 'jourDateNaissance=4' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 9,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "44109",
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
      "avec_participation": false,
      "date_debut_droit": "2024-08-30"
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
    -G -d 'nomNaissance=TRIMARD' -d 'prenoms[]=FAYCAL' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=9' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1988,
    "moisDateNaissance": 7,
    "jourDateNaissance": 13,
    "codeCogInseeCommuneNaissance": "44109",
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
      "avec_participation": false,
      "date_debut_droit": "2024-11-05"
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
    -G -d 'nomNaissance=DEVRED' -d 'prenoms[]=MARC' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=7' -d 'jourDateNaissance=13' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1968,
    "moisDateNaissance": 4,
    "jourDateNaissance": 5,
    "codeCogInseeCommuneNaissance": "44109",
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
      "avec_participation": false,
      "date_debut_droit": "2024-09-05"
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
    -G -d 'nomNaissance=RECETTECOMMUNAUTAIRE' -d 'prenoms[]=LEON' -d 'anneeDateNaissance=1968' -d 'moisDateNaissance=4' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1973,
    "moisDateNaissance": 2,
    "jourDateNaissance": 17,
    "codeCogInseeCommuneNaissance": "44109",
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
      "avec_participation": false,
      "date_debut_droit": "2026-09-29"
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
    -G -d 'nomUsage=MOLIERE' -d 'nomNaissance=POQUELIN' -d 'prenoms[]=JEAN' -d 'prenoms[]=BAPTISTE' -d 'anneeDateNaissance=1973' -d 'moisDateNaissance=2' -d 'jourDateNaissance=17' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1950,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1,
    "codeCogInseeCommuneNaissance": "44109",
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
      "avec_participation": false,
      "date_debut_droit": "2024-02-02"
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
    -G -d 'nomUsage=GARE' -d 'nomNaissance=GEANT' -d 'prenoms[]=GARY' -d 'anneeDateNaissance=1950' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
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
    "anneeDateNaissance": 1968,
    "moisDateNaissance": 11,
    "jourDateNaissance": 15,
    "codeCogInseeCommuneNaissance": "33063",
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
      "avec_participation": false,
      "date_debut_droit": null
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
    -G -d 'nomUsage=VERTIN' -d 'nomNaissance=HUBOT' -d 'prenoms[]=PIERRE-MARIE' -d 'prenoms[]=JEREMY' -d 'anneeDateNaissance=1968' -d 'moisDateNaissance=11' -d 'jourDateNaissance=15' -d 'codeCogInseeCommuneNaissance=33063' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
