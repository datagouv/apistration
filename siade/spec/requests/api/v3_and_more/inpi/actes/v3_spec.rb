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

      describe 'with valid mandatory params', valid: true do
        response '200', 'Actes trouvés', vcr: { cassette_name: 'inpi/actes/with_valid_siren' } do
          description SwaggerData.get('inpi.actes.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('inpi.actes.attributes')
          )

          run_test!
        end

        response '404', 'Actes non trouvés', vcr: { cassette_name: 'inpi/actes/with_siren_not_found' } do
          let(:siren) { not_found_siren(:inpi) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
