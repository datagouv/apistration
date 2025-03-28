# CLAUDE.md - Commands and Style Guide

## Build & Test Commands
- Install dependencies: `bundle install`
- Run all tests: `bundle exec rspec`
- Run a single test: `bundle exec rspec path/to/spec_file.rb`
- Run with Docker: `./bin/test_using_docker.sh`
- Reload mock backend: `bundle exec ruby bin/reload_mock_backend.rb`
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
