# Conventions collectives
* [200.yaml](200.yaml)

  Status `200`

  Conventions collectives trouvées

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "30613890001294"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": [
      {
        "data": {
          "type": "convention_collective",
          "titre": "Convention collective nationale des bureaux d'études techniques, des cabinets d'ingénieurs-conseils et des sociétés de conseils du 15 décembre 1987.",
          "titre_court": "Bureaux d'études techniques, cabinets d'ingénieurs-conseils et sociétés de conseils",
          "numero_idcc": 1486,
          "active": true,
          "etat": "vigueur_etendue",
          "synonymes": [
            "syntec"
          ],
          "url": "https://www.legifrance.gouv.fr/affichIDCC.do?idConvention=KALICONT000005635173",
          "date_publication": "1988-01-01"
        },
        "links": {},
        "meta": {
          "internal_id": "KALICONT000005635173"
        }
      }
    ],
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
    --url "https://staging.entreprise.api.gouv.fr/v3/fabrique_numerique_ministeres_sociaux/etablissements/30613890001294/conventions_collectives"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Établissement non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "00000000000000"
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
        "code": "35003",
        "title": "Entité non trouvée",
        "detail": "Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Fabrique numérique des ministères sociaux"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/fabrique_numerique_ministeres_sociaux/etablissements/00000000000000/conventions_collectives"
  ```

  </p>
  </details>
