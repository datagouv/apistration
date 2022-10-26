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

Il est possible de tester les API via notre environnement de **staging** qui vous retournera systématiquement des données fictives.

Il est nécessaire d'utiliser le jeton de staging indiqué ci-dessous.

---

*eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI2MGJjMmRhZS1jN2Q5LTRhMTUtYjhmNy0zNGI5OTA1YTE4ZjEiLCJqdGkiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJzY29wZXMiOlsiY2VydGlmaWNhdF9yZ2VfYWRlbWUiLCJtc2FfY290aXNhdGlvbnMiLCJlbnRyZXByaXNlcyIsImV4dHJhaXRzX3JjcyIsImNlcnRpZmljYXRfb3BxaWJpIiwiYXNzb2NpYXRpb25zIiwiZXRhYmxpc3NlbWVudHMiLCJmbnRwX2NhcnRlX3BybyIsInF1YWxpYmF0IiwiZW50cmVwcmlzZXNfYXJ0aXNhbmFsZXMiLCJjZXJ0aWZpY2F0X2NuZXRwIiwiZW9yaV9kb3VhbmVzIiwicHJvYnRwIiwiYWN0ZXNfaW5waSIsImV4dHJhaXRfY291cnRfaW5waSIsImF0dGVzdGF0aW9uc19zb2NpYWxlcyIsImxpYXNzZV9maXNjYWxlIiwiYXR0ZXN0YXRpb25zX2Zpc2NhbGVzIiwiZXhlcmNpY2VzIiwiY29udmVudGlvbnNfY29sbGVjdGl2ZXMiLCJiaWxhbnNfaW5waSIsImRvY3VtZW50c19hc3NvY2lhdGlvbiIsImNlcnRpZmljYXRfYWdlbmNlX2JpbyIsImJpbGFuc19lbnRyZXByaXNlX2JkZiIsImF0dGVzdGF0aW9uc19hZ2VmaXBoIiwibWVzcmlfaWRlbnRpZmlhbnQiLCJtZXNyaV9pZGVudGl0ZSIsIm1lc3JpX2luc2NyaXB0aW9uX2V0dWRpYW50IiwibWVzcmlfaW5zY3JpcHRpb25fYXV0cmUiLCJtZXNyaV9hZG1pc3Npb24iLCJtZXNyaV9ldGFibGlzc2VtZW50cyIsInBvbGVfZW1wbG9pX2lkZW50aXRlIiwicG9sZV9lbXBsb2lfYWRyZXNzZSIsInBvbGVfZW1wbG9pX2NvbnRhY3QiLCJwb2xlX2VtcGxvaV9pbnNjcmlwdGlvbiIsImNuYWZfcXVvdGllbnRfZmFtaWxpYWwiLCJjbmFmX2FsbG9jYXRhaXJlcyIsImNuYWZfZW5mYW50cyIsImNuYWZfYWRyZXNzZSIsImNub3VzX3N0YXR1dF9ib3Vyc2llciIsInVwdGltZSIsImNub3VzX2VjaGVsb25fYm91cnNlIiwiY25vdXNfZW1haWwiLCJjbm91c19wZXJpb2RlX3ZlcnNlbWVudCIsImNub3VzX3N0YXR1dF9ib3Vyc2UiLCJjbm91c192aWxsZV9ldHVkZXMiLCJjbm91c19pZGVudGl0ZSIsImRnZmlwX2RlY2xhcmFudDFfbm9tIiwiZGdmaXBfZGVjbGFyYW50MV9ub21fbmFpc3NhbmNlIiwiZGdmaXBfZGVjbGFyYW50MV9wcmVub21zIiwiZGdmaXBfZGVjbGFyYW50MV9kYXRlX25haXNzYW5jZSIsImRnZmlwX2RlY2xhcmFudDJfbm9tIiwiZGdmaXBfZGVjbGFyYW50Ml9ub21fbmFpc3NhbmNlIiwiZGdmaXBfZGVjbGFyYW50Ml9wcmVub21zIiwiZGdmaXBfZGVjbGFyYW50Ml9kYXRlX25haXNzYW5jZSIsImRnZmlwX2RhdGVfcmVjb3V2cmVtZW50IiwiZGdmaXBfZGF0ZV9ldGFibGlzc2VtZW50IiwiZGdmaXBfYWRyZXNzZV9maXNjYWxlX3RheGF0aW9uIiwiZGdmaXBfYWRyZXNzZV9maXNjYWxlX2FubmVlIiwiZGdmaXBfbm9tYnJlX3BhcnRzIiwiZGdmaXBfbm9tYnJlX3BlcnNvbm5lc19hX2NoYXJnZSIsImRnZmlwX3NpdHVhdGlvbl9mYW1pbGlhbGUiLCJkZ2ZpcF9yZXZlbnVfYnJ1dF9nbG9iYWwiLCJkZ2ZpcF9yZXZlbnVfaW1wb3NhYmxlIiwiZGdmaXBfaW1wb3RfcmV2ZW51X25ldF9hdmFudF9jb3JyZWN0aW9ucyIsImRnZmlwX21vbnRhbnRfaW1wb3QiLCJkZ2ZpcF9yZXZlbnVfZmlzY2FsX3JlZmVyZW5jZSIsImRnZmlwX2FubmVlX2ltcG90IiwiZGdmaXBfYW5uZWVfcmV2ZW51cyIsImRnZmlwX2VycmV1cl9jb3JyZWN0aWYiLCJkZ2ZpcF9zaXR1YXRpb25fcGFydGllbGxlIl0sInN1YiI6InN0YWdpbmcgZGV2ZWxvcG1lbnQiLCJpYXQiOjE2NjY3NzkwOTIsInZlcnNpb24iOiIxLjAiLCJleHAiOjE5ODIzOTgyOTJ9.Adv-EgzZq-vOAKf5YeNpg0EVyDFjkBlPxKqmgbjAMTY*
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
