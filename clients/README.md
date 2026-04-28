# clients/

Familles de SDKs officiels pour [API Entreprise v3](https://entreprise.api.gouv.fr)
et [API Particulier v3](https://particulier.api.gouv.fr), construites au-dessus
des specs OpenAPI versionnées dans [`commons/swagger/`](../commons/swagger).

## Ce qui est ici

| Fichier / dossier | Rôle |
|---|---|
| [`SPECS.md`](./SPECS.md) | Contrat normatif (langage-agnostique) que tout client doit respecter : environnements, auth, enveloppe, erreurs, rate-limit, testing, packaging, checklist de conformité. |
| `ruby/` | Implémentation de référence en Ruby. |
| `node/`, `python/`, `php/`, `java/` | *(à venir)* — ports à produire en suivant `SPECS.md` et en s'inspirant de `ruby/`. |

## L'implémentation de référence : `ruby/`

```
ruby/
  commons/                 # source de vérité partagée (Configuration, Response,
                           # RateLimit, hiérarchie d'erreurs JSON:API, SIRET/SIREN
                           # validators, Faraday middlewares, ClientBase, …)
  api_entreprise/          # gem publié — 23 resources scaffoldées par provider
  api_particulier/         # gem publié —  9 resources scaffoldées par provider
  bin/sync_commons         # vendorise commons/ dans chaque gem en réécrivant le
                           # namespace (ApiGouvCommons → ApiEntreprise::Commons …)
  bin/scaffold_resources   # (re)génère les lib/*/resources/*.rb depuis les specs
                           # OpenAPI de commons/swagger/
```

Le dossier `commons/` **n'est pas publié** comme gem. Chaque gem embarque sa
propre copie vendorisée — pas de couplage au moment du release. `bin/sync_commons`
garde les copies en phase ; la CI vérifie la fraîcheur avec `--check`.

### Lancer les tests localement

```sh
cd clients/ruby/commons && bundle && bundle exec rspec          # 65 / 65
cd clients/ruby/api_entreprise && bundle && bundle exec rspec   # 32 / 32
cd clients/ruby/api_particulier && bundle && bundle exec rspec  # 18 / 18
```

### Exemples (lancés sans réseau grâce à WebMock, sauf les `basic.rb`)

```sh
cd clients/ruby/api_entreprise
bundle exec ruby examples/error_handling.rb   # matrice d'exceptions complète
bundle exec ruby examples/retry.rb            # retry opt-in sur 429 / 502 / 503

cd ../api_particulier
bundle exec ruby examples/error_handling.rb
bundle exec ruby examples/retry.rb
```

Les `examples/basic.rb` de chaque gem tapent sur le bac à sable staging et
requièrent un jeton :

```sh
TOKEN=$(curl -s https://raw.githubusercontent.com/datagouv/apistration/develop/mocks/tokens/default)
API_ENTREPRISE_TOKEN=$TOKEN bundle exec ruby clients/ruby/api_entreprise/examples/basic.rb
API_PARTICULIER_TOKEN=$TOKEN bundle exec ruby clients/ruby/api_particulier/examples/basic.rb
```

Pour un run de conformité complet contre staging avant release, suivre
[`TESTING.md`](TESTING.md) — c'est la playbook qui remplace les anciens
`bin/smoke` (trop superficiels pour catcher autre chose qu'une panne infra).

### Régénérer après un changement de spec OpenAPI

```sh
clients/ruby/bin/sync_commons
clients/ruby/bin/scaffold_resources --api all
```

## Porter SPECS.md dans une autre langue

1. Lire `SPECS.md` du début à la fin — il est normatif et langage-agnostique.
2. Calquer la structure ruby/ : un sous-dossier `commons/` pour le code
   partagé, un dossier par gem publié, des scripts de build qui vendorisent
   `commons/` dans chaque artefact.
3. Couvrir la matrice de tests unitaires §12.1 (validateurs SIRET/SIREN,
   configuration immuable, auth strategy, enveloppe, mapping d'erreurs,
   rate-limit, retry, redaction des logs PII, signatures des resources).
4. Couvrir les 4 cas bout-en-bout §12.2 (200, 422, 429 avec `retry_after`,
   502 avec `meta.retry_in`) contre un stub HTTP.
5. Publier un README avec un exemple de stub, un `CHANGELOG.md`.
6. Cocher la checklist §20 avant merge.

## CI

[`.github/workflows/clients-ruby-tests.yml`](../.github/workflows/clients-ruby-tests.yml)
lance sur chaque push :

- `rspec` pour les 3 projets Ruby sur la matrice Ruby 3.2 / 3.3
- `bin/sync_commons --check` (échoue si commons vendorisé pas en phase)
- `bin/scaffold_resources --api all --check` (échoue si resources obsolètes)
