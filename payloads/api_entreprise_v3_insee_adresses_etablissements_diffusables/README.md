# Adresse établissement diffusible
### Retour par défaut de l'API
lors d'un appel avec des paramètres valides l'API renvoie systématiquement cette réponse :

  <details><summary>Réponse par défault de l'API</summary>
  <p>

  ```json
  {
    "data": {
      "numero_voie": "22",
      "indice_repetition_voie": "bis",
      "type_voie": "RUE",
      "libelle_voie": "DE LA PAIX",
      "complement_adresse": "ZAE SAINT GUENAULT",
      "code_commune": "75112",
      "code_postal": "75016",
      "distribution_speciale": "dummy",
      "code_cedex": "75590",
      "libelle_cedex": "PARIS CEDEX 12",
      "libelle_commune": "PARIS 12",
      "libelle_commune_etranger": "dummy",
      "code_pays_etranger": "99132",
      "libelle_pays_etranger": "ROYAUME-UNI",
      "status_diffusion": "diffusible",
      "acheminement_postal": {
        "l1": "DIRECTION INTERMINISTERIELLE DU NUMERIQUE",
        "l2": "JEAN MARIE DURAND",
        "l3": "ZAE SAINT GUENAULT",
        "l4": "51 BIS RUE DE LA PAIX",
        "l5": "CS 72809",
        "l6": "75256 PARIX CEDEX 12",
        "l7": "FRANCE"
      }
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/api/v3/insee/unites_legales/130025265",
      "etablissement": "https://entreprise.api.gouv.fr/api/v3/insee/etablissements/13002526500013"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1618396818
    }
  }
  ```

  </p>
  </details>
* [association.yaml](association.yaml)

  Status `200`

  Payload INSEE Adresse Association diffusibles - succès 200

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "77567227221138"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "numero_voie": "98",
      "indice_repetition_voie": null,
      "type_voie": "RUE",
      "libelle_voie": "DIDOT",
      "complement_adresse": "SITE CROIX ROUGE",
      "code_commune": "75114",
      "libelle_commune": "PARIS 14",
      "code_postal": "75014",
      "distribution_speciale": null,
      "code_cedex": "75694",
      "libelle_cedex": "PARIS CEDEX 14",
      "status_diffusion": "diffusible",
      "acheminement_postal": {
        "l1": "CROIX ROUGE FRANCAISE",
        "l2": "",
        "l3": "SITE CROIX ROUGE",
        "l4": "98 RUE DIDOT",
        "l5": "",
        "l6": "75694 PARIS CEDEX 14",
        "l7": "FRANCE"
      },
      "libelle_commune_etranger": null,
      "code_pays_etranger": null,
      "libelle_pays_etranger": null
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/775672272",
      "etablissement": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/77567227221138"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1676329200
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/diffusibles/77567227221138/adresse"
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
    "siret": "42417936400023"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "numero_voie": "169",
      "indice_repetition_voie": null,
      "type_voie": null,
      "libelle_voie": "GRAND RUE",
      "complement_adresse": null,
      "code_commune": "67448",
      "libelle_commune": "SCHIRMECK",
      "code_postal": "67130",
      "distribution_speciale": null,
      "status_diffusion": "diffusible",
      "code_cedex": null,
      "libelle_cedex": null,
      "acheminement_postal": {
        "l1": "ASSOCIATION SOCIO-CULTURELLE - LE REPERE",
        "l2": "",
        "l3": "",
        "l4": "169 GRAND RUE",
        "l5": "",
        "l6": "67130 SCHIRMECK",
        "l7": "FRANCE"
      },
      "libelle_commune_etranger": null,
      "code_pays_etranger": null,
      "libelle_pays_etranger": null
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/424179364",
      "etablissement": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/42417936400023"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1635458400
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/diffusibles/42417936400023/adresse"
  ```

  </p>
  </details>
* [personne_morale.yaml](personne_morale.yaml)

  Status `200`

  Personne morale

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "55204944776279"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "numero_voie": "2",
      "indice_repetition_voie": null,
      "type_voie": "PLACE",
      "libelle_voie": "AUX ETOILES",
      "complement_adresse": null,
      "code_commune": "93066",
      "libelle_commune": "SAINT-DENIS",
      "code_postal": "93210",
      "distribution_speciale": null,
      "status_diffusion": "diffusible",
      "code_cedex": null,
      "libelle_cedex": null,
      "acheminement_postal": {
        "l1": "SOCIETE NATIONALE SNCF",
        "l2": "",
        "l3": "",
        "l4": "2 PLACE AUX ETOILES",
        "l5": "",
        "l6": "93210 SAINT-DENIS",
        "l7": "FRANCE"
      },
      "libelle_commune_etranger": null,
      "code_pays_etranger": null,
      "libelle_pays_etranger": null
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/552049447",
      "etablissement": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/55204944776279"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1661724000
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/diffusibles/55204944776279/adresse"
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
    "siret": "35005144700018"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "numero_voie": "4",
      "indice_repetition_voie": null,
      "type_voie": "ALLÉE",
      "libelle_voie": "DU COMMANDANT",
      "complement_adresse": null,
      "code_commune": "75117",
      "libelle_commune": "PARIS 17",
      "code_postal": "75017",
      "distribution_speciale": null,
      "status_diffusion": "diffusible",
      "code_cedex": null,
      "libelle_cedex": null,
      "acheminement_postal": {
        "l1": "SCI SERGENT",
        "l2": "",
        "l3": "",
        "l4": "4 ALLÉE DU COMMANDANT",
        "l5": "",
        "l6": "75017 PARIS 17",
        "l7": "FRANCE"
      },
      "libelle_commune_etranger": null,
      "code_pays_etranger": null,
      "libelle_pays_etranger": null
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/350051447",
      "etablissement": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/35005144700018"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1661724000
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/diffusibles/35005144700018/adresse"
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
    "siret": "47846480300319"
  }
  ```

  </p>
  </details>

  <details><summary>Réponse API</summary>
  <p>

  ```json
  {
    "data": {
      "numero_voie": "346",
      "indice_repetition_voie": null,
      "type_voie": "ALLÉE",
      "libelle_voie": "DE LA PLAGE",
      "complement_adresse": "null",
      "code_commune": "16399",
      "libelle_commune": "MEDILLAC",
      "code_postal": "16210",
      "distribution_speciale": null,
      "code_cedex": null,
      "libelle_cedex": null,
      "status_diffusion": "diffusible",
      "acheminement_postal": {
        "l1": "",
        "l2": "MAXIME DUPONT",
        "l3": "",
        "l4": "346 ALLÉE DE LA PLAGE",
        "l5": "",
        "l6": "16210 MEDILLAC",
        "l7": "FRANCE"
      },
      "libelle_commune_etranger": null,
      "code_pays_etranger": null,
      "libelle_pays_etranger": null
    },
    "links": {
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/478464803",
      "etablissement": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/47846480300319"
    },
    "meta": {
      "date_derniere_mise_a_jour": 1606258800
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/diffusibles/47846480300319/adresse"
  ```

  </p>
  </details>
* [personne_physique_non-diffusible.yaml](personne_physique_non-diffusible.yaml)

  Status `404`

  Personne physique (PP) - non diffusible

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "35004292500031"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/diffusibles/35004292500031/adresse"
  ```

  </p>
  </details>
