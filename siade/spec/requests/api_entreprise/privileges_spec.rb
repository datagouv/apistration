require 'swagger_helper'

RSpec.describe 'Privileges', api: :entreprise, type: %i[request swagger] do
  path '/privileges' do
    get 'Privileges associés au jeton' do
      description 'Renvoi la liste des droits associé au jeton'

      security [{ jwt_bearer_token: [] }]

      response '200', 'Liste des droits' do
        # rubocop:disable RSpec/VariableName
        let(:Authorization) { "Bearer #{yes_jwt}" }
        # rubocop:enable RSpec/VariableName

        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                privileges: {
                  type: :array
                }
              }
            }
          }

        run_test!
      end

      unauthorized_request
    end
  end
end
