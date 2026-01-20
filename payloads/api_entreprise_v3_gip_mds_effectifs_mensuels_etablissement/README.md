# Effectifs mensuels d'un établissement
* [200-boeth.yaml](200-boeth.yaml)

  Status `200`

  GIP-MDS effectifs mensuels établissement 200 avec nature_effectif boeth

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500013",
    "year": "2024",
    "month": "06",
    "nature_effectif": "boeth"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siret": "13002526500013",
      "effectifs_mensuels": [
        {
          "regime": "regime_general",
          "annee": "2024",
          "mois": "06",
          "nature": "effectif_moyen_mensuel",
          "value": 2,
          "date_derniere_mise_a_jour": "2024-07-10"
        },
        {
          "regime": "regime_agricole",
          "annee": "2024",
          "mois": "06",
          "nature": "effectif_moyen_mensuel",
          "value": null,
          "date_derniere_mise_a_jour": null
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
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/etablissements/13002526500013/effectifs_mensuels/06/annee/2024"
  ```

  </p>
  </details>
* [200.yaml](200.yaml)

  Status `200`

  GIP-MDS effectifs mensuels établissement 200, avec profondeur

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500013",
    "year": "2022",
    "month": "12",
    "profondeur": 2
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siret": "55203253400646",
      "effectifs_mensuels": [
        {
          "regime": "regime_agricole",
          "annee": "2022",
          "mois": "12",
          "nature": "effectif_moyen_mensuel",
          "value": null,
          "date_derniere_mise_a_jour": null
        },
        {
          "regime": "regime_general",
          "annee": "2022",
          "mois": "12",
          "nature": "effectif_moyen_mensuel",
          "value": 12.66,
          "date_derniere_mise_a_jour": "2023-07-10"
        },
        {
          "regime": "regime_agricole",
          "annee": "2022",
          "mois": "11",
          "nature": "effectif_moyen_mensuel",
          "value": null,
          "date_derniere_mise_a_jour": null
        },
        {
          "regime": "regime_general",
          "annee": "2022",
          "mois": "11",
          "nature": "effectif_moyen_mensuel",
          "value": 13.86,
          "date_derniere_mise_a_jour": "2023-07-10"
        },
        {
          "regime": "regime_general",
          "annee": "2022",
          "mois": "10",
          "nature": "effectif_moyen_mensuel",
          "value": 14.21,
          "date_derniere_mise_a_jour": "2023-07-10"
        },
        {
          "regime": "regime_agricole",
          "annee": "2022",
          "mois": "10",
          "nature": "effectif_moyen_mensuel",
          "value": null,
          "date_derniere_mise_a_jour": null
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
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/etablissements/13002526500013/effectifs_mensuels/12/annee/2022"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  GIP-MDS effectifs mensuels établissement 404

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "00000000000000",
    "year": "2020",
    "month": "12"
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
        "code": "31003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "meta": {
          "provider": "GIP-MDS"
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
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/etablissements/00000000000000/effectifs_mensuels/12/annee/2020"
  ```

  </p>
  </details>
