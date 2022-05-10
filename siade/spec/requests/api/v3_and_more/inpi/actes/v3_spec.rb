require 'swagger_helper'

RSpec.describe 'INPI: Actes', type: %i[request swagger] do
  path '/v3/inpi/actes/{siren}' do
    get SwaggerData.get('inpi.actes.title') do
      tags(*SwaggerData.get('inpi.actes.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:inpi) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Actes trouvés', vcr: { cassette_name: 'inpi/actes/with_valid_siren' } do
          description SwaggerData.get('inpi.actes.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('inpi.actes.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:inpi) }

          unprocessable_entity_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          not_found_error_request('INPI', INPI::Actes)
          common_provider_errors_request('INPI', INPI::Actes)
          common_network_error_request('INPI', INPI::Actes)
        end
      end
    end
  end
end
