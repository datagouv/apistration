# [Identifiant] API Statut sportif de haut niveau et sur liste ministérielle
* [200.yaml](200.yaml)

  Status `200`

  Statut sportif trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "12345"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite": {
        "nom_naissance": "Dupont",
        "nom_usage": "Martin",
        "prenoms": "Jean Claude",
        "date_naissance": "1990-05-15",
        "sexe": "M"
      },
      "est_sportif_de_haut_niveau": true,
      "a_ete_sportif_de_haut_niveau": true,
      "informations_statut": {
        "periode": {
          "date_debut_statut": "2023-01-01",
          "date_fin_statut": "2025-09-30"
        },
        "federation": {
          "code_federation": "29",
          "nom_federation": "fédération française de handball",
          "nom_court_federation": "HANDBALL"
        },
        "etablissement": {
          "code_etablissement": "2075",
          "nom_etablissement": "Maison de la Performance Nouvelle-Aquitaine"
        },
        "region": {
          "code_region": "75",
          "nom_region": "Nouvelle-Aquitaine"
        },
        "categorie": {
          "code_categorie": "2",
          "nom_categorie": "elite",
          "valeur": "4"
        },
        "sportif_de_haut_niveau": true
      },
      "informations_statuts_precedents": [
        {
          "fiche": 789456,
          "periode": {
            "date_debut_statut": "2021-01-01",
            "date_fin_statut": "2022-12-31"
          },
          "federation": {
            "code_federation": "69",
            "nom_federation": "Fédération Française de Triathlon et Disciplines Enchaînées",
            "nom_court_federation": "TRIATHLON"
          },
          "etablissement": {
            "code_etablissement": "1093",
            "nom_etablissement": "Maison de la Performance Occitanie"
          },
          "region": {
            "code_region": "76",
            "nom_region": "Occitanie"
          },
          "categorie": {
            "code_categorie": "4",
            "nom_categorie": "Elite",
            "valeur": "128"
          },
          "sportif_de_haut_niveau": true
        }
      ]
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
    -G -d 'recipient=13002526500013' -d 'identifiant=12345' \
    --url "https://staging.particulier.api.gouv.fr/v3/sdh/statut_sportif/identifiant"
  ```

  </p>
  </details>
* [403.yaml](403.yaml)

  Status `403`

  Accès interdit

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "98765"
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
    -G -d 'recipient=13002526500013' -d 'identifiant=98765' \
    --url "https://staging.particulier.api.gouv.fr/v3/sdh/statut_sportif/identifiant"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Statut sportif non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "54321"
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
        "detail": "Aucun statut sportif n'a pu être trouvé avec les critères de recherche fournis.",
        "source": null,
        "meta": {
          "provider": "SDH"
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
    -G -d 'recipient=13002526500013' -d 'identifiant=54321' \
    --url "https://staging.particulier.api.gouv.fr/v3/sdh/statut_sportif/identifiant"
  ```

  </p>
  </details>
* [422.yaml](422.yaml)

  Status `422`

  Paramètres invalides

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "43210"
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
        "detail": "Un ou plusieurs paramètres ne sont pas correctement formatés",
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
    -G -d 'recipient=13002526500013' -d 'identifiant=43210' \
    --url "https://staging.particulier.api.gouv.fr/v3/sdh/statut_sportif/identifiant"
  ```

  </p>
  </details>
* [429.yaml](429.yaml)

  Status `429`

  Trop de requêtes

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "56789"
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
    -G -d 'recipient=13002526500013' -d 'identifiant=56789' \
    --url "https://staging.particulier.api.gouv.fr/v3/sdh/statut_sportif/identifiant"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  Erreur du fournisseur de données

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "24680"
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
          "provider": "SDH"
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
    -G -d 'recipient=13002526500013' -d 'identifiant=24680' \
    --url "https://staging.particulier.api.gouv.fr/v3/sdh/statut_sportif/identifiant"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  Délai d'attente dépassé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "identifiant": "13579"
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
        "detail": "Temps d'attente d'une réponse du fournisseur de données écoulé.",
        "source": null,
        "meta": {
          "provider": "SDH"
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
    -G -d 'recipient=13002526500013' -d 'identifiant=13579' \
    --url "https://staging.particulier.api.gouv.fr/v3/sdh/statut_sportif/identifiant"
  ```

  </p>
  </details>
