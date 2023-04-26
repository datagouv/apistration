# Données unité légale diffusible
* [association.yaml](association.yaml)

  Status `200`

  Payload INSEE Unité Légale des Associations - succès 200

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
      "siren": "775672272",
      "siret_siege_social": "77567227221138",
      "status_diffusion": "diffusible",
      "categorie_entreprise": "GE",
      "diffusable_commercialement": true,
      "type": "personne_morale",
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
      "etat_administratif": "A",
      "economie_sociale_et_solidaire": false,
      "date_cessation": null,
      "date_creation": -556765200
    },
    "links": {
      "siege_social": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/77567227221138",
      "siege_social_adresse": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/77567227221138/adresse"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1678143600,
      "redirect_from_siren": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/diffusibles/775672272"
  ```

  </p>
  </details>
* [association_regime_alsace_moselle.yaml](association_regime_alsace_moselle.yaml)

  Status `200`

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
      "siren": "424179364",
      "siret_siege_social": "42417936400023",
      "categorie_entreprise": "PME",
      "status_diffusion": "diffusible",
      "diffusable_commercialement": true,
      "type": "personne_morale",
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
      "etat_administratif": "A",
      "economie_sociale_et_solidaire": true,
      "date_cessation": null,
      "date_creation": 931298400
    },
    "links": {
      "siege_social": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/42417936400023",
      "siege_social_adresse": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/42417936400023/adresse"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1635458400,
      "redirect_from_siren": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/diffusibles/424179364"
  ```

  </p>
  </details>
* [personne_morale.yaml](personne_morale.yaml)

  Status `200`

  Payload INSEE unité légale Personne Morale - succès 200

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
      "siret_siege_social": "55204944776279",
      "categorie_entreprise": "GE",
      "status_diffusion": "diffusible",
      "diffusable_commercialement": true,
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
      "etat_administratif": "A",
      "economie_sociale_et_solidaire": false,
      "date_cessation": null,
      "date_creation": -473389200
    },
    "links": {
      "siege_social": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/55204944776279",
      "siege_social_adresse": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/55204944776279/adresse"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1673478000,
      "redirect_from_siren": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/diffusibles/552049447"
  ```

  </p>
  </details>
* [personne_morale_etat_cesse.yaml](personne_morale_etat_cesse.yaml)

  Status `200`

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
      "siren": "350051447",
      "siret_siege_social": "35005144700018",
      "categorie_entreprise": null,
      "diffusable_commercialement": true,
      "status_diffusion": "diffusible",
      "type": "personne_morale",
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
      "forme_juridique": {
        "code": "6540",
        "libelle": "Société civile immobilière"
      },
      "activite_principale": {
        "code": "70.2C",
        "nomenclature": "NAF1993",
        "libelle": "ancienne révision NAF (NAF1993) non supportée"
      },
      "tranche_effectif_salarie": {
        "de": null,
        "a": null,
        "code": null,
        "date_reference": null,
        "intitule": null
      },
      "etat_administratif": "C",
      "economie_sociale_et_solidaire": null,
      "date_cessation": 816390000,
      "date_creation": 605746800
    },
    "links": {
      "siege_social": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/35005144700018",
      "siege_social_adresse": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/35005144700018/adresse"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1671404400,
      "redirect_from_siren": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/diffusibles/350051447"
  ```

  </p>
  </details>
* [personne_physique_diffusible.yaml](personne_physique_diffusible.yaml)

  Status `200`

  Payload INSEE Adresse unité légale Personne Physique diffusible - succès 200

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
      "siren": "478464803",
      "siret_siege_social": "47846480300319",
      "categorie_entreprise": null,
      "diffusable_commercialement": true,
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
        "sexe": "M"
      },
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
        "code": "NN",
        "date_reference": null,
        "intitule": "Unités non employeuses"
      },
      "etat_administratif": "A",
      "economie_sociale_et_solidaire": null,
      "date_cessation": null,
      "date_creation": 1085349600
    },
    "links": {
      "siege_social": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/47846480300319",
      "siege_social_adresse": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/47846480300319/adresse"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1667430000,
      "redirect_from_siren": null
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/diffusibles/478464803"
  ```

  </p>
  </details>
* [personne_physique_non-diffusible.yaml](personne_physique_non-diffusible.yaml)

  Status `404`

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
    "errors": [
      {
        "code": "01003",
        "title": "Entité non trouvée",
        "detail": "L'identifiant indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.",
        "meta": {
          "provider": "INSEE"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/diffusibles/350042925"
  ```

  </p>
  </details>
