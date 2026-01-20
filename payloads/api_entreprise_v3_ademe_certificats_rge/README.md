# Certification RGE
* [200.yml](200.yml)

  Status `200`

  Appel réussi

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "13002526500013"
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
          "url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_ademe_certificats_rge/exemple-ademe-rge-certificat_qualibat.pdf",
          "nom_certificat": "Qualisol CESI",
          "domaine": "Fenêtres, volets, portes extérieures 2020",
          "meta_domaine": "anciens domaines avant 2021",
          "qualification": {
            "code": "32",
            "nom": "QualiPV Elec - Pose de générateur photovoltaïque raccordé au réseau (32)"
          },
          "organisme": "qualibat",
          "date_attribution": "2020-12-24",
          "date_expiration": "2025-08-01",
          "meta": {
            "internal_id": "Q112379-8611M12D10-2017-03-23",
            "updated_at": "2021-02-25",
            "archived": false
          }
        },
        "links": {},
        "meta": {}
      },
      {
        "data": {
          "url": "https://raw.githubusercontent.com/etalab/siade_staging_data/refs/heads/develop/payloads/api_entreprise_v3_ademe_certificats_rge/exemple-ademe-rge-certificat_qualifelec.pdf",
          "nom_certificat": "Qualisol CESI",
          "domaine": "Fenêtres, volets, portes extérieures 2020",
          "meta_domaine": "anciens domaines avant 2021",
          "qualification": {
            "code": "32",
            "nom": "QualiPV Elec - Pose de générateur photovoltaïque raccordé au réseau (32)"
          },
          "organisme": "qualifelec",
          "date_attribution": "2020-12-24",
          "date_expiration": "2025-08-01",
          "meta": {
            "internal_id": "Q112379-8611M12D10-2017-03-23",
            "updated_at": "2021-02-25",
            "archived": false
          }
        },
        "links": {},
        "meta": {}
      }
    ],
    "meta": {},
    "links": {}
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/ademe/etablissements/13002526500013/certification_rge"
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
    "siret": "84445156452589"
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
        "code": "19003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": null,
        "meta": {
          "provider": "ADEME"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ademe/etablissements/84445156452589/certification_rge"
  ```

  </p>
  </details>
