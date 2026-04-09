# Effectifs annuels d'une unité légale
* [200-2022.yaml](200-2022.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "130025265",
    "year": "2022"
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
      "annee": "2022",
      "effectifs_annuel": [
        {
          "regime": "regime_general",
          "value": 12,
          "nature": "effectif_moyen_annuel",
          "date_derniere_mise_a_jour": "2022-01-01"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/unites_legales/130025265/effectifs_annuels/2022"
  ```

  </p>
  </details>
* [200-2023.yaml](200-2023.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "130025265",
    "year": "2023"
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
      "annee": "2023",
      "effectifs_annuel": [
        {
          "regime": "regime_general",
          "value": 13,
          "nature": "effectif_moyen_annuel",
          "date_derniere_mise_a_jour": "2023-01-01"
        },
        {
          "regime": "regime_agricole",
          "nature": "effectif_moyen_annuel",
          "value": null,
          "date_derniere_mise_a_jour": "2023-05-09"
        },
        {
          "regime": "regime_agricole",
          "nature": "effectif_moyen_annuel",
          "value": 12,
          "date_derniere_mise_a_jour": "2023-02-09"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/unites_legales/130025265/effectifs_annuels/2023"
  ```

  </p>
  </details>
* [200-2024.yaml](200-2024.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "130025265",
    "year": "2024"
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
      "annee": "2024",
      "effectifs_annuel": [
        {
          "regime": "regime_general",
          "value": 18,
          "nature": "effectif_moyen_annuel",
          "date_derniere_mise_a_jour": "2024-01-01"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/unites_legales/130025265/effectifs_annuels/2024"
  ```

  </p>
  </details>
* [200-boeth.yaml](200-boeth.yaml)

  Status `200`

  GIP-MDS effectifs annuels entreprise 200 avec nature_effectif boeth

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "130025265",
    "year": "2024",
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
      "siren": "130025265",
      "annee": "2024",
      "effectifs_annuel": [
        {
          "regime": "regime_general",
          "value": 3,
          "nature": "effectif_moyen_annuel",
          "date_derniere_mise_a_jour": "2024-01-01"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/gip_mds/unites_legales/130025265/effectifs_annuels/2024"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Chiffre d'affaire annuels entreprise 404

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
        "code": "03003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "DGFIP - Adélie"
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
