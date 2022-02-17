require 'swagger_helper'

RSpec.describe 'INPI: Marques', type: %i[request swagger] do
  path '/v3/inpi/marques/{siren}' do
    get SwaggerData.get('inpi.marques.title') do
      tags(*SwaggerData.get('inpi.marques.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:inpi) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Marques trouvées', vcr: { cassette_name: 'inpi/marques/with_valid_siren' } do
          description SwaggerData.get('inpi.marques.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            type: 'marque',
            properties: SwaggerData.get('inpi.marques.attributes'),
            links: SwaggerData.get('inpi.marques.links')
          )

          run_test!
        end

        response '404', 'Marques non trouvées', vcr: { cassette_name: 'inpi/marques/not_found_siren' } do
          let(:siren) { not_found_siren(:inpi) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
