---
name: edit-endpoint
description: >
  Modifier la documentation d'un endpoint API : fiche metier (perimetre, FAQ,
  keywords, description) ou swagger (schema OpenAPI, attributs, tags).
  Utiliser quand l'utilisateur veut editer, ajouter ou mettre a jour un endpoint
  dans le catalogue API Entreprise ou API Particulier. Triggers : "modifier la fiche",
  "ajouter un endpoint", "mettre a jour le swagger", "changer la description",
  "ajouter une FAQ", "modifier le perimetre", "editer endpoint".
---

# Editer un endpoint

## Localiser le fichier

Tout est dans `commons/endpoints/` :

```
commons/endpoints/
  api_entreprise/*.yml      # endpoints API Entreprise
  api_particulier/*.yml     # endpoints API Particulier
  _swagger_shared/          # swagger partage (ancres YAML entre endpoints)
```

Trouver un endpoint par uid :

```bash
grep -r "uid: 'provider/resource'" commons/endpoints/
```

## Format d'un fichier endpoint

```yaml
fiche:
  - uid: 'provider/resource'
    path: '/v3/provider/resource/{param}'
    position: 501                    # ordre dans le catalogue
    opening: protected               # protected ou public
    provider_uids: ['provider']
    call_id: "SIRET"
    keywords: [mot, cle]
    perimeter:
      entity_type_description: |+    # qui est concerne
      geographical_scope_description: |+
      updating_rules_description: |+
      know_more_description: |+
      entities: [entreprises, associations]
    data:
      description: |+                # description des donnees renvoyees
    parameters:
      - Description du parametre
    format:
      - Donnee structuree JSON
    faq:
      - q: "Question ?"
        a: |+ Reponse
    historique: |+                    # changelog entre versions
    swagger:
      provider.resource_name:        # cle dottee = SwaggerData.get path
        title: "Titre swagger"
        description: "Description technique"
        tags: ["Categorie"]
        attributes:                  # ou document_url_properties pour PDF
          champ:
            type: "string"
            title: "Titre"
            example: "valeur"
```

## Fiche metier

Modifier les champs sous `fiche:` (hors `swagger:`). Valider :

```bash
cd site && bundle exec rspec spec/stores/
```

## Swagger

### Swagger embarque

Modifier `fiche[].swagger:` dans le fichier endpoint. La cle dottee (`provider.resource_name`) correspond a `SwaggerData.get('provider.resource_name.property')` dans les specs rswag.

### Swagger dans `_swagger_shared/`

Les providers multi-endpoints gardent leur swagger dans `_swagger_shared/<provider>.yml` :
insee, cnav, dgfip, inpi_rne, mi, infogreffe, cnous, mesri, men, france_travail, gip_mds.

Definitions partagees : `_swagger_shared/00_commons.yml` (params SIREN/SIRET), `_swagger_shared/civility.yml` (identite pivot).

### Valider le swagger

```bash
cd siade && bundle exec rspec spec/requests/api_entreprise/v3_and_more/<provider>/<resource>/
bin/generate_swagger.sh
```

## Ajouter un endpoint

1. Copier le template : `commons/endpoints/template.entreprise.yml.example` (ou `particulier`)
2. Creer le fichier dans `commons/endpoints/api_entreprise/` ou `api_particulier/`
3. Remplir fiche + swagger
4. Creer la spec rswag dans `siade/spec/requests/`
5. `cd siade && bin/generate_swagger.sh`
