require 'swagger_helper'

RSpec.describe 'INPI: Modeles', type: %i[request swagger] do
  path '/v3/inpi/modeles/{siren}' do
    get SwaggerData.get('inpi.modeles.title') do
      tags(*SwaggerData.get('inpi.modeles.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:inpi) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Modèles trouvés', vcr: { cassette_name: 'inpi/modeles/with_valid_siren' } do
          description SwaggerData.get('inpi.modeles.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('inpi.modeles.attributes'),
            links: SwaggerData.get('inpi.modeles.links')
          )

          run_test!
        end

        response '404', 'Modèles non trouvés', vcr: { cassette_name: 'inpi/modeles/not_found_siren' } do
          let(:siren) { not_found_siren(:inpi) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
