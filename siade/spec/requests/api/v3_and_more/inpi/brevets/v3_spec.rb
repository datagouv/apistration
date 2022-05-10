require 'swagger_helper'

RSpec.describe 'INPI: Latest Brevets', type: %i[request swagger] do
  path '/v3/inpi/brevets/{siren}' do
    get SwaggerData.get('inpi.brevets.title') do
      tags(*SwaggerData.get('inpi.brevets.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:inpi) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Brevets trouvés', vcr: { cassette_name: 'inpi/brevets/with_valid_siren' } do
          description SwaggerData.get('inpi.brevets.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('inpi.brevets.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:inpi) }

          unprocessable_entity_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          not_found_error_request('INPI', INPI::Brevets)
          common_provider_errors_request('INPI', INPI::Brevets)
          common_network_error_request('INPI', INPI::Brevets)
        end
      end
    end
  end
end
