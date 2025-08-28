# CLAUDE.md - SIADE Project Guide

## Build/Test/Lint Commands

- Install dependencies: `./bin/install.sh`
- Seed database: `./bin/seeds.sh`
- Run all tests: `rspec`
- Run single test: `rspec path/to/file_spec.rb:line_number`
- Run tests with coverage: `COVERAGE=true rspec`
- Debug VCR cassettes: `DEBUG_VCR=true rspec`
- Generate OpenAPI docs: `bin/generate_swagger.sh`
- Run Rubocop: `rubocop`
- Test specific endpoints: `bundle exec ruby bin/test_endpoints.rb`
- Test ping endpoints: `bundle exec rails runner bin/test_pings.rb`

## Code Style Guidelines

- Style: Follow the Ruby style guide as configured in .rubocop.yml
- Strings: Use single quotes unless interpolation is needed
- Naming: Snake_case for methods/variables, CamelCase for classes
- Error handling: Create specific error classes in app/errors/ and use the config/errors.yml configuration
- API responses: Follow REST/JSON:API format with data/links/meta structure
- Tests: RSpec with manually stubbed requests using WebMock. VCR is legacy - do NOT use VCR for new implementations, always use manual stubs
- Interactors: Use organizers pattern with small, focused interactors
- APIs: Use the scaffold_resource generator for new APIs
- Scopes: Define API access scopes in config/authorizations.yml
- Maintenance: Configure provider maintenance in config/maintenances.yml
- File Endings: Every file should end with a newline
