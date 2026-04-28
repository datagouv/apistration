# Ruby — implémentation de référence

SDKs officiels en Ruby pour API Entreprise v3 et API Particulier v3. Sert de
*reference implementation* pour les autres langages (Node, Python, PHP, Java)
qui doivent se conformer à [`../SPECS.md`](../SPECS.md).

## Structure

```
ruby/
  commons/                      # source de vérité partagée
    lib/api_gouv_commons/       # Configuration, Response, RateLimit,
      auth/                     # hiérarchie d'erreurs JSON:API,
      middleware/               # validators SIRET/SIREN, 5 middlewares
                                # Faraday, ClientBase, UserAgent
    spec/                       # 65 specs unitaires — matrice §12.1
    Gemfile                     # faraday + faraday-retry + rspec + webmock

  api_entreprise/               # gem publié (23 providers, 52 endpoints)
    api_entreprise.gemspec
    lib/api_entreprise.rb
    lib/api_entreprise/
      client.rb                 # façade : token/env/default_params + délégation
      commons.rb                # entry-point du commons vendorisé
      commons/                  # (généré) copie + namespace réécrit
      resources/                # (généré) 1 fichier par provider
    spec/                       # 40 specs : envs, matrice 200/422/429/502,
                                # validation locale, smoke 23 providers
    examples/{basic,error_handling,retry}.rb
    README.md

  api_particulier/              # gem publié (9 providers, 36 endpoints)
    … structure symétrique, 18 specs, examples …

  bin/
    sync_commons                # vendorise commons/ dans chaque gem
                                # (copie + rewrite ApiGouvCommons →
                                # ApiEntreprise::Commons / ApiParticulier::Commons)
    scaffold_resources          # (re)génère lib/*/resources/*.rb depuis
                                # commons/swagger/openapi-*.yaml
```

## Conventions clés

- **2 gems publiés, pas de dépendance croisée**. `commons/` est vendorisé à la
  build via `bin/sync_commons`, jamais un runtime-dep partagé — ça évite le
  couplage de releases.
- **Resources groupées par provider** (2ᵉ segment de l'URL `/v3/…`), pas par
  tag OpenAPI (les tags sont descriptifs business, pas provider-oriented).
- **Méthode nommée sur le dernier segment non-templaté** du path (ex :
  `/v3/urssaf/unites_legales/{siren}/attestation_vigilance` →
  `client.urssaf.attestation_vigilance(siren)`).
- **Versions des endpoints indépendantes** : le même chemin logique peut
  exister en v3, v4, v5… La méthode générée utilise par défaut la **plus
  récente** version disponible (vN le plus grand) ; `version:` kwarg pour
  pinner explicitement
  (`client.insee.unites_legales(siren, version: 3)`). Version inconnue →
  `ArgumentError`. Version deprecated → warning Ruby à l'appel.
- **Toutes les validations locales avant l'appel HTTP** : SIRET (Luhn + La
  Poste), SIREN (Luhn), `recipient` / `context` / `object` requis sur
  Entreprise, `recipient` requis sur Particulier.
- **Faraday 2** + middlewares maison (`Authentication`, `Logging` avec
  redaction query-string pour Particulier, `RateLimitParser`, `ErrorHandler`,
  `Envelope`), attachés par référence de classe (pas de `register_middleware`
  global, pour garantir l'isolation quand les deux gems sont chargés dans le
  même processus — voir SPECS §17.1), + `faraday-retry` optionnel opt-in
  (exceptions = `RateLimitError`, `ProviderError`, `ProviderUnavailableError`,
  `TransportError`).
- **RSpec + WebMock**, pas de VCR (aligné avec la consigne du repo).

## Workflows

### Lancer les tests

```sh
cd clients/ruby/commons && bundle && bundle exec rspec          # 65 / 65
cd clients/ruby/api_entreprise && bundle && bundle exec rspec   # 32 / 32
cd clients/ruby/api_particulier && bundle && bundle exec rspec  # 18 / 18
```

### Lancer les exemples

Ne nécessitent pas de réseau (sauf `basic.rb`) :

```sh
cd clients/ruby/api_entreprise
bundle exec ruby examples/error_handling.rb    # matrice d'exceptions
bundle exec ruby examples/retry.rb             # retry opt-in
```

Avec un jeton de staging :

