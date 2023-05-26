# Données siège social
* [association.yaml](association.yaml)

  Status `200`

  Payload INSEE Siège Unité Légale des Associations - succès 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "775672272"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siret": "77567227221138",
      "siege_social": true,
      "etat_administratif": "A",
      "status_diffusion": "diffusible",
      "date_fermeture": null,
      "enseigne": null,
      "activite_principale": {
        "code": "88.99B",
        "nomenclature": "NAFRev2",
        "libelle": "Action sociale sans hébergement n.c.a."
      },
      "tranche_effectif_salarie": {
        "de": null,
        "a": null,
        "code": "NN",
        "date_reference": null,
        "intitule": "Unités non employeuses"
      },
      "diffusable_commercialement": true,
      "date_creation": 1138143600,
      "unite_legale": {
        "siren": "775672272",
        "siret_siege_social": "77567227221138",
        "type": "personne_morale",
        "status_diffusion": "diffusible",
        "personne_morale_attributs": {
          "raison_sociale": "CROIX ROUGE FRANCAISE",
          "sigle": "CRF"
        },
        "personne_physique_attributs": {
          "pseudonyme": null,
          "prenom_usuel": null,
          "prenom_1": null,
          "prenom_2": null,
          "prenom_3": null,
          "prenom_4": null,
          "nom_usage": null,
          "nom_naissance": null,
          "sexe": null
        },
        "categorie_entreprise": "GE",
        "diffusable_commercialement": true,
        "forme_juridique": {
          "code": "9230",
          "libelle": "Association déclarée, reconnue d'utilité publique"
        },
        "activite_principale": {
          "code": "88.99B",
          "nomenclature": "NAFRev2",
          "libelle": "Action sociale sans hébergement n.c.a."
        },
        "tranche_effectif_salarie": {
          "de": 10000,
          "a": null,
          "code": "53",
          "date_reference": "2020",
          "intitule": "10 000 salariés et plus"
        },
        "economie_sociale_et_solidaire": false,
        "date_creation": -556765200,
        "etat_administratif": "A"
      },
      "adresse": {
        "complement_adresse": "SITE CROIX ROUGE",
        "numero_voie": "98",
        "indice_repetition_voie": null,
        "type_voie": "RUE",
        "libelle_voie": "DIDOT",
        "code_postal": "75014",
        "libelle_commune": "PARIS 14",
        "libelle_commune_etranger": null,
        "distribution_speciale": null,
        "code_commune": "75114",
        "code_cedex": "75694",
        "libelle_cedex": "PARIS CEDEX 14",
        "status_diffusion": "diffusible",
        "code_pays_etranger": null,
        "libelle_pays_etranger": null,
        "acheminement_postal": {
          "l1": "CROIX ROUGE FRANCAISE",
          "l2": "",
          "l3": "SITE CROIX ROUGE",
          "l4": "98 RUE DIDOT",
          "l5": "",
          "l6": "75694 PARIS CEDEX 14",
          "l7": "FRANCE"
        }
      }
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/775672272"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1676329200,
      "redirect_from_siret": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/775672272/siege_social"
  ```

  </p>
  </details>
* [association_regime_alsace_moselle.yaml](association_regime_alsace_moselle.yaml)

  Status `200`

  Association (régime Alsace-Moselle)

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "424179364"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siret": "42417936400023",
      "siege_social": true,
      "etat_administratif": "A",
      "date_fermeture": null,
      "enseigne": null,
      "status_diffusion": "diffusible",
      "activite_principale": {
        "code": "94.99Z",
        "nomenclature": "NAFRev2",
        "libelle": "Autres organisations fonctionnant par adhésion volontaire"
      },
      "tranche_effectif_salarie": {
        "de": null,
        "a": null,
        "code": null,
        "date_reference": null,
        "intitule": null
      },
      "diffusable_commercialement": true,
      "date_creation": 1626300000,
      "unite_legale": {
        "siren": "424179364",
        "siret_siege_social": "42417936400023",
        "type": "personne_morale",
        "status_diffusion": "diffusible",
        "personne_morale_attributs": {
          "raison_sociale": "ASSOCIATION SOCIO-CULTURELLE - LE REPERE",
          "sigle": null
        },
        "personne_physique_attributs": {
          "pseudonyme": null,
          "prenom_usuel": null,
          "prenom_1": null,
          "prenom_2": null,
          "prenom_3": null,
          "prenom_4": null,
          "nom_usage": null,
          "nom_naissance": null,
          "sexe": null
        },
        "categorie_entreprise": "PME",
        "diffusable_commercialement": true,
        "forme_juridique": {
          "code": "9260",
          "libelle": "Association de droit local (Bas-Rhin, Haut-Rhin et Moselle)"
        },
        "activite_principale": {
          "code": "94.99Z",
          "nomenclature": "NAFRev2",
          "libelle": "Autres organisations fonctionnant par adhésion volontaire"
        },
        "tranche_effectif_salarie": {
          "de": null,
          "a": null,
          "code": "NN",
          "date_reference": null,
          "intitule": "Unités non employeuses"
        },
        "economie_sociale_et_solidaire": true,
        "date_creation": 931298400,
        "etat_administratif": "A"
      },
      "adresse": {
        "complement_adresse": null,
        "numero_voie": "169",
        "indice_repetition_voie": null,
        "type_voie": null,
        "libelle_voie": "GRAND RUE",
        "code_postal": "67130",
        "libelle_commune": "SCHIRMECK",
        "libelle_commune_etranger": null,
        "distribution_speciale": null,
        "status_diffusion": "diffusible",
        "code_commune": "67448",
        "code_cedex": null,
        "libelle_cedex": null,
        "code_pays_etranger": null,
        "libelle_pays_etranger": null,
        "acheminement_postal": {
          "l1": "ASSOCIATION SOCIO-CULTURELLE - LE REPERE",
          "l2": "",
          "l3": "",
          "l4": "169 GRAND RUE",
          "l5": "",
          "l6": "67130 SCHIRMECK",
          "l7": "FRANCE"
        }
      }
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/424179364"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1635458400,
      "redirect_from_siret": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/424179364/siege_social"
  ```

  </p>
  </details>
