# [FranceConnect] Extrait d'immatriculation véhicule
* [1.2_Parisien_VP_ES.yaml](1.2_Parisien_VP_ES.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZB-383-DK"
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
        "nom": "CIS CINQUANTEUN",
        "prenom": "PRENOM GAUTIER",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1951,
        "mois_date_naissance": 8,
        "jour_date_naissance": 25,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "172",
        "type_voie": "BOULEVARD",
        "libelle_voie": "SAINT GERMAIN",
        "code_postal_ville": "75006",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-383-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "PORSCHE",
        "type_variante_version": "9PAED2202",
        "denomination_commerciale": "CAYENNE",
        "masse_charge_maximale": 3080,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 4511,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 378,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [1_Parisien_VP_ES.yaml](1_Parisien_VP_ES.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZC-378-DK"
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
        "nom": "CIS QUARANTESEPT",
        "prenom": "PRENOM YVES",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1947,
        "mois_date_naissance": 5,
        "jour_date_naissance": 20,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "8",
        "type_voie": "RUE",
        "libelle_voie": "JULIEN LACROIX",
        "code_postal_ville": "75020",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-378-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "MAZDA",
        "type_variante_version": "CR1L8DXFABAAAAN",
        "denomination_commerciale": "MAZDA",
        "masse_charge_maximale": 2090,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1798,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 190,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [2_N-Parisien_VP_ES.yaml](2_N-Parisien_VP_ES.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-377-DK"
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
        "nom": "CIS QUARANTESIX",
        "prenom": "PNM EMMA",
        "sexe_etat_civil": "F",
        "annee_date_naissance": 1947,
        "mois_date_naissance": 5,
        "jour_date_naissance": 20,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "100",
        "type_voie": "BOULEVARD",
        "libelle_voie": "BAILLE",
        "code_postal_ville": "13005",
        "libelle_commune": "MARSEILLE",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-377-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "MAZDA",
        "type_variante_version": "CR1L8DXFABAAAAN",
        "denomination_commerciale": "MAZDA",
        "masse_charge_maximale": 2090,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1798,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 190,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [3_Parisien_VP_EL.yaml](3_Parisien_VP_EL.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-381-DK"
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
        "nom": "CIS QUARANTESEPT",
        "prenom": "PRENOM YVES",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1947,
        "mois_date_naissance": 5,
        "jour_date_naissance": 20,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "8",
        "type_voie": "RUE",
        "libelle_voie": "JULIEN LACROIX",
        "code_postal_ville": "75020",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-381-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "PEUGEOT",
        "type_variante_version": "WB9HR8",
        "denomination_commerciale": "207",
        "masse_charge_maximale": 1500,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1798,
        "type_carburant": {
          "code": "EL",
          "label": "Électricité"
        },
        "taux_co2": 0,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
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
        "source": {},
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
* [4_Parisien_VP_VBE_Multicritère.yaml](4_Parisien_VP_VBE_Multicritère.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-380-DK"
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
        "nom": "CIS QUARANTESEPT",
        "prenom": "PRENOM YVES",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1947,
        "mois_date_naissance": 5,
        "jour_date_naissance": 20,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "8",
        "type_voie": "RUE",
        "libelle_voie": "JULIEN LACROIX",
        "code_postal_ville": "75020",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-380-DK",
        "date_premiere_immatriculation": "2020-03-30",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "PEUGEOT",
        "type_variante_version": "CR1L8DXFABAAAAN",
        "denomination_commerciale": "WB9HR8",
        "masse_charge_maximale": 2090,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "CTTE",
          "label": "Véhicule Particulier"
        },
        "cylindree": 120,
        "type_carburant": {
          "code": "EG",
          "label": "Bicarburation essence-GPL"
        },
        "taux_co2": 120,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [5_Parisien_incoherence.yaml](5_Parisien_incoherence.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-382-DK"
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
        "nom": "CIS QUARANTESEPT",
        "prenom": "PRENOM YVES",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1947,
        "mois_date_naissance": 5,
        "jour_date_naissance": 20,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "9",
        "type_voie": "RUE",
        "libelle_voie": "FRANKLIN",
        "code_postal_ville": "75020",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-382-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "MAZDA",
        "type_variante_version": "CR1L8DXFABAAAAN",
        "denomination_commerciale": "MAZDA",
        "masse_charge_maximale": 2090,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1798,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 190,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [6_Parisien_2RM.yaml](6_Parisien_2RM.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-379-DK"
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
        "nom": "CIS QUARANTESEPT",
        "prenom": "PRENOM YVES",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1947,
        "mois_date_naissance": 5,
        "jour_date_naissance": 20,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "8",
        "type_voie": "RUE",
        "libelle_voie": "JULIEN LACROIX",
        "code_postal_ville": "75020",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-379-DK",
        "date_premiere_immatriculation": "2022-07-20",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "MAZDA",
        "type_variante_version": "CR1L8DXFABAAAAN",
        "denomination_commerciale": "MAZDA",
        "masse_charge_maximale": 342,
        "categorie_vehicule": {
          "code": "L3e",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "MTL",
          "label": "Véhicule Particulier"
        },
        "cylindree": 125,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 54,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
        "prenom": "THOMAS",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1985,
        "mois_date_naissance": 3,
        "jour_date_naissance": 15,
        "code_departement_naissance": "75"
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
        "extension": null,
        "pays": "FRANCE"
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
    "links": {},
    "meta": {}
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
* [fake_france_connect_extrait_immatriculation_vehicule_dgfip_lyon_1.yaml](fake_france_connect_extrait_immatriculation_vehicule_dgfip_lyon_1.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Lyon

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-387-DK"
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
        "nom": "CIS CINQUANTESEPT",
        "prenom": "PRENOM CHARLES",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1957,
        "mois_date_naissance": 7,
        "jour_date_naissance": 12,
        "code_departement_naissance": "69"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "5",
        "type_voie": "PLACE",
        "libelle_voie": "BERTONE",
        "code_postal_ville": "69004",
        "libelle_commune": "LYON",
        "lieu_dit": null,
        "etage_escalier_appartement": "APPARTEMENT A56",
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-387-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "VOLKSWAGEN",
        "type_variante_version": "16AACCZAX0FM6FM62Q030N7MGVIVR0",
        "denomination_commerciale": "JETTA",
        "masse_charge_maximale": 1920,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1984,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 167,
        "classe_environnementale": {
          "code": "Euro 5",
          "label": "Norme européenne d'émission Euro 5"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_extrait_immatriculation_vehicule_dgfip_paris_1.yaml](fake_france_connect_extrait_immatriculation_vehicule_dgfip_paris_1.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-378-DK"
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
        "nom": "CIS QUARANTESEPT",
        "prenom": "PRENOM YVES",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1947,
        "mois_date_naissance": 5,
        "jour_date_naissance": 20,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "8",
        "type_voie": "RUE",
        "libelle_voie": "JULIEN LACROIX",
        "code_postal_ville": "75020",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-378-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "MAZDA",
        "type_variante_version": "CR1L8DXFABAAAAN",
        "denomination_commerciale": "MAZDA",
        "masse_charge_maximale": 2090,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1798,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 190,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
  curl -H "Authorization: Bearer $token_france_connect" --url "https://staging.particulier.api.gouv.fr/v3/ants/extrait_immatriculation_vehicule/france_connect?recipient=13002526500013"
  ```

  </p>
  </details>
* [fake_france_connect_extrait_immatriculation_vehicule_dgfip_paris_2.yaml](fake_france_connect_extrait_immatriculation_vehicule_dgfip_paris_2.yaml)

  Status `200`

  FranceConnect: Titulaire véhicule particulier essence lié DGFIP Parisien

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ZA-383-DK"
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
        "nom": "CIS CINQUANTEUN",
        "prenom": "PRENOM GAUTIER",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1951,
        "mois_date_naissance": 8,
        "jour_date_naissance": 25,
        "code_departement_naissance": "75"
      },
      "adresse_particulier": {
        "complement_information": null,
        "num_voie": "172",
        "type_voie": "BOULEVARD",
        "libelle_voie": "SAINT GERMAIN",
        "code_postal_ville": "75006",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null,
        "pays": "FRANCE"
      },
      "statut_rattachement": "titulaire",
      "donnees_immatriculation_vehicule": {
        "numero_immatriculation": "ZA-383-DK",
        "date_premiere_immatriculation": "2017-01-19",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "caracteristiques_techniques_vehicule": {
        "marque": "PORSCHE",
        "type_variante_version": "9PAED2202",
        "denomination_commerciale": "CAYENNE",
        "masse_charge_maximale": 3080,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 4511,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 378,
        "classe_environnementale": {
          "code": "Euro 4",
          "label": "Norme européenne d'émission Euro 4"
        }
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
    "immatriculation": "FC-456-CD"
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
        "prenom": "PAUL",
        "sexe_etat_civil": "M",
        "annee_date_naissance": 1992,
        "mois_date_naissance": 11,
        "jour_date_naissance": 8,
        "code_departement_naissance": "42"
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
        "extension": null,
        "pays": "FRANCE"
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
    "links": {},
    "meta": {}
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
