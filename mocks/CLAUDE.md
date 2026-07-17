# CLAUDE.md - Commands and Style Guide

## Build & Test Commands
- Install dependencies: `bundle install`
- Run all tests: `bundle exec rspec`
- Run a single test: `bundle exec rspec path/to/spec_file.rb`
- Run with Docker: `./bin/test_using_docker.sh`
- Generate payload README: `bundle exec ruby bin/generate_payload_readme.rb`
- Generate token: `bundle exec ruby bin/generate_token.rb`

## Code Style Guidelines
- **YAML Payloads**: Use standard format with `params`, `status`, and `payload` keys
- **Directory Naming**: Follow `api_[entreprise|particulier]_version_endpointname` format
- **Testing**: Use RSpec and follow the project's test organization
- **Error Handling**: Create appropriate HTTP status error files (404, 503, etc.)
- **Documentation**: Maintain README files in each endpoint directory
- **Data Structure**: Validate payloads against OpenAPI specifications
- **Best Practice**: Create summary.csv for each endpoint directory
- **File Format**: All files must end with a newline

IMPORTANT! Every payload file in a given folder must have a unique set of parameters. Duplicate parameter sets across files in the same folder are not allowed.

IMPORTANT! FranceConnect-derived fixtures (`fake_france_connect_*.y*ml`, `france_connect_*.y*ml`) must never include a `nomUsage` param. FranceConnect's "identité pivot" only ever supplies `family_name`/`given_name`/`gender`/`birthdate`/`birthplace`/`birthcountry` (see `hub_identity_scopes` in `siade/app/interactors/france_connect/validate_response.rb`) — `nom_usage` is hardcoded to `nil` for every FranceConnect-driven request (`siade/app/interactors/france_connect/data_fetcher_through_access_token/build_service_user_identity.rb`), so a `nomUsage` key in a fixture's `params` can never be matched by a real request; it silently 404s instead. `nomUsage` is only valid in `*_with_civility` fixtures, where the caller supplies it directly as a query param.
