---
name: release-new-version
description: Release a new version of an official API Entreprise / API Particulier SDK to its package registry (rubygems for Ruby). Covers version bump, CHANGELOG update, release PR, tag conventions, and the OIDC-published workflow. Use when the user mentions "release", "publier", "publish sdk", "bump version sdk", "nouvelle version sdk", "rubygems", or asks to ship a new version of `api_entreprise` / `api_particulier` (Ruby today, more languages to come).
---

# Release a new SDK version

Source of truth for Ruby : [`clients/ruby/README.md`](../../../ruby/README.md)
§"Publier une version sur rubygems.org". Read it before deviating.

## Scope

One gem at a time. `api_entreprise` and `api_particulier` versionnent
indépendamment — ne jamais coupler les deux dans une même release.

## Workflow (Ruby)

1. **Branche release dédiée**
   ```sh
   git checkout -b release/api-<entreprise|particulier>-<X.Y.Z>
   ```

2. **Bump** `clients/ruby/<gem>/lib/<gem>/version.rb`. SemVer :
   - patch : régénération scaffolding, changement OpenAPI rétro-compatible
     (paramètre devient optionnel, nouveau champ de réponse).
   - minor : nouvel endpoint, nouvelle méthode publique.
   - major : breaking change (paramètre requis ajouté, méthode supprimée,
     renommage).

3. **CHANGELOG** `clients/ruby/<gem>/CHANGELOG.md` — format Keep a Changelog :
   - Convertir `[Unreleased]` en `[X.Y.Z] - YYYY-MM-DD` quand la section
     contient le contenu releasé, sinon ajouter une nouvelle section
     `[X.Y.Z]` au-dessus de `[Unreleased]` (qui reste vide).
   - Sections : `Added` / `Changed` / `Deprecated` / `Removed` / `Fixed` /
     `Security`. Référencer le SHA upstream qui motive la release.

4. **Tests locaux**
   ```sh
   cd clients/ruby/<gem> && bundle exec rspec
   ```
   Le `Gemfile.lock` est modifié par le bundle (`<gem> (X.Y.Z)`) — l'inclure
   dans le commit.

5. **Commit unique**
   ```sh
   git commit -m "Release <gem> X.Y.Z"
   ```
   Message détaillé sur le pourquoi (changement upstream, breaking, etc.).

6. **PR vers `develop`** — review obligatoire, squash-merge.

7. **Tag le commit de merge sur `develop`** (pas la branche release jetable —
   sinon le tag pointe sur un commit orphelin) :
   ```sh
   git checkout develop && git pull
   git tag ruby-api-<entreprise|particulier>-v<X.Y.Z>
   git push origin ruby-api-<entreprise|particulier>-v<X.Y.Z>
   ```

8. **Workflow** `.github/workflows/clients-ruby.yml` se déclenche sur le tag :
   - vérifie `tag_version == gemspec.version` ;
   - relance rspec ;
   - publie via `rubygems/release-gem@v1` (OIDC trusted publisher, environment
     `rubygems`).

   Surveiller la run, vérifier la version sur rubygems.org après succès.

## Tags reconnus

| Tag | Gem publié |
|---|---|
| `ruby-api-entreprise-v<X.Y.Z>` | `api_entreprise` |
| `ruby-api-particulier-v<X.Y.Z>` | `api_particulier` |

Tag invalide → step "Resolve gem from tag" échoue et stoppe le workflow.

## Gotchas

- Tag mal placé (sur la branche release jetable non mergée) : le commit n'est
  atteignable depuis aucune branche permanente. Toujours tagger après merge,
  sur `develop`.
- Version dans `version.rb` ≠ tag : le job release échoue à
  "Verify tag version matches gemspec version".
- Ne jamais committer `Gemfile.lock` sans avoir bumpé `version.rb` avant —
  divergence silencieuse.
- Le `CHANGELOG.md` initial des gems publiait le contenu sous `[Unreleased]`
  alors que `0.1.0` était déjà sur rubygems. Au premier patch, convertir
  `[Unreleased]` → `[0.1.0]` puis ajouter `[0.1.1]` au-dessus.
- **Branch policy de l'environment `rubygems` doit être de type `tag`, pas
  `branch`.** Si la policy `ruby-api-<gem>-v*` est typée `branch` (cas
  rencontré sur `api_particulier` à la 0.1.1), GitHub rejette le déploiement
  instantanément : zéro step exécuté, log introuvable (`log not found`),
  steps array vide via API. Vérifier :
  ```sh
  gh api repos/datagouv/apistration/environments/rubygems/deployment-branch-policies
  ```
  Si une entrée est mal typée :
  ```sh
  gh api -X DELETE repos/datagouv/apistration/environments/rubygems/deployment-branch-policies/<id>
  gh api -X POST   repos/datagouv/apistration/environments/rubygems/deployment-branch-policies \
    -f 'name=ruby-api-<gem>-v*' -f 'type=tag'
  ```
  Puis `gh run rerun <run-id>`.
- Le run reste en `waiting` tant que (1) le `wait_timer` (15 min) n'est pas
  écoulé et (2) un reviewer de la liste `rubygems` n'a pas approuvé. Voir
  `gh api repos/datagouv/apistration/actions/runs/<id>/pending_deployments`.

## Étendre ce skill

Quand un nouveau langage rejoint `clients/` (Node, Python, PHP, Java) :
ajouter une section `## Workflow (<langage>)` ici avec :
- chemin du fichier de version (`package.json`, `pyproject.toml`, etc.) ;
- format du tag attendu par le workflow CI correspondant ;
- registry cible (npm, PyPI, Packagist, Maven Central) ;
- éventuelles spécificités auth (OIDC, token secret, etc.).

Mettre à jour le `description` frontmatter pour citer le nouveau langage et
ses triggers.
