RSpec.shared_context 'Mandatory params' do
  let(:context) { 'Dev' }
  let(:recipient) { "API Entreprise" }
  let(:object) { "Tests" }
end

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

module RSWagCommonsResponses
  def common_action_attributes
    produces 'application/json'

    parameter name: :context, in: :query, type: :string
    parameter name: :recipient, in: :query, type: :string
    parameter name: :object, in: :query, type: :string

    security [jwt_bearer_token: []]
  end

  def unauthorized_request(&block)
    include_context 'Valid mandatory params and no token'

    response '403', 'Non autorisé' do
      description "Le jeton est absent"

      block.call if block_given?

      run_test!
    end
  end

  def forbidden_request(&block)
    include_context 'Valid mandatory params and unauthorized token'

    response '403', 'Accès interdit' do
      description "Le jeton ne possède pas les droits nécessaires"

      block.call if block_given?

      run_test!
    end
  end
end

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
        version: 'v3'
      },
      paths: {},
      servers: [
        {
          url: 'https://entreprise.api.gouv.fr',
          description: 'Environnement de productoin',
        },
        {
          url: 'https://staging.entreprise.api.gouv.fr',
          description: 'Environnement de staging',
        },
      ],
      components: {
        schemas: {
          NotFound: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    title: {
                      type: :string,
                      example: 'Resource not found',
                    },
                    detail: {
                      type: :string,
                      example: 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel',
                    },
                  },
                  required: %w[
                    title
                    detail
                  ],
                },
              },
            },
            required: %w[
              errors
            ],
          },
        },
        securitySchemes: {
          jwt_bearer_token: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT',
            description: 'JWT Token',
          },
        },
      },
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
end