* [personne_morale.yaml](personne_morale.yaml)

  Status `200`

  Payload INSEE Siège unité légale Personne Morale - succès 200

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
      "siret": "55204944776279",
      "siege_social": true,
      "status_diffusion": "diffusible",
      "etat_administratif": "A",
      "date_fermeture": null,
      "enseigne": "SNCF ST DENIS 2 PL AUX ETOILES",
      "activite_principale": {
        "code": "49.10Z",
        "nomenclature": "NAFRev2",
        "libelle": "Transport ferroviaire interurbain de voyageurs"
      },
      "tranche_effectif_salarie": {
        "de": 500,
        "a": 999,
        "code": "41",
        "date_reference": "2020",
        "intitule": "500 à 999 salariés"
      },
      "diffusable_commercialement": true,
      "date_creation": 519861600,
      "unite_legale": {
        "siren": "552049447",
        "siret_siege_social": "55204944776279",
        "status_diffusion": "diffusible",
        "type": "personne_morale",
        "personne_morale_attributs": {
          "raison_sociale": "SOCIETE NATIONALE SNCF",
          "sigle": "SNCF"
        },
        "personne_physique_attributs": {
          "pseudonyme": null,
          "prenom_usuel": null,
          "prenom_1": null,
          "prenom_2": null,
          "prenom_3": null,
          "prenom_4": null,
          "nom_usage": null,
          "nom_naissance": null,
          "sexe": null
        },
        "categorie_entreprise": "GE",
        "diffusable_commercialement": true,
        "forme_juridique": {
          "code": "5599",
          "libelle": "SA à conseil d'administration (s.a.i.)"
        },
        "activite_principale": {
          "code": "49.10Z",
          "nomenclature": "NAFRev2",
          "libelle": "Transport ferroviaire interurbain de voyageurs"
        },
        "tranche_effectif_salarie": {
          "de": 10000,
          "a": null,
          "code": "53",
          "date_reference": "2020",
          "intitule": "10 000 salariés et plus"
        },
        "economie_sociale_et_solidaire": false,
        "date_creation": -473389200,
        "etat_administratif": "A"
      },
      "adresse": {
        "complement_adresse": null,
        "numero_voie": "2",
        "indice_repetition_voie": null,
        "type_voie": "PLACE",
        "libelle_voie": "AUX ETOILES",
        "code_postal": "93210",
        "libelle_commune": "SAINT-DENIS",
        "libelle_commune_etranger": null,
        "distribution_speciale": null,
        "code_commune": "93066",
        "code_cedex": null,
        "libelle_cedex": null,
        "code_pays_etranger": null,
        "status_diffusion": "diffusible",
        "libelle_pays_etranger": null,
        "acheminement_postal": {
          "l1": "SOCIETE NATIONALE SNCF",
          "l2": "",
          "l3": "",
          "l4": "2 PLACE AUX ETOILES",
          "l5": "",
          "l6": "93210 SAINT-DENIS",
          "l7": "FRANCE"
        }
      }
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/552049447"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1661724000,
      "redirect_from_siret": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/552049447/siege_social"
  ```

  </p>
  </details>
* [personne_morale_etat_cesse.yaml](personne_morale_etat_cesse.yaml)

  Status `200`

  Personne morale (PM) cessée

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "350051447"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siret": "35005144700018",
      "siege_social": true,
      "etat_administratif": "F",
      "date_fermeture": 816390000,
      "enseigne": null,
      "activite_principale": {
        "code": "70.2C",
        "nomenclature": "NAF1993",
        "libelle": "ancienne révision NAF (NAF1993) non supportée"
      },
      "tranche_effectif_salarie": {
        "de": null,
        "a": null,
        "code": "NN",
        "date_reference": null,
        "intitule": "Unités non employeuses"
      },
      "diffusable_commercialement": true,
      "date_creation": null,
      "status_diffusion": "diffusible",
      "unite_legale": {
        "siren": "350051447",
        "siret_siege_social": "35005144700018",
        "type": "personne_morale",
        "status_diffusion": "diffusible",
        "personne_morale_attributs": {
          "raison_sociale": "SCI SERGENT",
          "sigle": null
        },
        "personne_physique_attributs": {
          "pseudonyme": null,
          "prenom_usuel": null,
          "prenom_1": null,
          "prenom_2": null,
          "prenom_3": null,
          "prenom_4": null,
          "nom_usage": null,
          "nom_naissance": null,
          "sexe": null
        },
        "categorie_entreprise": null,
        "diffusable_commercialement": true,
        "forme_juridique": {
          "code": "6540",
          "libelle": "Société civile immobilière"
        },
        "activite_principale": {
          "code": "70.2C",
          "nomenclature": "NAFRev1",
          "libelle": "ancienne révision NAF (NAFRev1) non supportée"
        },
        "tranche_effectif_salarie": {
          "de": null,
          "a": null,
          "code": null,
          "date_reference": null,
          "intitule": null
        },
        "economie_sociale_et_solidaire": null,
        "date_creation": 605746800,
        "etat_administratif": "C"
      },
      "adresse": {
        "complement_adresse": null,
        "numero_voie": "4",
        "indice_repetition_voie": null,
        "type_voie": "ALLÉE",
        "libelle_voie": "DU COMMANDANT",
        "code_postal": "75017",
        "libelle_commune": "PARIS 17",
        "status_diffusion": "diffusible",
        "libelle_commune_etranger": null,
        "distribution_speciale": null,
        "code_commune": "75117",
        "code_cedex": null,
        "libelle_cedex": null,
        "code_pays_etranger": null,
        "libelle_pays_etranger": null,
        "acheminement_postal": {
          "l1": "SCI SERGENT",
          "l2": "",
          "l3": "",
          "l4": "4 ALLÉE DU COMMANDANT",
          "l5": "",
          "l6": "75017 PARIS 17",
          "l7": "FRANCE"
        }
      }
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/350051447"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1671404400,
      "redirect_from_siret": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/350051447/siege_social"
  ```

  </p>
  </details>
