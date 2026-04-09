# Immatriculation EORI
* [200.yaml](200.yaml)

  Status `200`

  Immatriculation EORI trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret_or_eori": "30613890001294"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "id": "FR30613890001294",
      "actif": true,
      "code_pays": "FR",
      "code_postal": "75007",
      "libelle": "DINUM",
      "pays": "France",
      "rue": "20 avenue de Ségur",
      "ville": "Paris"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/douanes/etablissements/30613890001294/immatriculations_eori"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  EORI non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret_or_eori": "00000000000000"
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
        "code": "33003",
        "title": "Entité non trouvée",
        "detail": "Le siret ou le numéro EORI indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Douanes"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/douanes/etablissements/00000000000000/immatriculations_eori"
  ```

  </p>
  </details>
