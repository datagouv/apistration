# Certification d'ingénierie OPQIBI
* [200.yml](200.yml)

  Status `200`

  Appel réussi

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "130025265"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "numero_certificat": "string",
      "url": "https://www.opqibi.com/fiche/1777",
      "date_delivrance_certificat": "2021-01-28",
      "duree_validite_certificat": "valable un an",
      "assurances": "ALLIANZ - XL INSURANCE",
      "qualifications": [
        {
          "nom": "Etude thermique réglementaire \"maison individuelle\"",
          "code_qualification": "1331",
          "definition": "Cette qualification correspond à la réalisation des calculs thermiques réglementaires pour les constructions neuves.",
          "rge": false
        }
      ],
      "date_validite_qualifications": "2025-02-21",
      "qualifications_probatoires": [
        {
          "nom": "Etude thermique réglementaire \"maison individuelle\"",
          "code_qualification": "1331",
          "definition": "Cette qualification correspond à la réalisation des calculs thermiques réglementaires pour les constructions neuves.",
          "rge": false
        }
      ],
      "date_validite_qualifications_probatoires": "2025-02-21"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/opqibi/unites_legales/130025265/certification_ingenierie"
  ```

  </p>
  </details>
* [404.yml](404.yml)

  Status `404`

  Établissement non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "844451564"
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
        "code": "11003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "OPQIBI"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/opqibi/unites_legales/844451564/certification_ingenierie"
  ```

  </p>
  </details>
