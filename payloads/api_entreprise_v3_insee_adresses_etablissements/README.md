# Adresse établissement
* [association.yaml](association.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "77567227221138",
    "context": "Contexte de test",
    "recipient": "13002526500013",
    "object": "Demande de subventions 135"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/77567227221138/adresse"
  ```

  </p>
  </details>
* [association_regime_alsace_moselle.yaml](association_regime_alsace_moselle.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "42417936400023",
    "context": "Contexte de test",
    "recipient": "13002526500013",
    "object": "Demande de subventions 135"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/42417936400023/adresse"
  ```

  </p>
  </details>
* [personne_morale.yaml](personne_morale.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "55204944776279",
    "context": "Contexte de test",
    "recipient": "13002526500013",
    "object": "Marchés publics 123"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/55204944776279/adresse"
  ```

  </p>
  </details>
* [personne_morale_etat_cesse.yaml](personne_morale_etat_cesse.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "35005144700018",
    "context": "Contexte de test",
    "recipient": "13002526500013",
    "object": "Marchés publics 132"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/35005144700018/adresse"
  ```

  </p>
  </details>
* [personne_physique_diffusible.yaml](personne_physique_diffusible.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "47846480300319",
    "context": "Contexte de test",
    "recipient": "13002526500013",
    "object": "Marché Numéro 126"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/47846480300319/adresse"
  ```

  </p>
  </details>
* [personne_physique_non-diffusible.yaml](personne_physique_non-diffusible.yaml)

  Status `200`

  <details><summary>Paramètres</summary>
  <p>

  ```json
  {
    "siret": "35004292500031",
    "context": "Contexte de test",
    "recipient": "13002526500013",
    "object": "Marché Numéro 125"
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
      "acheminement_postal": {
        "l1": "",
        "l2": "MOREAU AURELIE",
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
      "unite_legale": "https://entreprise.api.gouv.fr/v3/insee/sirene/unites_legales/350042925",
      "etablissement": "https://entreprise.api.gouv.fr/v3/insee/sirene/etablissements/35004292500031"
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
    --url "https://staging.entreprise.api.gouv.fr/v3/insee/sirene/etablissements/35004292500031/adresse"
  ```

  </p>
  </details>