```sh
TOKEN=$(curl -s https://raw.githubusercontent.com/datagouv/apistration/develop/mocks/tokens/default)

API_ENTREPRISE_TOKEN=$TOKEN bundle exec ruby clients/ruby/api_entreprise/examples/basic.rb
API_PARTICULIER_TOKEN=$TOKEN bundle exec ruby clients/ruby/api_particulier/examples/basic.rb
```

Pour une validation pré-release complète contre staging, dérouler
[`../TESTING.md`](../TESTING.md).

### Régénérer après un changement

```sh
# 1. Modifier clients/ruby/commons/lib/**
bin/sync_commons                                # vendorise dans les 2 gems
cd commons && bundle exec rspec                 # valide la source
cd ../api_entreprise && bundle exec rspec       # valide via le vendored
cd ../api_particulier && bundle exec rspec

# 2. Changement de spec OpenAPI dans commons/swagger/
bin/scaffold_resources --api all                # régénère les resources
```

### Vérifier qu'on n'a rien oublié

```sh
bin/sync_commons --check           # sort en erreur si vendored périmé
bin/scaffold_resources --api all --check   # idem pour les resources
```

La CI ([`.github/workflows/clients-ruby-tests.yml`](../../.github/workflows/clients-ruby-tests.yml))
exécute les 3 suites rspec sur Ruby 3.2 + 3.3 et ces deux `--check`.

## Quickstart consommateur

```ruby
# Gemfile
gem 'api_entreprise'
gem 'api_particulier'

# app code
client = ApiEntreprise::Client.new(
  token: ENV['API_ENTREPRISE_TOKEN'],
  environment: :staging,
  default_params: { recipient: '13002526500013', context: 'Aide X', object: 'Dossier 42' }
)

response = client.insee.unites_legales('418166096')
response.data              # => { "siren" => "...", ... }
response.rate_limit.remaining
```

Gestion des erreurs et stubs dans les READMEs de chaque gem :
[`api_entreprise/README.md`](./api_entreprise/README.md),
[`api_particulier/README.md`](./api_particulier/README.md).

## Publier une version sur rubygems.org

### Prérequis (one-shot)

1. Compte rubygems.org avec MFA actif (les gemspecs déclarent
   `rubygems_mfa_required = true`).
2. **Premier release manuel** pour réserver les noms (avant que le trusted
   publishing prenne le relais). Depuis un poste connecté à rubygems
   (`gem signin`) :
   ```sh
   cd clients/ruby/api_entreprise && gem build api_entreprise.gemspec && gem push api_entreprise-0.1.0.gem
   cd ../api_particulier         && gem build api_particulier.gemspec  && gem push api_particulier-0.1.0.gem
   ```
3. **Configurer le trusted publisher OIDC** sur rubygems
   (`https://rubygems.org/profile/oidc/trusted_publishers/new`) pour chaque
   gem :

   | Champ | Valeur |
   |---|---|
   | Repository owner | `datagouv` |
   | Repository name | `apistration` |
   | Workflow filename | `clients-ruby-release.yml` |
   | Environment | `rubygems` |

4. Côté GitHub : créer l'environment `rubygems` (Settings → Environments)
   avec un protection rule "required reviewers" si on veut une approbation
   manuelle avant push.

### Cycle de release

```sh
# 1. bump
$EDITOR clients/ruby/api_entreprise/lib/api_entreprise/version.rb     # 0.1.0 → 0.2.0
$EDITOR clients/ruby/api_entreprise/CHANGELOG.md                       # add entry
git add -A && git commit -m "Release api_entreprise 0.2.0"

# 2. tag (le préfixe identifie la gem ; le suffixe doit matcher la version)
git tag ruby-api-entreprise-v0.2.0
git push origin main --tags

# → .github/workflows/clients-ruby-release.yml :
#    - vérifie que le tag matche la version dans le gemspec
#    - lance rspec
#    - build + push via rubygems/release-gem (OIDC, pas de secret en clair)
#    - crée la release GitHub associée au tag
```

Tags reconnus :

- `ruby-api-entreprise-v<X.Y.Z>` → publie `api_entreprise`
- `ruby-api-particulier-v<X.Y.Z>` → publie `api_particulier`

## Ajouter / corriger une resource à la main

Les fichiers sous `lib/*/resources/*.rb` portent un header `DO NOT EDIT`. Si
une méthode générée est insatisfaisante (mauvais nom, paramètre requis mal
détecté), **ne pas patcher le fichier généré** : ajuster
`bin/scaffold_resources` puis régénérer. C'est la seule façon de garder les
autres ports (Node/Python/PHP/Java) alignés sur le même contrat.
