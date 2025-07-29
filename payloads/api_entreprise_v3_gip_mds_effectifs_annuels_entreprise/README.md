# Effectifs annuels d'une unité légale
* [200.yaml](200.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "130025265",
    "year": "2017"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siren": "130025265",
      "annee": "2017",
      "effectifs_annuel": [
        {
          "regime": "regime_general",
          "value": 12.34,
          "nature": "effectif_moyen_annuel",
          "date_derniere_mise_a_jour": "2018-01-01"
        },
        {
          "regime": "regime_agricole",
          "nature": "effectif_moyen_annuel",
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
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/unites_legales/130025265/effectifs_annuels/2017"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  GIP-MDS effectifs annuels entreprise 404

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000000",
    "year": "2020"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/unites_legales/000000000/effectifs_annuels/2020"
  ```

  </p>
  </details>
