# Données du RNA d'une association
* [200.yaml](200.yaml)

  Status `200`

  Association trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret_or_rna": "W751234567"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "rna_id": "W751234567",
      "titre": "ASSOCIATION POUR LE DEVELOPPEMENT DU NUMERIQUE",
      "objet": "Promotion et développement des usages du numérique",
      "siret": null,
      "siret_siege_social": "44306184100028",
      "date_creation": "2001-05-15",
      "date_declaration": "2023-01-10",
      "date_publication": null,
      "date_dissolution": null,
      "adresse_siege": {
        "complement": null,
        "numero_voie": "20",
        "type_voie": "Avenue",
        "libelle_voie": "de Ségur",
        "distribution": null,
        "code_insee": "75107",
        "code_postal": "75007",
        "commune": "Paris"
      },
      "etat": true,
      "groupement": null,
      "mise_a_jour": "2023-01-10"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/rna/associations/W751234567"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Association non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret_or_rna": "W000000000"
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
        "code": "24003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Ministère de l'Intérieur"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/rna/associations/W000000000"
  ```

  </p>
  </details>
