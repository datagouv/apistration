# Données fondations
* [200_fdd.yaml](200_fdd.yaml)

  Status `200`

  Fonds de dotation (FDD) sans SIRET, accessible uniquement par identifiant RNF

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rnf": "075-fdd-00700-07"
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
        "rnf": "075-FDD-00700-07",
        "siren": null,
        "siret": null
      },
      "identite": {
        "service_instructeur": "75",
        "type_fondation": "FDD",
        "denomination": "MEET MY MAMA FUND",
        "etat": "Active",
        "date_effet_etat": "2023-03-08",
        "date_creation": "2023-03-08",
        "date_terme": null,
        "date_cloture_exercice": "12-31",
        "adresse_siege": {
          "adresse_complete": "10 Rue de Penthièvre 75008 Paris",
          "numero_voie": "10",
          "nom_voie": "Rue de Penthièvre",
          "code_postal": "75008",
          "commune": "Paris 8e Arrondissement",
          "code_insee_commune": "75108",
          "departement": "75",
          "pays": "France"
        },
        "courriel": "contact@fonds-exemple.fr",
        "telephone": "+33198765432"
      },
      "activite": {
        "objet_social": "Conduire et soutenir toutes missions d'intérêt général à caractère social, philanthropique, éducatif et humanitaire concourant à faciliter l'inclusion sociale, notamment des femmes.",
        "domaine_interet_general": "Social, Humanitaire, Éducatif",
        "activite_internationale_prevue_par_statuts": false
      },
      "dirigeants": [
        {
          "nom": "BERNARD",
          "prenom": "Louise",
          "date_naissance": "1988-02-20",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "1 Avenue des Champs Elysées 75008 Paris",
            "code_postal": "75008",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Entrepreneuse",
          "date_entree_fonction": "2023-02-13",
          "date_sortie_fonction": null,
          "fonction": "Présidente",
          "qualite": "Membre du conseil d'administration",
          "fondateur": true,
          "personne_morale": null
        },
        {
          "nom": "PETIT",
          "prenom": "Nicolas",
          "date_naissance": "1985-07-30",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "1 Avenue des Champs Elysées 75008 Paris",
            "code_postal": "75008",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Consultant",
          "date_entree_fonction": "2023-02-13",
          "date_sortie_fonction": null,
          "fonction": "Secrétaire",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": null
        }
      ],
      "liens_entre_organismes": {
        "organisme_issu_transformation": null,
        "organisme_issu_fusion": null,
        "organismes_issus_scission": []
      },
      "situation_financiere": {
        "annees_subventions_publiques": [],
        "annees_appel_generosite_publique": [],
        "annees_financements_etrangers": []
      },
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": [
          2023,
          2024
        ]
      },
      "documents": [
        {
          "id": "711cf2ed-6e04-11f1-aed1-4faba2bb8c0b",
          "type": "Statuts",
          "nom_original": "Statuts constitutifs.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-04-20"
        },
        {
          "id": "711cf2ee-6e04-11f1-aed1-4faba2bb8c0b",
          "type": "Comptes",
          "nom_original": "Comptes annuels 2024.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-17"
        },
        {
          "id": "711cf2ef-6e04-11f1-aed1-4faba2bb8c0b",
          "type": "Rapport d'activité",
          "nom_original": "Rapport d'activité 2024.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-17"
        }
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/fondations/075-fdd-00700-07"
  ```

  </p>
  </details>
* [200_fe.yaml](200_fe.yaml)

  Status `200`

  Fondation d'entreprise (FE) à durée déterminée, avec un dirigeant représentant une personne morale

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rnf": "075-fe-00117-05"
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
        "rnf": "075-FE-00117-05",
        "siren": "987654321",
        "siret": "98765432100012"
      },
      "identite": {
        "service_instructeur": "75",
        "type_fondation": "FE",
        "denomination": "FONDATION D'ENTREPRISE EXEMPLE",
        "etat": "Active",
        "date_effet_etat": "2019-05-15",
        "date_creation": "2019-05-15",
        "date_terme": "2029-05-14",
        "date_cloture_exercice": "12-31",
        "adresse_siege": {
          "adresse_complete": "25 Avenue Exemple 75008 Paris",
          "numero_voie": "25",
          "nom_voie": "Avenue Exemple",
          "code_postal": "75008",
          "commune": "Paris 8e Arrondissement",
          "code_insee_commune": "75108",
          "departement": "75",
          "pays": "France"
        },
        "courriel": "fondation@entreprise-exemple.fr",
        "telephone": "+33144556677"
      },
      "activite": {
        "objet_social": "Financer des actions d'intérêt général dans le domaine de l'éducation et de l'insertion professionnelle des jeunes.",
        "domaine_interet_general": "Éducatif, Social",
        "activite_internationale_prevue_par_statuts": true
      },
      "dirigeants": [
        {
          "nom": "MOREAU",
          "prenom": "Claire",
          "date_naissance": "1972-09-18",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "12 Rue Exemple 92100 Boulogne-Billancourt",
            "code_postal": "92100",
            "commune": "Boulogne-Billancourt",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Directrice générale",
          "date_entree_fonction": "2019-05-15",
          "date_sortie_fonction": null,
          "fonction": "Présidente",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": {
            "type": "Entreprise",
            "identifiant": "98765432100012",
            "denomination": "ENTREPRISE EXEMPLE",
            "pays": "France"
          }
        }
      ],
      "liens_entre_organismes": {
        "organisme_issu_transformation": null,
        "organisme_issu_fusion": null,
        "organismes_issus_scission": []
      },
      "situation_financiere": {
        "annees_subventions_publiques": [],
        "annees_appel_generosite_publique": [],
        "annees_financements_etrangers": [
          2024
        ]
      },
      "conformite_comptable": {
        "etat_transmission_comptes": "En défaut",
        "annees_exercices_comptables_transmis": [
          2022,
          2023
        ]
      },
      "documents": [
        {
          "id": "8a1b2c3d-4e5f-11f1-aed1-4faba2bb8c0b",
          "type": "Statuts",
          "nom_original": "Statuts fondation entreprise.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-03-12"
        },
        {
          "id": "8a1b2c3d-4e5f-11f1-aed1-4faba2bb8c0c",
          "type": "Procès verbal",
          "nom_original": "PV conseil administration 2025.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-03-12"
        }
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/fondations/075-fe-00117-05"
  ```

  </p>
  </details>
* [200_frup.yaml](200_frup.yaml)

  Status `200`

  Fondation reconnue d'utilité publique (FRUP), appelée par identifiant RNF

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rnf": "075-frup-00194-01"
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
        "rnf": "075-FRUP-00194-01",
        "siren": "784308934",
        "siret": "78430893400016"
      },
      "identite": {
        "service_instructeur": "75",
        "type_fondation": "FRUP",
        "denomination": "MAISON DE LA CHIMIE",
        "etat": "Active",
        "date_effet_etat": "1928-08-12",
        "date_creation": "1928-08-12",
        "date_terme": null,
        "date_cloture_exercice": "12-31",
        "adresse_siege": {
          "adresse_complete": "28 Rue Saint-Dominique 75007 Paris",
          "numero_voie": "28",
          "nom_voie": "Rue Saint-Dominique",
          "code_postal": "75007",
          "commune": "Paris 7e Arrondissement",
          "code_insee_commune": "75107",
          "departement": "75",
          "pays": "France"
        },
        "courriel": "contact@fondation-exemple.fr",
        "telephone": "+33123456789"
      },
      "activite": {
        "objet_social": "L'aménagement et l'entretien d'un immeuble destiné à permettre la jouissance de locaux et de salles de réunions aux organismes de chimie pure et appliquée, en vue de contribuer à l'avancement de la science chimique et au développement de ses applications.",
        "domaine_interet_general": "Scientifique",
        "activite_internationale_prevue_par_statuts": false
      },
      "dirigeants": [
        {
          "nom": "DUPONT",
          "prenom": "Marie",
          "date_naissance": "1975-04-12",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "20 Rue Exemple 75001 Paris",
            "code_postal": "75001",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Juriste",
          "date_entree_fonction": "2018-06-23",
          "date_sortie_fonction": null,
          "fonction": "Président",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": null
        },
        {
          "nom": "MARTIN",
          "prenom": "Paul",
          "date_naissance": "1968-11-02",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "5 Avenue Exemple 75008 Paris",
            "code_postal": "75008",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Chercheur",
          "date_entree_fonction": "2018-06-28",
          "date_sortie_fonction": null,
          "fonction": "Trésorier",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": null
        }
      ],
      "liens_entre_organismes": {
        "organisme_issu_transformation": null,
        "organisme_issu_fusion": null,
        "organismes_issus_scission": []
      },
      "situation_financiere": {
        "annees_subventions_publiques": [
          2024,
          2025
        ],
        "annees_appel_generosite_publique": [
          2025
        ],
        "annees_financements_etrangers": []
      },
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": [
          2023,
          2024,
          2025
        ]
      },
      "documents": [
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a41",
          "type": "Statuts",
          "nom_original": "Statuts 1957.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        },
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a42",
          "type": "Comptes",
          "nom_original": "Comptes annuels 2025.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        },
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a43",
          "type": "Rapport d'activité",
          "nom_original": "Rapport d'activité 2025.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        }
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/fondations/075-frup-00194-01"
  ```

  </p>
  </details>
* [200_frup_by_siren.yaml](200_frup_by_siren.yaml)

  Status `200`

  Fondation reconnue d'utilité publique (FRUP), appelée par SIREN

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rnf": "784308934"
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
        "rnf": "075-FRUP-00194-01",
        "siren": "784308934",
        "siret": "78430893400016"
      },
      "identite": {
        "service_instructeur": "75",
        "type_fondation": "FRUP",
        "denomination": "MAISON DE LA CHIMIE",
        "etat": "Active",
        "date_effet_etat": "1928-08-12",
        "date_creation": "1928-08-12",
        "date_terme": null,
        "date_cloture_exercice": "12-31",
        "adresse_siege": {
          "adresse_complete": "28 Rue Saint-Dominique 75007 Paris",
          "numero_voie": "28",
          "nom_voie": "Rue Saint-Dominique",
          "code_postal": "75007",
          "commune": "Paris 7e Arrondissement",
          "code_insee_commune": "75107",
          "departement": "75",
          "pays": "France"
        },
        "courriel": "contact@fondation-exemple.fr",
        "telephone": "+33123456789"
      },
      "activite": {
        "objet_social": "L'aménagement et l'entretien d'un immeuble destiné à permettre la jouissance de locaux et de salles de réunions aux organismes de chimie pure et appliquée, en vue de contribuer à l'avancement de la science chimique et au développement de ses applications.",
        "domaine_interet_general": "Scientifique",
        "activite_internationale_prevue_par_statuts": false
      },
      "dirigeants": [
        {
          "nom": "DUPONT",
          "prenom": "Marie",
          "date_naissance": "1975-04-12",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "20 Rue Exemple 75001 Paris",
            "code_postal": "75001",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Juriste",
          "date_entree_fonction": "2018-06-23",
          "date_sortie_fonction": null,
          "fonction": "Président",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": null
        },
        {
          "nom": "MARTIN",
          "prenom": "Paul",
          "date_naissance": "1968-11-02",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "5 Avenue Exemple 75008 Paris",
            "code_postal": "75008",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Chercheur",
          "date_entree_fonction": "2018-06-28",
          "date_sortie_fonction": null,
          "fonction": "Trésorier",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": null
        }
      ],
      "liens_entre_organismes": {
        "organisme_issu_transformation": null,
        "organisme_issu_fusion": null,
        "organismes_issus_scission": []
      },
      "situation_financiere": {
        "annees_subventions_publiques": [
          2024,
          2025
        ],
        "annees_appel_generosite_publique": [
          2025
        ],
        "annees_financements_etrangers": []
      },
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": [
          2023,
          2024,
          2025
        ]
      },
      "documents": [
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a41",
          "type": "Statuts",
          "nom_original": "Statuts 1957.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        },
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a42",
          "type": "Comptes",
          "nom_original": "Comptes annuels 2025.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        },
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a43",
          "type": "Rapport d'activité",
          "nom_original": "Rapport d'activité 2025.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        }
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/fondations/784308934"
  ```

  </p>
  </details>
* [200_frup_by_siret.yaml](200_frup_by_siret.yaml)

  Status `200`

  Fondation reconnue d'utilité publique (FRUP), appelée par SIRET

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rnf": "78430893400016"
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
        "rnf": "075-FRUP-00194-01",
        "siren": "784308934",
        "siret": "78430893400016"
      },
      "identite": {
        "service_instructeur": "75",
        "type_fondation": "FRUP",
        "denomination": "MAISON DE LA CHIMIE",
        "etat": "Active",
        "date_effet_etat": "1928-08-12",
        "date_creation": "1928-08-12",
        "date_terme": null,
        "date_cloture_exercice": "12-31",
        "adresse_siege": {
          "adresse_complete": "28 Rue Saint-Dominique 75007 Paris",
          "numero_voie": "28",
          "nom_voie": "Rue Saint-Dominique",
          "code_postal": "75007",
          "commune": "Paris 7e Arrondissement",
          "code_insee_commune": "75107",
          "departement": "75",
          "pays": "France"
        },
        "courriel": "contact@fondation-exemple.fr",
        "telephone": "+33123456789"
      },
      "activite": {
        "objet_social": "L'aménagement et l'entretien d'un immeuble destiné à permettre la jouissance de locaux et de salles de réunions aux organismes de chimie pure et appliquée, en vue de contribuer à l'avancement de la science chimique et au développement de ses applications.",
        "domaine_interet_general": "Scientifique",
        "activite_internationale_prevue_par_statuts": false
      },
      "dirigeants": [
        {
          "nom": "DUPONT",
          "prenom": "Marie",
          "date_naissance": "1975-04-12",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "20 Rue Exemple 75001 Paris",
            "code_postal": "75001",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Juriste",
          "date_entree_fonction": "2018-06-23",
          "date_sortie_fonction": null,
          "fonction": "Président",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": null
        },
        {
          "nom": "MARTIN",
          "prenom": "Paul",
          "date_naissance": "1968-11-02",
          "nationalite": "France",
          "adresse_domiciliation": {
            "adresse_complete": "5 Avenue Exemple 75008 Paris",
            "code_postal": "75008",
            "commune": "Paris",
            "pays": "France"
          },
          "pays_residence": "France",
          "profession": "Chercheur",
          "date_entree_fonction": "2018-06-28",
          "date_sortie_fonction": null,
          "fonction": "Trésorier",
          "qualite": "Membre du conseil d'administration",
          "fondateur": false,
          "personne_morale": null
        }
      ],
      "liens_entre_organismes": {
        "organisme_issu_transformation": null,
        "organisme_issu_fusion": null,
        "organismes_issus_scission": []
      },
      "situation_financiere": {
        "annees_subventions_publiques": [
          2024,
          2025
        ],
        "annees_appel_generosite_publique": [
          2025
        ],
        "annees_financements_etrangers": []
      },
      "conformite_comptable": {
        "etat_transmission_comptes": "En règle",
        "annees_exercices_comptables_transmis": [
          2023,
          2024,
          2025
        ]
      },
      "documents": [
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a41",
          "type": "Statuts",
          "nom_original": "Statuts 1957.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        },
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a42",
          "type": "Comptes",
          "nom_original": "Comptes annuels 2025.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        },
        {
          "id": "7e7867b6-8fe0-11f1-a424-f28dce965a43",
          "type": "Rapport d'activité",
          "nom_original": "Rapport d'activité 2025.pdf",
          "type_mime": "application/pdf",
          "date_depot": "2026-06-24"
        }
      ]
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/fondations/78430893400016"
  ```

  </p>
  </details>
* [404.yaml](404.yaml)

  Status `404`

  Fondation non trouvée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren_or_siret_or_rnf": "099-fdd-99999-99"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/ministere_interieur/siaf/fondations/099-fdd-99999-99"
  ```

  </p>
  </details>
