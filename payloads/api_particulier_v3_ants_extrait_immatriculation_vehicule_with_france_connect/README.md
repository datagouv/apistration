# [FranceConnect] Extrait d'immatriculation véhicule
* [404.yaml](404.yaml)

  Status `404`

  Dossier d'immatriculation non trouvé via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "XX-404-FC"
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
        "code": "42003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "source": {
        },
        "meta": {
          "provider": "ANTS"
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_extrait_immatriculation_vehicule.yaml](fake_france_connect_extrait_immatriculation_vehicule.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "FC-123-AB"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite_particulier": {
        "nom": "DELATOUR",
        "prenom": "THOMAS"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "12",
        "type_voie": "RUE",
        "libelle_voie": "DE LA PAIX",
        "code_postal_ville": "75011",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "FC-123-AB",
        "date_premiere_immatriculation": "2021-04-16",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "PEUGEOT",
        "type_variante_version": "FCDEF-G1H234",
        "denomination_commerciale": "3008",
        "masse_charge_maximale": 1890,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1600,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 115,
        "classe_environnementale": {
          "code": "Euro 6d",
          "label": "Norme européenne d'émission Euro 6d"
        }
      }
    },
    "links": {
    },
    "meta": {
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [france_connect_extrait_immatriculation_vehicule_locataire.yaml](france_connect_extrait_immatriculation_vehicule_locataire.yaml)

  Status `200`

  Locataire LLD véhicule particulier hybride via FranceConnect

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "FC-456-CD",
    "prenoms": [
      "Angela",
      "Claire",
      "Louise"
    ],
    "nomNaissance": "DUBOIS",
    "anneeDateDeNaissance": 1962,
    "moisDateDeNaissance": 8,
    "jourDateDeNaissance": 24,
    "sexe": "F",
    "codeInseeLieuDeNaissance": "75107",
    "codePaysLieuDeNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite_particulier": {
        "nom": "CUILLERE",
        "prenom": "PAUL"
      },
      "adresse_particulier": {
        "complement_information": "Résidence Jeunes",
        "num_voie": "8",
        "type_voie": "PLACE",
        "libelle_voie": "DU MARCHE",
        "code_postal_ville": "42000",
        "libelle_commune": "SAINT-ETIENNE",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null
      },
      "statut_rattachement": "locataire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "FC-456-CD",
        "date_premiere_immatriculation": "2024-01-23",
        "statut_location": {
          "code": "LLD",
          "label": "Location Longue Durée"
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "TOYOTA",
        "type_variante_version": "FCGHI-J2K567",
        "denomination_commerciale": "COROLLA",
        "masse_charge_maximale": 1610,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1800,
        "type_carburant": {
          "code": "HE",
          "label": "Hybride électrique"
        },
        "taux_co2": 92,
        "classe_environnementale": {
          "code": "Euro 6e",
          "label": "Norme européenne d'émission Euro 6e"
        }
      }
    },
    "links": {
    },
    "meta": {
    }
  }
  ```

  </p>
  </details>

  <details><summary>Commande cURL</summary>
  <p>

  ```bash
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
