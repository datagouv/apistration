# [Identité] Dossier d'immatriculation
* [200_cotitulaire_hybride.yaml](200_cotitulaire_hybride.yaml)

  Status `200`

  Cotitulaire femme véhicule particulier hybride électrique - Toyota Yaris

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "IJ-789-KL",
    "nomNaissance": "LEFEBVRE",
    "prenoms[]": [
      "SOPHIE"
    ],
    "anneeDateNaissance": 1992,
    "moisDateNaissance": 7,
    "jourDateNaissance": 4,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite": {
        "nom": "LEFEBVRE",
        "prenom": "SOPHIE"
      },
      "adresse": {
        "complement_information": "Résidence Les Pins",
        "num_voie": "7",
        "type_voie": "PLACE",
        "libelle_voie": "DE LA LIBERATION",
        "code_postal_ville": "13001",
        "libelle_commune": "MARSEILLE",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null
      },
      "statut_rattachement_vehicule": "cotitulaire",
      "extrait_immatriculation_vehicule": {
        "numero_immatriculation": "IJ-789-KL",
        "date_premiere_immatriculation": "2022-09-15",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "extrait_caracteristiques_techniques_vehicule": {
        "marque": "TOYOTA",
        "type_variante_version": "ABCXY-Z4Y567",
        "denomination_commerciale": "YARIS",
        "masse_charge_maximale": 1550,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1500,
        "type_carburant": {
          "code": "HE",
          "label": "Hybride électrique"
        },
        "taux_co2": 85,
        "classe_environnementale": {
          "code": "Euro 6d-TEMP",
          "label": "Norme européenne d'émission Euro 6d-TEMP"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=IJ-789-KL' -d 'nomNaissance=LEFEBVRE' -d 'prenoms[][]=SOPHIE' -d 'anneeDateNaissance=1992' -d 'moisDateNaissance=7' -d 'jourDateNaissance=4' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [200_locataire_diesel.yaml](200_locataire_diesel.yaml)

  Status `200`

  Locataire LLD homme véhicule particulier diesel - Volkswagen Golf

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "EF-456-GH",
    "nomNaissance": "BERNARD",
    "prenoms[]": [
      "JACQUES",
      "HENRI",
      "LOUIS"
    ],
    "anneeDateNaissance": 1978,
    "moisDateNaissance": 11,
    "jourDateNaissance": 28,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "69123",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite": {
        "nom": "BERNARD",
        "prenom": "JACQUES"
      },
      "adresse": {
        "complement_information": null,
        "num_voie": "128",
        "type_voie": "BOULEVARD",
        "libelle_voie": "JEAN JAURES",
        "code_postal_ville": "69003",
        "libelle_commune": "LYON",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null
      },
      "statut_rattachement_vehicule": "locataire",
      "extrait_immatriculation_vehicule": {
        "numero_immatriculation": "EF-456-GH",
        "date_premiere_immatriculation": "2023-02-10",
        "statut_location": {
          "code": "LLD",
          "label": "Location Longue Durée"
        }
      },
      "extrait_caracteristiques_techniques_vehicule": {
        "marque": "VOLKSWAGEN",
        "type_variante_version": "RSTUV-W3X456",
        "denomination_commerciale": "GOLF",
        "masse_charge_maximale": 1820,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 2000,
        "type_carburant": {
          "code": "GO",
          "label": "Gazole"
        },
        "taux_co2": 125,
        "classe_environnementale": {
          "code": "Euro 6b",
          "label": "Norme européenne d'émission Euro 6b"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=EF-456-GH' -d 'nomNaissance=BERNARD' -d 'prenoms[][]=JACQUES' -d 'prenoms[][]=HENRI' -d 'prenoms[][]=LOUIS' -d 'anneeDateNaissance=1978' -d 'moisDateNaissance=11' -d 'jourDateNaissance=28' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=69123' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [200_locataire_electric.yaml](200_locataire_electric.yaml)

  Status `200`

  Locataire LCB homme véhicule particulier électrique - Tesla Model 3

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "MN-012-OP",
    "nomNaissance": "MOREAU",
    "prenoms[]": [
      "ANTOINE",
      "PAUL"
    ],
    "anneeDateNaissance": 1988,
    "moisDateNaissance": 12,
    "jourDateNaissance": 31,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "33063",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite": {
        "nom": "MOREAU",
        "prenom": "ANTOINE"
      },
      "adresse": {
        "complement_information": "Bâtiment C",
        "num_voie": "23",
        "type_voie": "ALLEE",
        "libelle_voie": "DES MIMOSAS",
        "code_postal_ville": "33000",
        "libelle_commune": "BORDEAUX",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null
      },
      "statut_rattachement_vehicule": "locataire",
      "extrait_immatriculation_vehicule": {
        "numero_immatriculation": "MN-012-OP",
        "date_premiere_immatriculation": "2024-01-05",
        "statut_location": {
          "code": "LCB",
          "label": "Location avec option d'achat"
        }
      },
      "extrait_caracteristiques_techniques_vehicule": {
        "marque": "TESLA",
        "type_variante_version": "DEFGH-I5J678",
        "denomination_commerciale": "MODEL 3",
        "masse_charge_maximale": 2165,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 0,
        "type_carburant": {
          "code": "EL",
          "label": "Électrique"
        },
        "taux_co2": 0,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=MN-012-OP' -d 'nomNaissance=MOREAU' -d 'prenoms[][]=ANTOINE' -d 'prenoms[][]=PAUL' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=12' -d 'jourDateNaissance=31' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=33063' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [200_titulaire_essence.yaml](200_titulaire_essence.yaml)

  Status `200`

  Titulaire femme véhicule particulier essence - Renault Clio

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "AB-123-CD",
    "nomNaissance": "DUPONT",
    "prenoms[]": [
      "MARIE",
      "CLAIRE"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 3,
    "jourDateNaissance": 15,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "75056",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite": {
        "nom": "DUPONT",
        "prenom": "MARIE"
      },
      "adresse": {
        "complement_information": "Appartement 3B",
        "num_voie": "42",
        "type_voie": "AVENUE",
        "libelle_voie": "DES CHAMPS ELYSEES",
        "code_postal_ville": "75008",
        "libelle_commune": "PARIS",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null
      },
      "statut_rattachement_vehicule": "titulaire",
      "extrait_immatriculation_vehicule": {
        "numero_immatriculation": "AB-123-CD",
        "date_premiere_immatriculation": "2021-06-20",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "extrait_caracteristiques_techniques_vehicule": {
        "marque": "RENAULT",
        "type_variante_version": "KLMNO-P2Q345",
        "denomination_commerciale": "CLIO",
        "masse_charge_maximale": 1650,
        "categorie_vehicule": {
          "code": "M1",
          "label": "Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur"
        },
        "genre_national": {
          "code": "VP",
          "label": "Véhicule Particulier"
        },
        "cylindree": 1200,
        "type_carburant": {
          "code": "ES",
          "label": "Essence"
        },
        "taux_co2": 110,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=AB-123-CD' -d 'nomNaissance=DUPONT' -d 'prenoms[][]=MARIE' -d 'prenoms[][]=CLAIRE' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=3' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=75056' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [200_titulaire_utilitaire.yaml](200_titulaire_utilitaire.yaml)

  Status `200`

  Titulaire homme camionnette diesel - Citroën Berlingo N1

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "QR-345-ST",
    "nomNaissance": "GARCIA",
    "prenoms[]": [
      "CARLOS"
    ],
    "anneeDateNaissance": 1980,
    "moisDateNaissance": 2,
    "jourDateNaissance": 29,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "44109",
    "codeCogInseePaysNaissance": "99100"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identite": {
        "nom": "GARCIA",
        "prenom": "CARLOS"
      },
      "adresse": {
        "complement_information": null,
        "num_voie": "156",
        "type_voie": "ROUTE",
        "libelle_voie": "DE VANNES",
        "code_postal_ville": "44000",
        "libelle_commune": "NANTES",
        "lieu_dit": null,
        "etage_escalier_appartement": null,
        "extension": null
      },
      "statut_rattachement_vehicule": "titulaire",
      "extrait_immatriculation_vehicule": {
        "numero_immatriculation": "QR-345-ST",
        "date_premiere_immatriculation": "2020-03-18",
        "statut_location": {
          "code": null,
          "label": null
        }
      },
      "extrait_caracteristiques_techniques_vehicule": {
        "marque": "CITROEN",
        "type_variante_version": "GHIJK-L6M789",
        "denomination_commerciale": "BERLINGO",
        "masse_charge_maximale": 2500,
        "categorie_vehicule": {
          "code": "N1",
          "label": "Véhicule de transport de marchandises d'une masse maximale ne dépassant pas 3,5 tonnes"
        },
        "genre_national": {
          "code": "CTTE",
          "label": "Camionnette"
        },
        "cylindree": 1600,
        "type_carburant": {
          "code": "GO",
          "label": "Gazole"
        },
        "taux_co2": 140,
        "classe_environnementale": {
          "code": "Euro 6",
          "label": "Norme européenne d'émission Euro 6"
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=QR-345-ST' -d 'nomNaissance=GARCIA' -d 'prenoms[][]=CARLOS' -d 'anneeDateNaissance=1980' -d 'moisDateNaissance=2' -d 'jourDateNaissance=29' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=44109' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [403.yaml](403.yaml)

  Status `403`

  Privilèges insuffisants

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ER-403-OR",
    "nomNaissance": "INTERDIT",
    "prenoms[]": [
      "ACCES"
    ],
    "anneeDateNaissance": 1985,
    "moisDateNaissance": 6,
    "jourDateNaissance": 15,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "75056",
    "codeCogInseePaysNaissance": "99100"
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
        "code": "00100",
        "title": "Privilèges insuffisants",
        "detail": "Votre token est valide mais vos privilèges sont insuffisants. Listez vos privilèges sur /api/introspect",
        "source": {
          "parameter": "token"
        },
        "meta": {}
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
    -G -d 'recipient=13002526500013' -d 'immatriculation=ER-403-OR' -d 'nomNaissance=INTERDIT' -d 'prenoms[][]=ACCES' -d 'anneeDateNaissance=1985' -d 'moisDateNaissance=6' -d 'jourDateNaissance=15' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=75056' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Dossier d'immatriculation non trouvé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "XX-404-XX",
    "nomNaissance": "INTROUVABLE",
    "prenoms[]": [
      "DOSSIER"
    ],
    "anneeDateNaissance": 1990,
    "moisDateNaissance": 12,
    "jourDateNaissance": 25,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "08480",
    "codeCogInseePaysNaissance": "99100"
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
        "source": null,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=XX-404-XX' -d 'nomNaissance=INTROUVABLE' -d 'prenoms[][]=DOSSIER' -d 'anneeDateNaissance=1990' -d 'moisDateNaissance=12' -d 'jourDateNaissance=25' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=08480' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [422.yaml](422.yaml)

  Status `422`

  Paramètres invalides - sexe manquant

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ER-422-RR",
    "nomNaissance": "INVALIDE",
    "prenoms[]": [
      "PARAMETRE"
    ],
    "anneeDateNaissance": 1988,
    "moisDateNaissance": 8,
    "jourDateNaissance": 30,
    "codeCogInseeCommuneNaissance": "69123",
    "codeCogInseePaysNaissance": "99100"
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
        "code": "00427",
        "title": "Entité non traitable",
        "detail": "Le sexe de l'état civil est manquant",
        "source": null,
        "meta": {}
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
    -G -d 'recipient=13002526500013' -d 'immatriculation=ER-422-RR' -d 'nomNaissance=INVALIDE' -d 'prenoms[][]=PARAMETRE' -d 'anneeDateNaissance=1988' -d 'moisDateNaissance=8' -d 'jourDateNaissance=30' -d 'codeCogInseeCommuneNaissance=69123' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [429.yaml](429.yaml)

  Status `429`

  Trop de requêtes

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "LM-429-IT",
    "nomNaissance": "TROPDE",
    "prenoms[]": [
      "REQUETES"
    ],
    "anneeDateNaissance": 1995,
    "moisDateNaissance": 2,
    "jourDateNaissance": 14,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "33063",
    "codeCogInseePaysNaissance": "99100"
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
        "code": "00429",
        "title": "Trop de requêtes",
        "detail": "Vous avez effectué trop de requêtes",
        "source": null,
        "meta": {}
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
    -G -d 'recipient=13002526500013' -d 'immatriculation=LM-429-IT' -d 'nomNaissance=TROPDE' -d 'prenoms[][]=REQUETES' -d 'anneeDateNaissance=1995' -d 'moisDateNaissance=2' -d 'jourDateNaissance=14' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=33063' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [502.yaml](502.yaml)

  Status `502`

  Erreur du fournisseur de données

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "ER-502-RR",
    "nomNaissance": "ERREUR",
    "prenoms[]": [
      "SERVEUR"
    ],
    "anneeDateNaissance": 1982,
    "moisDateNaissance": 5,
    "jourDateNaissance": 20,
    "sexeEtatCivil": "M",
    "codeCogInseeCommuneNaissance": "13055",
    "codeCogInseePaysNaissance": "99100"
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
        "code": "42999",
        "title": "Erreur inconnue du fournisseur de données",
        "detail": "La réponse retournée par le fournisseur de données est invalide et inconnue de notre service. L'équipe technique a été notifiée de cette erreur pour investigation.",
        "source": null,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=ER-502-RR' -d 'nomNaissance=ERREUR' -d 'prenoms[][]=SERVEUR' -d 'anneeDateNaissance=1982' -d 'moisDateNaissance=5' -d 'jourDateNaissance=20' -d 'sexeEtatCivil=M' -d 'codeCogInseeCommuneNaissance=13055' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
* [504.yaml](504.yaml)

  Status `504`

  Délai d'attente dépassé

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "immatriculation": "TM-504-OUT",
    "nomNaissance": "TIMEOUT",
    "prenoms[]": [
      "DELAI",
      "DEPASSE"
    ],
    "anneeDateNaissance": 1987,
    "moisDateNaissance": 11,
    "jourDateNaissance": 3,
    "sexeEtatCivil": "F",
    "codeCogInseeCommuneNaissance": "59350",
    "codeCogInseePaysNaissance": "99100"
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
        "code": "42002",
        "title": "Intermédiaire hors-délai",
        "detail": "Temps d'attente d'une réponse du fournisseur de données écoulé.",
        "source": null,
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
  curl -H "Authorization: Bearer $token" \
    -G -d 'recipient=13002526500013' -d 'immatriculation=TM-504-OUT' -d 'nomNaissance=TIMEOUT' -d 'prenoms[][]=DELAI' -d 'prenoms[][]=DEPASSE' -d 'anneeDateNaissance=1987' -d 'moisDateNaissance=11' -d 'jourDateNaissance=3' -d 'sexeEtatCivil=F' -d 'codeCogInseeCommuneNaissance=59350' -d 'codeCogInseePaysNaissance=99100' \
    --url "https://staging.particulier.api.gouv.fr/v3/ants/dossier_immatriculation/identite"
  ```

  </p>
  </details>
