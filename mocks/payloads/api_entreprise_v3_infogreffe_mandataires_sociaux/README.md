# Mandataires sociaux
* [200.yaml](200.yaml)

  Status `200`

  Mandataires sociaux trouvés

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "552049447"
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
          "type": "personne_physique",
          "fonction": "PRESIDENT",
          "nom": "DUPONT",
          "prenom": "Jean",
          "date_naissance": "1965-03-15",
          "date_naissance_timestamp": -151200000,
          "lieu_naissance": "PARIS",
          "pays_naissance": "FRANCE",
          "code_pays_naissance": "FR",
          "nationalite": "FRANCAISE",
          "code_nationalite": "FR"
        },
        "links": {},
        "meta": {}
      },
      {
        "data": {
          "numero_identification": "784824153",
          "type": "personne_morale",
          "fonction": "COMMISSAIRE AUX COMPTES TITULAIRE",
          "raison_sociale": "MAZARS - SOCIETE ANONYME A DIRECTOIRE ET CONSEIL DE SURVEILLANCE",
          "code_greffe": "9201",
          "libelle_greffe": "NANTERRE"
        },
        "links": {},
        "meta": {}
      }
    ],
    "links": {},
    "meta": {
      "personnes_physiques_count": 1,
      "personnes_morales_count": 1,
      "count": 2
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=10000001700010' -d 'context=Contexte+de+la+requ%C3%AAte' -d 'object=Objet+de+la+requ%C3%AAte' \
    --url "https://staging.entreprise.api.gouv.fr/v3/infogreffe/rcs/unites_legales/552049447/mandataires_sociaux"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Entreprise non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "000000000"
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
        "code": "08003",
        "title": "Entité non trouvée",
        "detail": "Le siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Infogreffe"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/infogreffe/rcs/unites_legales/000000000/mandataires_sociaux"
  ```

  </p>
  </details>
