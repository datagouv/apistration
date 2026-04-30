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
- Test specific endpoints: `bundle exec ruby bin/test_endpoints.rb`
- Test ping endpoints: `bundle exec rails runner bin/test_pings.rb`

## Code Style Guidelines

- Style: Follow the Ruby style guide as configured in .rubocop.yml
- Strings: Use single quotes unless interpolation is needed
- Naming: Snake_case for methods/variables, CamelCase for classes
- Error handling: Create specific error classes in app/errors/ and use the config/errors.yml configuration
- API responses: Follow REST/JSON:API format with data/links/meta structure
- Tests: RSpec with manually stubbed requests using WebMock. VCR is legacy - do NOT use VCR for new implementations, always use manual stubs
- Model specs: Do NOT test ActiveRecord associations (belongs_to, has_many, etc.) — that's testing the framework. Only test custom behavior (scopes, methods, validations). Ensure factories are valid instead.
- Interactors: Use organizers pattern with small, focused interactors
- APIs: Use the scaffold_resource generator for new APIs
- Scopes: Define API access scopes in commons/data/authorizations.yml (repo root, shared with mocks)
- Maintenance: Configure provider maintenance in config/maintenances.yml
- File Endings: Every file should end with a newline

## Sentry / Production Errors

Pour accéder aux erreurs de production ou si l'utilisateur mentionne Sentry, lire `bin/sentry/README.md`.
