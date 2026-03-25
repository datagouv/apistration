# Extrait RCS
* [200.yaml](200.yaml)

  Status `200`

  Extrait RCS trouvé

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
    "data": {
      "siren": "552049447",
      "date_radiation": null,
      "date_extrait": "2024-01-15",
      "date_immatriculation": "1985-07-01",
      "mandataires_sociaux": [
        {
          "numero_identification": null,
          "type": "personne_physique",
          "fonction": "Président du conseil d'administration",
          "nom": "DUPONT",
          "prenom": "Jean",
          "date_naissance": "1965-03",
          "raison_sociale": null
        }
      ],
      "observations": [
        {
          "numero": "123456",
          "libelle": "LA SOCIETE NE CONSERVE AUCUNE ACTIVITE A SON ANCIEN SIEGE",
          "date": "2020-01-01"
        }
      ],
      "nom_commercial": "DUPONT INDUSTRIES",
      "etablissement_principal": {
        "activite": "Fabrication de produits industriels",
        "origine_fonds": "CREATION",
        "mode_exploitation": "EXPLOITATION DIRECTE",
        "code_ape": "6420Z"
      },
      "capital": {
        "montant": 50000.0,
        "devise": "EUROS",
        "code_devise": "EUR"
      },
      "greffe": {
        "valeur": "PARIS",
        "code": "7501"
      },
      "personne_physique": {
        "adresse": {
          "nom_postal": "22 RUE DE LA PAIX",
          "numero": "22",
          "type": "RUE",
          "voie": "DE LA PAIX",
          "ligne_1": null,
          "ligne_2": null,
          "localite": null,
          "code_postal": "75002",
          "bureau_distributeur": null,
          "pays": "FRANCE"
        },
        "nationalite": {
          "valeur": "FRANÇAISE",
          "code": "FR"
        },
        "nom": "DUPONT",
        "prenom": "Jean",
        "naissance": {
          "pays": {
            "valeur": "FRANCE",
            "code": "FR"
          },
          "date": "1965-03-15",
          "lieu": "PARIS"
        }
      },
      "personne_morale": {
        "forme_juridique": {
          "valeur": "SOCIETE PAR ACTIONS SIMPLIFIEES",
          "code": "SASh"
        },
        "denomination": null,
        "date_cloture_exercice_comptable": "12-31",
        "date_fin_de_vie": "2085-07-01"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/infogreffe/rcs/unites_legales/552049447/extrait_kbis"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Entreprise non trouvée au RCS

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
    --url "https://staging.entreprise.api.gouv.fr/v3/infogreffe/rcs/unites_legales/000000000/extrait_kbis"
  ```

  </p>
  </details>
