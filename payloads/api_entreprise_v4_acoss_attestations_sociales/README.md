# Attestation de vigilance
* [attestation_delivree.yaml](attestation_delivree.yaml)

  Status `200`

  Entreprise à jour de ses cotisations

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000001"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": "https://storage.entreprise.api.gouv.fr/url-de-telechargement-attestation-vigilance.pdf",
      "document_url_expires_in": 86400,
      "date_debut_validite": "2023-01-31",
      "date_fin_validite": "2023-07-31",
      "code_securite": "YAB458G1B2T8IZW",
      "entity_status": {
        "code": "ok",
        "libelle": "Attestation délivrée par l'Urssaf",
        "description": "La délivrance de l'attestation de vigilance a été validée par l'Urssaf. L'attestation est délivrée lorsque l'entité est à jour de ses cotisations et contributions, ou bien dans le cas de situations spécifiques détaillées dans la documentation métier."
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
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v4/urssaf/unites_legales/000000001/attestation_vigilance"
  ```

  </p>
  </details>
* [attestation_non_delivree.yaml](attestation_non_delivree.yaml)

  Status `200`

  Entreprise non à jour de ses cotisations

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000002"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "document_url": null,
      "document_url_expires_in": null,
      "date_debut_validite": null,
      "date_fin_validite": null,
      "code_securite": null,
      "entity_status": {
        "code": "refus_de_delivrance",
        "libelle": "Délivrance de l'attestation refusée par l'Urssaf",
        "description": "La délivrance de l'attestation de vigilance a été refusée par l'Urssaf car l'entité n'est pas à jour de ses cotisations sociales."
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
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v4/urssaf/unites_legales/000000002/attestation_vigilance"
  ```

  </p>
  </details>
* [entite_hors_perimetre.yaml](entite_hors_perimetre.yaml)

  Status `404`

  Entreprise non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "440752244"
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
        "code": "04003",
        "title": "Entité non trouvée",
        "detail": "Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel",
        "meta": {
          "provider": "ACOSS",
          "provider_errors": [
            {
              "code": "FUNC517",
              "message": "Le Siren est inconnu",
              "description": "Le siren est inconnu du SI Attestations, radié ou hors périmètre"
            }
          ]
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
    --url "https://staging.entreprise.api.gouv.fr/v4/urssaf/unites_legales/440752244/attestation_vigilance"
  ```

  </p>
  </details>