* [personne_physique_diffusible.yaml](personne_physique_diffusible.yaml)

  Status `200`

  Personne physique (PP) - diffusible

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "478464803"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siret": "47846480300319",
      "siege_social": true,
      "etat_administratif": "A",
      "date_fermeture": null,
      "enseigne": null,
      "status_diffusion": "diffusible",
      "activite_principale": {
        "code": "74.10Z",
        "nomenclature": "NAFRev2",
        "libelle": "Activités spécialisées de design"
      },
      "tranche_effectif_salarie": {
        "de": null,
        "a": null,
        "code": null,
        "date_reference": null,
        "intitule": null
      },
      "diffusable_commercialement": true,
      "date_creation": 1550790000,
      "unite_legale": {
        "siren": "478464803",
        "siret_siege_social": "47846480300319",
        "type": "personne_physique",
        "status_diffusion": "diffusible",
        "personne_morale_attributs": {
          "raison_sociale": null,
          "sigle": null
        },
        "personne_physique_attributs": {
          "pseudonyme": null,
          "prenom_usuel": "MAXIME",
          "prenom_1": "MAXIME",
          "prenom_2": "LAURENT",
          "prenom_3": "ERIC",
          "prenom_4": null,
          "nom_usage": null,
          "nom_naissance": "DUPONT",
          "sexe": "F"
        },
        "categorie_entreprise": "PME",
        "diffusable_commercialement": false,
        "forme_juridique": {
          "code": "1000",
          "libelle": "Entrepreneur individuel"
        },
        "activite_principale": {
          "code": "74.10Z",
          "nomenclature": "NAFRev2",
          "libelle": "Activités spécialisées de design"
        },
        "tranche_effectif_salarie": {
          "de": null,
          "a": null,
          "code": null,
          "date_reference": null,
          "intitule": null
        },
        "economie_sociale_et_solidaire": null,
        "date_creation": 1085349600,
        "etat_administratif": "A"
      },
      "adresse": {
        "complement_adresse": null,
        "numero_voie": "346",
        "indice_repetition_voie": null,
        "type_voie": "ALLÉE",
        "libelle_voie": "DE LA PLAGE",
        "code_postal": "16210",
        "libelle_commune": "MEDILLAC",
        "libelle_commune_etranger": null,
        "distribution_speciale": null,
        "code_commune": "16399",
        "code_cedex": null,
        "libelle_cedex": null,
        "code_pays_etranger": null,
        "libelle_pays_etranger": null,
        "status_diffusion": "diffusible",
        "acheminement_postal": {
          "l1": "",
          "l2": "MAXIME DUPONT",
          "l3": "",
          "l4": "346 ALLÉE DE LA PLAGE",
          "l5": "",
          "l6": "16210 MEDILLAC",
          "l7": "FRANCE"
        }
      }
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/478464803"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1606258800,
      "redirect_from_siret": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/478464803/siege_social"
  ```

  </p>
  </details>
* [personne_physique_non-diffusible.yaml](personne_physique_non-diffusible.yaml)

  Status `200`

  Personne physique (PP) - non diffusible

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siren": "350042925"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "siret": "35004292500031",
      "siege_social": true,
      "etat_administratif": "A",
      "date_fermeture": null,
      "status_diffusion": "partiellement_diffusible",
      "enseigne": null,
      "activite_principale": {
        "code": "74.10Z",
        "nomenclature": "NAFRev2",
        "libelle": "Activités spécialisées de design"
      },
      "tranche_effectif_salarie": {
        "de": null,
        "a": null,
        "code": null,
        "date_reference": null,
        "intitule": null
      },
      "diffusable_commercialement": false,
      "date_creation": 1396303200,
      "unite_legale": {
        "siren": "350042925",
        "siret_siege_social": "35004292500031",
        "status_diffusion": "partiellement_diffusible",
        "type": "personne_physique",
        "personne_morale_attributs": {
          "raison_sociale": null,
          "sigle": null
        },
        "personne_physique_attributs": {
          "pseudonyme": null,
          "prenom_usuel": "AURELIE",
          "prenom_1": "AURELIE",
          "prenom_2": "JAQUELINE",
          "prenom_3": "NADIA",
          "prenom_4": null,
          "nom_usage": null,
          "nom_naissance": "MOREAU",
          "sexe": "F"
        },
        "categorie_entreprise": "PME",
        "diffusable_commercialement": false,
        "forme_juridique": {
          "code": "1000",
          "libelle": "Entrepreneur individuel"
        },
        "activite_principale": {
          "code": "74.10Z",
          "nomenclature": "NAFRev2",
          "libelle": "Activités spécialisées de design"
        },
        "tranche_effectif_salarie": {
          "de": null,
          "a": null,
          "code": null,
          "date_reference": null,
          "intitule": null
        },
        "economie_sociale_et_solidaire": null,
        "date_creation": 1326303200,
        "etat_administratif": "A"
      },
      "adresse": {
        "complement_adresse": null,
        "numero_voie": "346",
        "indice_repetition_voie": null,
        "type_voie": "ALLÉE",
        "libelle_voie": "DE LA PLAGE",
        "code_postal": "16210",
        "libelle_commune": "MEDILLAC",
        "libelle_commune_etranger": null,
        "distribution_speciale": null,
        "code_commune": "16399",
        "status_diffusion": "partiellement_diffusible",
        "code_cedex": null,
        "libelle_cedex": null,
        "code_pays_etranger": null,
        "libelle_pays_etranger": null,
        "acheminement_postal": {
          "l1": "",
          "l2": "MOREAU AURELIE",
          "l3": "",
          "l4": "346 ALLÉE DE LA PLAGE",
          "l5": "",
          "l6": "16210 MEDILLAC",
          "l7": "FRANCE"
        }
      }
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/350042925"
    },
    "meta": {
      "date_derniere_mise_a_jour": 267038293600,
      "redirect_from_siret": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/350042925/siege_social"
  ```

  </p>
  </details>
