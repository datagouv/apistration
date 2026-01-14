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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=DUPONT' -d 'prenoms[]=JEANNE' -d 'prenoms[]=LAURE' -d 'anneeDateNaissance=1993' -d 'moisDateNaissance=8' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08481' -d 'codeCogInseePaysNaissance=99127' -d 'sexeEtatCivil=M' -d 'nomNaissance=DUPONT' -d 'prenoms[]=PIERRE' -d 'prenoms[]=PAUL' -d 'anneeDateNaissance=1984' -d 'moisDateNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-enfant-beneficiaire-c2s-alexis-durand.yaml](200-enfant-beneficiaire-c2s-alexis-durand.yaml)

  Status `200`

  ## Enfant bénéficiaire du statut C2S (parent de LUCAS DURAND)

Ce cas permet de tester :
* la gestion d'un enfant bénéficiaire du statut C2S avec participation financière
* cas où l'enfant et son parent ont tous deux le statut C2S

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "DURAND",
    "prenoms": [
      "ALEXIS",
      "VINCENT"
    ],
    "anneeDateNaissance": 2006,
    "moisDateNaissance": 4,
    "jourDateNaissance": 20
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=DURAND' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=VINCENT' -d 'anneeDateNaissance=2006' -d 'moisDateNaissance=4' -d 'jourDateNaissance=20' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-enfant-beneficiaire-c2s-leo-garnier.yaml](200-enfant-beneficiaire-c2s-leo-garnier.yaml)

  Status `200`

  ## Enfant bénéficiaire du statut C2S (parent de NICOLAS GARNIER)

Ce cas permet de tester :
* la gestion d'un enfant bénéficiaire du statut C2S sans participation financière
* cas où l'enfant et son parent ont tous deux le statut C2S

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13054",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "GARNIER",
    "prenoms": [
      "LEO"
    ],
    "anneeDateNaissance": 2007,
    "moisDateNaissance": 5,
    "jourDateNaissance": 27
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13054' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=GARNIER' -d 'prenoms[]=LEO' -d 'anneeDateNaissance=2007' -d 'moisDateNaissance=5' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-enfant-majeur-beneficiaire-c2s.yaml](200-enfant-majeur-beneficiaire-c2s.yaml)

  Status `200`

  ## Enfant majeur bénéficiaire du statut C2S (parent de NASSIM FABRE)

Ce cas permet de tester :
* la gestion d'un enfant majeur bénéficiaire du statut C2S
* cas où l'enfant majeur a le statut C2S mais pas son parent

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13001",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "FABRE",
    "prenoms": [
      "MAYA",
      "LINA"
    ],
    "anneeDateNaissance": 2005,
    "moisDateNaissance": 3,
    "jourDateNaissance": 9
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13001' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=FABRE' -d 'prenoms[]=MAYA' -d 'prenoms[]=LINA' -d 'anneeDateNaissance=2005' -d 'moisDateNaissance=3' -d 'jourDateNaissance=9' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-enfant-non-beneficiaire-c2s-nolan-garnier.yaml](200-enfant-non-beneficiaire-c2s-nolan-garnier.yaml)

  Status `200`

  ## Enfant non bénéficiaire du statut C2S (parent de NICOLAS GARNIER)

Ce cas permet de tester :
* la gestion d'un enfant non bénéficiaire du statut C2S
* cas où le parent a le statut C2S mais pas l'enfant

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13054",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "GARNIER",
    "prenoms": [
      "NOLAN"
    ],
    "anneeDateNaissance": 2011,
    "moisDateNaissance": 3,
    "jourDateNaissance": 19
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13054' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=GARNIER' -d 'prenoms[]=NOLAN' -d 'anneeDateNaissance=2011' -d 'moisDateNaissance=3' -d 'jourDateNaissance=19' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=DUPONT' -d 'prenoms[]=PIERRE' -d 'anneeDateNaissance=1966' -d 'moisDateNaissance=6' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-parent-1_enfant-beneficiaires-c2s.yaml](200-parent-1_enfant-beneficiaires-c2s.yaml)

  Status `200`

  ## Parent avec un enfant, bénéficiaire du statut C2S

