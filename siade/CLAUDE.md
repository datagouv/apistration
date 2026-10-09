# CLAUDE.md - SIADE Project Guide

## Build/Test/Lint Commands

- Install dependencies: `./bin/install.sh`
- Seed database: `./bin/seeds.sh`
- Run all tests: `bundle exec rspec`
- Run single test: `bundle exec rspec path/to/file_spec.rb:line_number`
- Run tests with coverage: `COVERAGE=true rspec`
- Debug VCR cassettes or WebMock stubbing issues: `DEBUG_VCR=true rspec`
- Generate OpenAPI docs: `bin/generate_swagger.sh`
- Run Rubocop: `bundle exec rubocop`
- Auto-fix Rubocop issues: `bundle exec rubocop -A`
- Run Brakeman security scan: `./bin/brakeman` (fails on any warning, like CI)
- Ignore a false positive interactively: `./bin/brakeman_ignore`
- Test specific endpoints: `bundle exec ruby bin/test_endpoints.rb`
- Test ping endpoints: `bundle exec rails runner bin/test_pings.rb`

## Code Style Guidelines

- Style: Follow the Ruby style guide as configured in .rubocop.yml
- Strings: Use single quotes unless interpolation is needed
- Naming: Snake_case for methods/variables, CamelCase for classes
- Error handling: Create specific error classes in app/errors/ and use the config/errors.yml configuration
- Error codes nomenclature: declare every error an interactor can raise (`raises`, `delegates_to`) and regenerate with `bin/generate_swagger.sh`; design and guards in `../docs/nomenclature_erreurs.md`
- API responses: Follow REST/JSON:API format with data/links/meta structure
- Tests: RSpec with manually stubbed requests using WebMock. VCR is legacy - do NOT use VCR for new implementations, always use manual stubs
- Model specs: Do NOT test ActiveRecord associations (belongs_to, has_many, etc.) — that's testing the framework. Only test custom behavior (scopes, methods, validations). Ensure factories are valid instead.
- Interactors: Use organizers pattern with small, focused interactors
- Business logic: lives in organizers and their interactors, never in controllers or controller concerns. Controllers only extract and permit params, add request context (`request_id`, `token_id`), pick the organizer and handle HTTP concerns (auth, cache TTL, rendering). Any transformation, normalization or derivation of data (replacing a character, mapping an identity, deducing a code, choosing a provider version…) is a dedicated interactor in the organizer, writing into `context.params`, placed before the validators when validation depends on it, and failing with `context.errors` rather than silently. Never override a method of a params concern (`APIParticulier::CivilityParameters`…) to do it. A trivial default or alias may stay in the organizer's `before` block (e.g. `ADEME::CertificatsRGE`). API Particulier v2 controllers are legacy: do not copy them
- APIs: Use the scaffold_resource generator for new APIs
- Scopes: Define API access scopes in commons/data/authorizations.yml (repo root, shared with mocks)
- Maintenance: Configure provider maintenance in config/maintenances.yml
- File Endings: Every file should end with a newline

## Sentry / Production Errors

Pour accéder aux erreurs de production ou si l'utilisateur mentionne Sentry, utiliser les scripts à la racine du repo : `../bin/sentry/` (voir `../bin/sentry/README.md`). Projet par défaut : `siade-backend`.
