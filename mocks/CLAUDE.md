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
- **Documentation**: Maintain README files in each endpoint directory
- **Best Practice**: Create summary.csv for each endpoint directory

IMPORTANT! Every payload file in a given folder must have a unique set of parameters. Duplicate parameter sets across files in the same folder are not allowed.

IMPORTANT! FranceConnect-derived fixtures (`fake_france_connect_*.y*ml`, `france_connect_*.y*ml`) never include a `nomUsage` param: FranceConnect never supplies it (the identity built in `build_service_user_identity.rb` has no usage name), so such a fixture is never matched and silently 404s. `nomUsage` belongs only in `*_with_civility` fixtures, where the caller passes it as a query param.
