Dir[Rails.root.join('spec/support/rswag_*.rb')].each { |f| require f }

RSpec.shared_context 'Mandatory params' do
  let(:context) { 'Dev' }
  let(:recipient) { '13002526500013' }
  let(:object) { 'Tests' }
end

# rubocop:disable RSpec/VariableName
RSpec.shared_context 'Valid params (mandatory and token)' do
  include_context 'Mandatory params'

  let(:Authorization) { "Bearer #{yes_jwt}" }
end

RSpec.shared_context 'Valid mandatory params and no token' do
  include_context 'Mandatory params'

  let(:Authorization) { nil }
end

RSpec.shared_context 'Valid mandatory params and unauthorized token' do
  include_context 'Mandatory params'

  let(:Authorization) { "Bearer #{nope_jwt}" }
end
# rubocop:enable RSpec/VariableName

# rubocop:disable Metrics/MethodLength
def build_rswag_error(title: nil, detail: nil, code: nil)
  {
    type: :object,
    properties: {
      errors: {
        type: :array,
        items: {
          type: :object,
          properties: {
            title: {
              type: :string,
              example: title
            }.compact,
            detail: {
              type: :string,
              example: detail
            }.compact,
            code: {
              type: :string,
              example: code
            }.compact
          },
          required: %w[
            title
            detail
            code
          ]
        }
      }
    },
    required: %w[
      errors
    ]
  }
end
# rubocop:enable Metrics/MethodLength

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'openapi.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Entreprise',
        version: '3.0.0',
        description: "Cette page contient la documentation technique pour accéder à API Entreprise. Les API étant accessible uniquement sous habilitation, l'interaction avec l'environnement de production n'est possible que si vous êtes **en possession d'une clé d'accès (jeton).

### Comment tester l'API ?

Il est possible de tester les API via notre environnement de **staging** (https://staging.entreprise.api.gouv.fr) qui vous retournera systématiquement des données fictives.

Il est nécessaire d'utiliser le jeton de staging indiqué ci-dessous.

---

*eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIzMGU2ODQ1OC0wMjlhLTQ2YTAtYWJiMi03ZTA4ZGVlMDAxM2UiLCJqdGkiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJyb2xlcyI6WyJjZXJ0aWZpY2F0X3JnZV9hZGVtZSIsIm1zYV9jb3Rpc2F0aW9ucyIsImVudHJlcHJpc2UiLCJleHRyYWl0X3JjcyIsImNlcnRpZmljYXRfb3BxaWJpIiwiYXNzb2NpYXRpb25zIiwiZXRhYmxpc3NlbWVudCIsImV0YWJsaXNzZW1lbnRzIiwiZm50cF9jYXJ0ZV9wcm8iLCJxdWFsaWJhdCIsImVudHJlcHJpc2VfYXJ0aXNhbmFsZSIsImNlcnRpZmljYXRfY25ldHAiLCJlb3JpX2RvdWFuZXMiLCJwcm9idHAiLCJhY3Rlc19pbnBpIiwiZXh0cmFpdF9jb3VydF9pbnBpIiwiYXR0ZXN0YXRpb25zX3NvY2lhbGVzIiwibGlhc3NlX2Zpc2NhbGUiLCJhdHRlc3RhdGlvbnNfZmlzY2FsZXMiLCJleGVyY2ljZXMiLCJjb252ZW50aW9uc19jb2xsZWN0aXZlcyIsInVwdGltZSIsImJpbGFuc19pbnBpIiwiZG9jdW1lbnRzX2Fzc29jaWF0aW9uIiwiYWlkZXNfY292aWRfZWZmZWN0aWZzIiwiY2VydGlmaWNhdF9hZ2VuY2VfYmlvIiwiZW50cmVwcmlzZXMiLCJiaWxhbnNfZW50cmVwcmlzZV9iZGYiLCJwcml2aWxlZ2VzIiwiYXR0ZXN0YXRpb25zX2FnZWZpcGgiLCJleHRyYWl0c19yY3MiLCJlbnRyZXByaXNlc19hcnRpc2FuYWxlcyJdLCJzdWIiOiJzdGFnaW5nIGRldmVsb3BtZW50IiwiaWF0IjoxNjU2NTkzNjYxLCJ2ZXJzaW9uIjoiMS4wIiwiZXhwIjoxNjU5MTg1NjYxfQ.wO55RVpIxYLKCH9EMXKoG3fkHfVQivGOExHs93xF-eE*
      ",
        termsOfService: 'https://entreprise.api.gouv.fr/cgu/',
        contact:
        {
          name: 'Support API Entreprise',
          email: 'support@entreprise.api.gouv.fr',
          url: 'https://entreprise.api.gouv.fr/'
        }
      },
      tags: [
        {
          name: 'Informations générales'
        },
        {
          name: 'Informations financières'
        },
        {
          name: 'Attestations sociales et fiscales'
        },
        {
          name: 'Certifications professionnelles'
        },
        {
          name: 'Propriété intellectuelle'
        }
      ],
      paths: {},
      servers: [
        {
          url: 'https://entreprise.api.gouv.fr',
          description: 'Environnement de production'
        },
        {
          url: 'https://staging.entreprise.api.gouv.fr',
          description: 'Environnement de staging'
        }
      ],
      components: {
        schemas: {
          Error: build_rswag_error
        },
        securitySchemes: {
          jwt_bearer_token: {
            type: :http,
            description: "Votre jeton d'authentification doit être placé dans le header 'Authorization: Bearer VOTRE_JWT', sa validité est de 18 mois.

Exemple cURL :

    curl -X GET \\
    -H \"Authorization: Bearer $token\" \\
    --url \"https://entreprise.api.gouv.fr/v3/...\"",
            name: 'Authorization',
            in: :header,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml

  config.include_context 'Valid params (mandatory and token)', valid: true
  config.include_context 'Valid mandatory params and no token', authenticate: false

  config.after(:each, type: :swagger) do
    Rack::Attack.reset!
  end

  config.extend RSWagCommonsResponses
  config.extend RSWagResourcesPayloads
end
