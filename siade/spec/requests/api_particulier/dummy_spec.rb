require 'swagger_helper'

RSpec.describe 'Dummy endpoint API Particulier', type: %i[request swagger], api: :particulier do
  path '/v2/dummy' do
    get 'Dummy endpoint' do
      security [jwt_bearer_token: []]

      # rubocop:disable RSpec/VariableName
      let(:Authorization) { "Bearer #{yes_jwt}" }
      # rubocop:enable RSpec/VariableName

      response '200', 'Works' do
        schema type: :object,
          properties: {
            hello: {
              type: :string,
              enum: %w[world]
            }
          }

        run_test!
      end
    end
  end
end
