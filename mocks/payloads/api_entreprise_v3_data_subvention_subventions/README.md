# Subventions des associations
* [200.yaml](200.yaml)

  Status `200`

  Subventions trouvées

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rna": "W751234567"
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
          "demande_subvention": {
            "fournisseur": "OSIRIS",
            "date_mise_a_jour_information": "2023-01-01T00:00:00.000Z",
            "annee_exercice_demande": 2023,
            "identifiant_engagement_juridique": "23/0001234",
            "jointure_demandes_et_versements": "23/0001234",
            "subvention_demandee": {
              "dispositif": "Fonds de développement de la vie associative",
              "sous_dispositif": "Aides territoriales (hors emploi)",
              "montant_demande": 15000
            },
            "description_des_projets": {
              "estimation_cout_total": 25000,
              "projet": [
                {
                  "rang": 1,
                  "intitule": "Développement du numérique associatif",
                  "objectifs": "Favoriser l'inclusion numérique",
                  "objectifs_operationnels": "Formation des bénévoles",
                  "description": "Programme de formation au numérique",
                  "aide": {
                    "nature": "Projets associatifs",
                    "modalite": "Aide au projet"
                  },
                  "modalite_ou_dispositif": "Développement numérique",
                  "indicateurs": null,
                  "cofinanceurs": "Conseil départemental"
                }
              ]
            },
            "instruction": {
              "service_instructeur": "DRAJES Île-de-France",
              "date_commission": "2023-06-15T00:00:00.000Z",
              "statut_demande": "Accordé",
              "montant_accorde": 10000
            }
          },
          "paiements": [
            {
              "fournisseur": "Chorus",
              "date_mise_a_jour_information": "2023-07-15T00:00:00.000Z",
              "jointure_demandes_et_versements": "23/0001234",
              "montant_verse": 10000,
              "date_versement": "2023-07-15T00:00:00.000Z",
              "centre_financier": "UO Region IDF",
              "domaine_fonctionnel": "vie associative",
              "activitee": "formation",
              "numero_bop": "163",
              "programme": {
                "numero": "163",
                "libelle": "Jeunesse et vie associative",
                "fournisseur": "Data Bretagne"
              }
            }
          ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/data_subvention/associations/W751234567/subventions"
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
    "siren_or_siret_or_rna": "W000000000"
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
        "code": "28003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "source": null,
        "meta": {
          "provider": "Data Subvention"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/data_subvention/associations/W000000000/subventions"
  ```

  </p>
  </details>
