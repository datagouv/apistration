require 'swagger_helper'

RSpec.describe 'INPI: Latest Brevets', type: %i[request swagger] do
  path '/v3/inpi/latest_brevets/{siren}' do
    get SwaggerInformation.get('inpi.latest_brevets.title') do
      tags(*SwaggerInformation.get('inpi.latest_brevets.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:inpi) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Brevets trouvés', vcr: { cassette_name: 'inpi/brevets/with_valid_siren' } do
          description SwaggerInformation.get('inpi.latest_brevets.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            type: 'object',
            properties: SwaggerInformation.get('inpi.latest_brevets.items.properties')
          )

          run_test!
        end

        response '404', 'Brevets non trouvés', vcr: { cassette_name: 'inpi/brevets/with_siren_not_found' } do
          let(:siren) { not_found_siren(:inpi) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
