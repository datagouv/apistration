# Données associations en open data
* [200_avec_siret.yaml](200_avec_siret.yaml)

  Status `200`

  Association immatriculée au répertoire Sirene, appelée par identifiant RNA

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rna": "W442001747"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identifiants": {
        "rna": "W442001747",
        "siren": "388916678",
        "siret_siege": "38891667800039"
      },
      "identite": {
        "nom": "COMITE DEPARTEMENTAL DE LA RANDONNEE PEDESTRE DE LOIRE ATLANTIQUE",
        "etat": "Active",
        "service_instructeur": {
          "code": "44",
          "libelle": "Loire-Atlantique"
        },
        "date_creation": "1981-01-16",
        "date_dissolution": null,
        "duree_determinee": false,
        "date_terme": null,
        "cloture_exercice": {
          "mois": 12,
          "jour": 31
        },
        "adresse_siege": {
          "adresse_complete": "19 AV DU CLOS DU CENS 44300 NANTES",
          "complement": null,
          "numero_voie": "19",
          "type_voie": "AV",
          "libelle_voie": "DU CLOS DU CENS",
          "distribution": null,
          "code_insee": "44109",
          "code_postal": "44300",
          "commune": "NANTES",
          "pays": "France"
        }
      },
      "utilite_publique": {
        "reconnue": false,
        "date_publication": null,
        "date_fin": null
      },
      "activites": {
        "objet": "Regrouper toutes associations et personnes qui souhaitent developper la randonnee pedestre dans le departement.",
        "objet_social1": {
          "code": "011020",
          "libelle": "Athlétisme (triathlon, pentathlon, footing, jogging)"
        }
      },
      "filiation": [],
      "groupement": null,
      "etablissements": [
        {
          "nom": "COMITE DEPARTEMENTAL DE LA RANDONNEE PEDESTRE DE LOIRE ATLANTIQUE",
          "adresse": {
            "adresse_complete": "19 AV DU CLOS DU CENS 44300 NANTES",
            "complement": null,
            "numero_voie": "19",
            "type_voie": "AV",
            "libelle_voie": "DU CLOS DU CENS",
            "distribution": null,
            "code_insee": "44109",
            "code_postal": "44300",
            "commune": "NANTES",
            "pays": "France"
          }
        }
      ],
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": [
          2023,
          2024,
          2025
        ]
      }
    },
    "links": {},
    "meta": {
      "date_derniere_mise_a_jour_rna": "2026-04-27"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/associations/open_data/W442001747"
  ```

  </p>
  </details>
* [200_avec_siret_by_siren.yaml](200_avec_siret_by_siren.yaml)

  Status `200`

  Association immatriculée au répertoire Sirene, appelée par SIREN

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rna": "388916678"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identifiants": {
        "rna": "W442001747",
        "siren": "388916678",
        "siret_siege": "38891667800039"
      },
      "identite": {
        "nom": "COMITE DEPARTEMENTAL DE LA RANDONNEE PEDESTRE DE LOIRE ATLANTIQUE",
        "etat": "Active",
        "service_instructeur": {
          "code": "44",
          "libelle": "Loire-Atlantique"
        },
        "date_creation": "1981-01-16",
        "date_dissolution": null,
        "duree_determinee": false,
        "date_terme": null,
        "cloture_exercice": {
          "mois": 12,
          "jour": 31
        },
        "adresse_siege": {
          "adresse_complete": "19 AV DU CLOS DU CENS 44300 NANTES",
          "complement": null,
          "numero_voie": "19",
          "type_voie": "AV",
          "libelle_voie": "DU CLOS DU CENS",
          "distribution": null,
          "code_insee": "44109",
          "code_postal": "44300",
          "commune": "NANTES",
          "pays": "France"
        }
      },
      "utilite_publique": {
        "reconnue": false,
        "date_publication": null,
        "date_fin": null
      },
      "activites": {
        "objet": "Regrouper toutes associations et personnes qui souhaitent developper la randonnee pedestre dans le departement.",
        "objet_social1": {
          "code": "011020",
          "libelle": "Athlétisme (triathlon, pentathlon, footing, jogging)"
        }
      },
      "filiation": [],
      "groupement": null,
      "etablissements": [
        {
          "nom": "COMITE DEPARTEMENTAL DE LA RANDONNEE PEDESTRE DE LOIRE ATLANTIQUE",
          "adresse": {
            "adresse_complete": "19 AV DU CLOS DU CENS 44300 NANTES",
            "complement": null,
            "numero_voie": "19",
            "type_voie": "AV",
            "libelle_voie": "DU CLOS DU CENS",
            "distribution": null,
            "code_insee": "44109",
            "code_postal": "44300",
            "commune": "NANTES",
            "pays": "France"
          }
        }
      ],
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": [
          2023,
          2024,
          2025
        ]
      }
    },
    "links": {},
    "meta": {
      "date_derniere_mise_a_jour_rna": "2026-04-27"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/associations/open_data/388916678"
  ```

  </p>
  </details>
* [200_avec_siret_by_siret.yaml](200_avec_siret_by_siret.yaml)

  Status `200`

  Association immatriculée au répertoire Sirene, appelée par SIRET

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rna": "38891667800039"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identifiants": {
        "rna": "W442001747",
        "siren": "388916678",
        "siret_siege": "38891667800039"
      },
      "identite": {
        "nom": "COMITE DEPARTEMENTAL DE LA RANDONNEE PEDESTRE DE LOIRE ATLANTIQUE",
        "etat": "Active",
        "service_instructeur": {
          "code": "44",
          "libelle": "Loire-Atlantique"
        },
        "date_creation": "1981-01-16",
        "date_dissolution": null,
        "duree_determinee": false,
        "date_terme": null,
        "cloture_exercice": {
          "mois": 12,
          "jour": 31
        },
        "adresse_siege": {
          "adresse_complete": "19 AV DU CLOS DU CENS 44300 NANTES",
          "complement": null,
          "numero_voie": "19",
          "type_voie": "AV",
          "libelle_voie": "DU CLOS DU CENS",
          "distribution": null,
          "code_insee": "44109",
          "code_postal": "44300",
          "commune": "NANTES",
          "pays": "France"
        }
      },
      "utilite_publique": {
        "reconnue": false,
        "date_publication": null,
        "date_fin": null
      },
      "activites": {
        "objet": "Regrouper toutes associations et personnes qui souhaitent developper la randonnee pedestre dans le departement.",
        "objet_social1": {
          "code": "011020",
          "libelle": "Athlétisme (triathlon, pentathlon, footing, jogging)"
        }
      },
      "filiation": [],
      "groupement": null,
      "etablissements": [
        {
          "nom": "COMITE DEPARTEMENTAL DE LA RANDONNEE PEDESTRE DE LOIRE ATLANTIQUE",
          "adresse": {
            "adresse_complete": "19 AV DU CLOS DU CENS 44300 NANTES",
            "complement": null,
            "numero_voie": "19",
            "type_voie": "AV",
            "libelle_voie": "DU CLOS DU CENS",
            "distribution": null,
            "code_insee": "44109",
            "code_postal": "44300",
            "commune": "NANTES",
            "pays": "France"
          }
        }
      ],
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": [
          2023,
          2024,
          2025
        ]
      }
    },
    "links": {},
    "meta": {
      "date_derniere_mise_a_jour_rna": "2026-04-27"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/associations/open_data/38891667800039"
  ```

  </p>
  </details>
* [200_dissoute.yaml](200_dissoute.yaml)

  Status `200`

  Association dissoute, reconnue d'utilité publique, issue d'une fusion et en défaut de dépôt des comptes

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rna": "W212001234"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identifiants": {
        "rna": "W212001234",
        "siren": "512345670",
        "siret_siege": "51234567000018"
      },
      "identite": {
        "nom": "ASSOCIATION BOURGUIGNONNE POUR LE PATRIMOINE",
        "etat": "Dissoute",
        "service_instructeur": {
          "code": "21",
          "libelle": "Côte-d'Or"
        },
        "date_creation": "1998-02-11",
        "date_dissolution": "2024-11-08",
        "duree_determinee": true,
        "date_terme": "2024-11-08",
        "cloture_exercice": {
          "mois": 6,
          "jour": 30
        },
        "adresse_siege": {
          "adresse_complete": "12 PLACE DE LA MAIRIE 21000 DIJON",
          "complement": null,
          "numero_voie": "12",
          "type_voie": "PL",
          "libelle_voie": "DE LA MAIRIE",
          "distribution": null,
          "code_insee": "21231",
          "code_postal": "21000",
          "commune": "DIJON",
          "pays": "France"
        }
      },
      "utilite_publique": {
        "reconnue": true,
        "date_publication": "2012-05-30",
        "date_fin": "2024-11-08"
      },
      "activites": {
        "objet": "Etudier, faire connaitre et mettre en valeur le patrimoine bati et naturel de la region bourguignonne.",
        "objet_social1": {
          "code": "006000",
          "libelle": "Culture et pratiques artistiques"
        }
      },
      "filiation": [
        {
          "type_operation": "Fusion",
          "identifiant": "W212004321"
        }
      ],
      "groupement": null,
      "etablissements": [],
      "conformite_comptable": {
        "etat_transmission_comptes": "En défaut",
        "annees_exercices_comptables_transmis": [
          2022
        ]
      }
    },
    "links": {},
    "meta": {
      "date_derniere_mise_a_jour_rna": "2024-11-23"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/associations/open_data/W212001234"
  ```

  </p>
  </details>
* [200_sans_siret.yaml](200_sans_siret.yaml)

  Status `200`

  Association sans SIRET membre d'une union, accessible uniquement par identifiant RNA

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rna": "W224002133"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "identifiants": {
        "rna": "W224002133",
        "siren": null,
        "siret_siege": null
      },
      "identite": {
        "nom": "DEPRESSIFS ANONYMES FRANCE",
        "etat": "Active",
        "service_instructeur": {
          "code": "22",
          "libelle": "Côtes-d'Armor"
        },
        "date_creation": "2008-04-10",
        "date_dissolution": null,
        "duree_determinee": false,
        "date_terme": null,
        "cloture_exercice": null,
        "adresse_siege": {
          "adresse_complete": "1 RUE DE LA REPUBLIQUE 22950 TREGUEUX",
          "complement": "MAIRIE",
          "numero_voie": "1",
          "type_voie": "RUE",
          "libelle_voie": "DE LA REPUBLIQUE",
          "distribution": null,
          "code_insee": "22360",
          "code_postal": "22950",
          "commune": "TREGUEUX",
          "pays": "France"
        }
      },
      "utilite_publique": {
        "reconnue": false,
        "date_publication": null,
        "date_fin": null
      },
      "activites": {
        "objet": "1) d'assurer la representation et de gerer les services d'interet commun de l'ensemble des groupes locaux, qui appliquent, en France, les principes de l'association : depressifs anonymes. 2) de permettre a ses membres de sortir de la depression et d'aider d'autres depressifs a en sortir",
        "objet_social1": {
          "code": "019040",
          "libelle": "Aide aux personnes en danger, solitude, désespoir, soutien psychologique"
        }
      },
      "filiation": [],
      "groupement": {
        "type": "Union",
        "associations_membres": [
          {
            "rna": "W224010253"
          },
          {
            "rna": "W832020400"
          },
          {
            "rna": "W224010302"
          },
          {
            "rna": "W832020272"
          },
          {
            "rna": "W224010335"
          },
          {
            "rna": "W832021213"
          },
          {
            "rna": "W381028767"
          },
          {
            "rna": "W751283253"
          }
        ]
      },
      "etablissements": [],
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": []
      }
    },
    "links": {},
    "meta": {
      "date_derniere_mise_a_jour_rna": "2026-04-27"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/associations/open_data/W224002133"
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
    "siren_or_siret_or_rna": "W432543654"
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
        "code": "44003",
        "title": "Entité non trouvée",
        "detail": "Le ou les paramètre(s) d'entrée n'existent pas, ne sont pas connus, ou ne comportent aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.",
        "meta": {
          "provider": "SIAF"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/associations/open_data/W432543654"
  ```

  </p>
  </details>
