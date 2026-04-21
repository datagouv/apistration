# [Identité] Participation familiale EAJE
* [200-identite-cas-nominal-peu-de-donnee-prenom.yaml](200-identite-cas-nominal-peu-de-donnee-prenom.yaml)

  Status `200`

  ## IDENTITÉ CAS NOMINAL

Ce cas fait partie de l'ensemble des cas de test identite-cas-nominal/limite.
Les deuxième et troisième prenoms ont été retiré des données.

Il y a suffisament de donnée de naissance dans cet ensemble de paramètre pour permettre
de compenser les données manquantes.

Ce cas répond au besoin des applications qui ne transmettent qu'un seul prénom
pour les parents lors d'un appel à l'API Particulier EAJE (Identité).

Vous trouverez des variations des paramètres d'entré ainsi que les différents cas
d'erreur selon les informations que vous fournirez.

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXIS"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12,
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
      "allocataires": [
        {
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "ALEXIS GÉRÔME JEAN-PHILIPPE",
          "date_naissance": "1982-12-27",
          "sexe": "F",
          "code_cog_insee_commune_naissance": "08480"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "JEAN-PIERRE THOMAS JUNIOR",
          "date_naissance": "2010-05-14",
          "sexe": "M",
          "code_cog_insee_commune_naissance": "75113"
        }
      ],
      "adresse": {
        "destinataire": "Madame ALEXIS GÉRÔME JEAN-PHILIPPE LEFEBVRE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE DE LA GARE",
        "lieu_dit": null,
        "code_postal_ville": "75002",
        "pays": "FRANCE"
      },
      "parametres_calcul_participation_familiale": {
        "nombre_enfants_a_charge": 1,
        "nombre_enfants_beneficiaire_aeeh": 1,
        "base_ressources_annuelles": {
          "valeur": 40923,
          "annee_calcul": 2023
        }
      }
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite"
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
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100",
    "sexeEtatCivil": "F",
    "nomNaissance": "LEFEBVRE",
    "prenoms": [
      "ALEXIS",
      "GÉRÔME",
      "JEAN-PHILIPPE"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 12,
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
      "allocataires": [
        {
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "JEAN-PIERRE THOMAS",
          "date_naissance": "2000-01-20",
          "sexe": "M",
          "code_cog_insee_commune_naissance": "75113"
        }
      ],
      "enfants": [
        {
          "nom_naissance": "LEFEBVRE",
          "nom_usage": null,
          "prenoms": "JEAN-PIERRE THOMAS JUNIOR",
          "date_naissance": "2000-01-20",
          "sexe": "M",
          "code_cog_insee_commune_naissance": "75113"
        }
      ],
      "adresse": {
        "destinataire": "Monsieur JEAN JACQUES LEFEBVRE",
        "complement_information": null,
        "complement_information_geographique": null,
        "numero_libelle_voie": "1 RUE DE LA GARE",
        "lieu_dit": null,
        "code_postal_ville": "75002",
        "pays": "FRANCE"
      },
      "parametres_calcul_participation_familiale": {
        "nombre_enfants_a_charge": 1,
        "nombre_enfants_beneficiaire_aeeh": 1,
        "base_ressources_annuelles": {
          "valeur": 40923,
          "annee_calcul": 2023
        }
      }
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
    -G -d 'recipient=13002526500013' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[]=ALEXIS' -d 'prenoms[]=G%C3%89R%C3%94ME' -d 'prenoms[]=JEAN-PHILIPPE' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=12' -d 'jourDateNaissance=27' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite"
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
    "codeCogInseeCommuneNaissance": "00404",
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
    "errors": [
      {
        "code": "37003",
        "title": "Dossier allocataire absent CNAV",
        "detail": "Le dossier allocataire n'a pas été trouvé auprès de la CNAV.",
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
    -G -d 'recipient=13002526500013' -d 'nomNaissance=LEFEBVRE' -d 'codeCogInseeCommuneNaissance=00404' -d 'codeCogInseePaysNaissance=99100' -d 'sexeEtatCivil=F' \
    --url "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite"
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
    --url "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite"
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
    --url "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite"
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
    --url "https://staging.particulier.api.gouv.fr/v3/dss/participation_familiale_eaje/identite"
  ```

  </p>
  </details>
