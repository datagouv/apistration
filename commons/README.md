## commons

Shared assets / code / data used by more than one of the sibling apps in this
repository (`site/`, `siade/`, `mocks/`).

### How it gets into each app

Each app is deployed in isolation: only its own subdirectory (e.g. `site/`) is
copied to the server. To make `commons/` files available inside an app at
deploy time, two things are wired up:

1. **Local development:** each file a consumer app expects from `commons/` is
   committed as a symlink at the path the app code reads. App code references
   the in-app path directly; the symlink resolves to the shared file in dev.

2. **Deployment:** each consumer app contains an `.expand` file at its root
   listing the commons files that must be materialized inside the deploy
   build. Each non-comment line has the form `source:destination` where
   `source` is a path relative to the repository root and `destination` is a
   path relative to the app's build directory. If `:destination` is omitted,
   `source` is reused as the destination. The deployment script (see
   `very_ansible/roles/rails_app/templates/deploy_script.sh.j2`) replaces each
   destination path (which is a symlink on disk) with a real copy of the
   source taken from the repository root.

### `commons/endpoints/`

Toutes les données d'un endpoint API (fiche métier + schéma swagger) sont
regroupées ici. Structure :

```
commons/endpoints/
├── api_entreprise/          # Un fichier par endpoint (ou groupe de versions)
├── api_particulier/
├── _swagger_shared/         # Définitions swagger partagées entre plusieurs endpoints
│                            # (paramètres SIREN/SIRET, identité pivot, schémas avec
│                            # ancres YAML réutilisées). Accessibles via SwaggerData.get.
├── template.entreprise.yml.example
└── template.particulier.yml.example
```

Chaque fichier endpoint a le format suivant :

```yaml
fiche:
  - uid: 'provider/resource'
    path: '/v3/provider/resource/{param}'
    perimeter: ...
    keywords: [...]
    swagger:
      provider.resource_name:          # clé dottée = chemin SwaggerData.get
        title: "Nom dans le swagger"
        description: "..."
        tags: ["Catégorie"]
        attributes:
          champ:
            type: "string"
            example: "valeur"
```

- **`fiche:`** — données métier (périmètre, FAQ, keywords…), lues par `EndpointsStore` (site)
- **`swagger:`** — schéma OpenAPI, lu par `SwaggerData` (siade). La clé dottée
  (`provider.resource_name`) correspond au chemin d'accès
  `SwaggerData.get('provider.resource_name.property')` utilisé dans les specs rswag.
- **`_swagger_shared/`** — définitions partagées entre plusieurs endpoints d'un même
  fournisseur (ancres YAML, paramètres communs). Ces fichiers sont aussi lus par
  `SwaggerData` et servent de fallback/compléments aux swagger embarqués.

### Adding a new shared file

1. Put it under `commons/` (or anywhere at the repo root).
2. In each consuming app, commit a symlink at the path the code reads.
3. Add a `source:destination` line in that app's `.expand` file.