Ce cas permet de tester :
* la gestion d'un parent bénéficiaire du statut C2S avec participation financière
* un parent qui a un enfant

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "DURAND",
    "prenoms": [
      "LUCAS"
    ],
    "anneeDateNaissance": 1999,
    "moisDateNaissance": 3,
    "jourDateNaissance": 12
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=DURAND' -d 'prenoms[]=LUCAS' -d 'anneeDateNaissance=1999' -d 'moisDateNaissance=3' -d 'jourDateNaissance=12' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-parent-beneficiaire-2_enfants-statuts-differents.yaml](200-parent-beneficiaire-2_enfants-statuts-differents.yaml)

  Status `200`

  ## Parent bénéficiaire du statut C2S avec deux enfants

Ce cas permet de tester :
* la gestion d'un parent bénéficiaire du statut C2S sans participation financière
* un parent qui a deux enfants

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13054",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "GARNIER",
    "prenoms": [
      "NICOLAS"
    ],
    "anneeDateNaissance": 1997,
    "moisDateNaissance": 9,
    "jourDateNaissance": 30
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13054' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=GARNIER' -d 'prenoms[]=NICOLAS' -d 'anneeDateNaissance=1997' -d 'moisDateNaissance=9' -d 'jourDateNaissance=30' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-parent-non-beneficiaire-enfant-majeur-beneficiaire.yaml](200-parent-non-beneficiaire-enfant-majeur-beneficiaire.yaml)

  Status `200`

  ## Parent non bénéficiaire du statut C2S avec un enfant

Ce cas permet de tester :
* la gestion d'un parent non bénéficiaire du statut C2S
* un parent qui a un enfant

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13001",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "FABRE",
    "prenoms": [
      "NASSIM"
    ],
    "anneeDateNaissance": 1996,
    "moisDateNaissance": 10,
    "jourDateNaissance": 18
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13001' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=FABRE' -d 'prenoms[]=NASSIM' -d 'anneeDateNaissance=1996' -d 'moisDateNaissance=10' -d 'jourDateNaissance=18' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [200-parent-sans-enfant-beneficiaire-c2s.yaml](200-parent-sans-enfant-beneficiaire-c2s.yaml)

  Status `200`

  ## Parent sans enfant bénéficiaire du statut C2S

