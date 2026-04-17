require_relative 'lib/api_particulier/version'

Gem::Specification.new do |spec|
  spec.name        = 'api_particulier'
  spec.version     = ApiParticulier::VERSION
  spec.authors     = ['DINUM']
  spec.email       = ['api-particulier@api.gouv.fr']
  spec.summary     = 'Official Ruby client for API Particulier v3'
  spec.description = 'Idiomatic Ruby client for https://particulier.api.gouv.fr — auth, envelope, error normalisation, rate limit.'
  spec.homepage    = 'https://github.com/datagouv/apistration'
  spec.license     = 'AGPL-3.0-only'

  spec.required_ruby_version = '>= 3.1'

  spec.files = Dir['lib/**/*.rb', 'README.md', 'CHANGELOG.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'faraday-retry', '~> 2.0'
end
