# Admin API Entreprise Development Guide

## Build/Test/Lint Commands

### Testing
- Run all tests: `bundle exec rspec`
- Run single test file: `bundle exec rspec spec/path/to/file_spec.rb`
- Run specific test line: `bundle exec rspec spec/path/to/file_spec.rb:LINE_NUMBER`
- Run feature tests: `bundle exec rspec spec/features/`
- Run with guard (auto-test): `guard`

### Linting
- Run Rubocop: `bundle exec rubocop`
- Run Brakeman security scan: `./bin/brakeman`

### Development
- Start server: `./bin/local.sh`
- Run with Docker: `make start`

## Workflow

After each iteration:
1. Run `bundle exec rubocop` and fix any offenses
2. Run relevant tests with `bundle exec rspec spec/path/to/file_spec.rb`
3. Si l'itération est visible côté utilisateur (nouvel endpoint, nouvelle
   version de fiche, dépréciation, changement de paramètre ou de format
   de réponse, évolution du catalogue ou de la FAQ, etc.), ajouter une
   entrée dans `config/changelogs.yml` avec :
   - `date` (ISO `YYYY-MM-DD`)
   - `scope` : `api_entreprise`, `api_particulier` ou `both`
   - `title` court et factuel
   - `description` en markdown, **en liant les fiches mentionnées** via
     les Rails URL helpers (interpolés en ERB par `MarkdownInterpolator`),
     ex.
     `[étudiant boursier CNOUS](<%= endpoint_path(uid: 'cnous/statut_etudiant_boursier') %>)`,
     `[catalogue](<%= endpoints_path %>)`,
     `[FAQ](<%= faq_index_path %>)`. Pas de chemin en dur — si un helper
     change, tout suit.

   Pas d'entrée pour les commits internes (refacto, tests, bumps de
   dépendances, fix de pings fournisseur, etc.) — uniquement ce qui
   change l'expérience d'un consommateur d'API.

## Code Style Guidelines

- **Ruby Style**: Follow RuboCop configuration in `.rubocop.yml`
- **String Literals**: Single quotes for regular strings, double quotes for interpolation
- **Method Length**: Keep under 15 lines when possible
- **Naming**: Use snake_case for methods and variables, CamelCase for classes
- **Testing**: RSpec, feature tests with Capybara. Do NOT test ActiveRecord associations — only test custom behavior. Ensure factories are valid instead.
- **Error Handling**: Use explicit error classes and meaningful error messages
- **Database**: Follow Rails conventions, use strong_migrations for safe changes
- **Indent Style**: 2 spaces, consistent indentation for multiline
- **Comments**: DO NOT use comments
- **File Endings**: Every file should end with a newline

## Access URLs
- API Entreprise: http://entreprise.api.localtest.me:5000/
- API Particulier: http://particulier.api.localtest.me:5000/

## Local Login (dev only)
Bypass ProConnect via: `/compte/dev-login?email=user@yopmail.com`

Available test emails: `user@yopmail.com`, `contact_technique@yopmail.com`, `editeur@yopmail.com`, `user10@yopmail.com`

## Sentry / Production Errors

Pour accéder aux erreurs de production ou si l'utilisateur mentionne Sentry, utiliser les scripts à la racine du repo : `../bin/sentry/` (voir `../bin/sentry/README.md`). Toujours passer `-P siade-site` (ou `SENTRY_PROJECT=siade-site`) — le défaut est `siade-backend`.