Ce cas permet de tester :
* la gestion d'un parent sans enfant
* la prise en compte du statut C2S

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "13005",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "MOREL",
    "prenoms": [
      "EMILIE"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 2,
    "jourDateNaissance": 5
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=13005' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=MOREL' -d 'prenoms[]=EMILIE' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=2' -d 'jourDateNaissance=5' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [403.yaml](403.yaml)

  Status `403`

  ## 403 - Accès interdit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "MARTINEZ",
    "prenoms": [
      "GERARD"
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
        "code": "00100",
        "title": "Privilèges insuffisants",
        "detail": "Votre token est valide mais vos privilèges sont insuffisants. Listez vos privilèges sur /api/introspect",
        "source": {
          "parameter": "token"
        },
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=MARTINEZ' -d 'prenoms[]=GERARD' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUBOCHE' -d 'prenoms[]=JEROME' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [422.yaml](422.yaml)

  Status `422`

  ## Impossible d’identifier l’allocataire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "nomNaissance": "DUBOCHE",
    "prenoms": [
      "HELENE"
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
        "code": "00366",
        "title": "Entité non traitable",
        "detail": "Un ou plusieurs paramètres de civilité ne sont pas correctement formatés",
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DUBOCHE' -d 'prenoms[]=HELENE' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DESFOUIN' -d 'prenoms[]=Ren%C3%A9' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DELANOUE' -d 'prenoms[]=Jean-Marie' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=SITUDI' -d 'prenoms[]=Cl%C3%A9ment' -d 'anneeDateNaissance=2002' -d 'moisDateNaissance=12' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=PLUSSE' -d 'nomNaissance=GERVINAT' -d 'prenoms[]=MADELEINE' -d 'prenoms[]=LEA' -d 'anneeDateNaissance=1976' -d 'moisDateNaissance=8' -d 'jourDateNaissance=24' -d 'codeCogInseePaysNaissance=99131' -d 'sexeEtatCivil=F' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=MIREL' -d 'nomNaissance=VAUBAN' -d 'prenoms[]=VICTOIRE' -d 'anneeDateNaissance=1966' -d 'moisDateNaissance=3' -d 'jourDateNaissance=5' -d 'codeCogInseePaysNaissance=99216' -d 'sexeEtatCivil=F' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=DUPUIS' -d 'nomNaissance=CARTIER' -d 'prenoms[]=CELINE' -d 'prenoms[]=MARIE' -d 'anneeDateNaissance=1980' -d 'moisDateNaissance=10' -d 'jourDateNaissance=10' -d 'codeCogInseeCommuneNaissance=75056' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=LEDIEU' -d 'nomNaissance=FALLENDE' -d 'prenoms[]=PIERRE' -d 'prenoms[]=GAUTIER' -d 'prenoms[]=HARRY' -d 'anneeNateNaissance=1950' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=HUSTER' -d 'nomNaissance=BOISSON' -d 'prenoms[]=FRANCIS' -d 'anneeDateNaissance=1978' -d 'moisDateNaissance=4' -d 'jourDateNaissance=4' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=TRIMARD' -d 'prenoms[]=FAYCAL' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=9' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=DEVRED' -d 'prenoms[]=MARC' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=7' -d 'jourDateNaissance=13' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomNaissance=RECETTECOMMUNAUTAIRE' -d 'prenoms[]=LEON' -d 'anneeDateNaissance=1968' -d 'moisDateNaissance=4' -d 'jourDateNaissance=5' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=MOLIERE' -d 'nomNaissance=POQUELIN' -d 'prenoms[]=JEAN' -d 'prenoms[]=BAPTISTE' -d 'anneeDateNaissance=1973' -d 'moisDateNaissance=2' -d 'jourDateNaissance=17' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=GARE' -d 'nomNaissance=GEANT' -d 'prenoms[]=GARY' -d 'anneeDateNaissance=1950' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'nomUsage=VERTIN' -d 'nomNaissance=HUBOT' -d 'prenoms[]=PIERRE-MARIE' -d 'prenoms[]=JEREMY' -d 'anneeDateNaissance=1968' -d 'moisDateNaissance=11' -d 'jourDateNaissance=15' -d 'codeCogInseeCommuneNaissance=33063' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
* [non_beneficiaire_200.yaml](non_beneficiaire_200.yaml)

  Status `200`

  ## Non bénéficiaire - masculin
Ce cas permet de tester :
- [Param. appel] Nom d'usage
- [Param. appel] Nom de naissance
- [Param. appel] 1 prénom
- [Param. appel] Date de naissance (jour,mois,année)
- [Param. appel] sexe masculin
- [Param. appel] cog 
- [Réponse] statut non-bénéficiaire de la complémentaire santé solidaire

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "M",
    "nomNaissance": "PAULO",
    "prenoms": [
      "PAUL"
    ],
    "anneeDateNaissance": 2000,
    "moisDateNaissance": 1,
    "jourDateNaissance": 1
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=M' -d 'nomNaissance=PAULO' -d 'prenoms[]=PAUL' -d 'anneeDateNaissance=2000' -d 'moisDateNaissance=1' -d 'jourDateNaissance=1' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/complementaire_sante_solidaire/identite"
  ```

  </p>
  </details>
