require 'swagger_helper'

RSpec.describe 'DGDDI: EORI', type: %i[request swagger] do
  path '/v3/dgddi/eoris/{siret_or_eori}' do
    get SwaggerData.get('dgddi.eori.title') do
      tags(*SwaggerData.get('dgddi.eori.tags'))

      parameter_siret_or_eori

      common_action_attributes

      unauthorized_request do
        let(:siret_or_eori) { valid_eori }
      end

      forbidden_request do
        let(:siret_or_eori) { valid_eori }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entité trouvée', vcr: { cassette_name: 'dgddi/eori/valid_eori' } do
          description SwaggerData.get('dgddi.eori.description')

          schema build_rswag_response(
            id: valid_eori,
            type: 'entreprise',
            attributes: SwaggerData.get('dgddi.eori.attributes')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'dgddi/eori/non_existing_eori' } do
          let(:siret_or_eori) { non_existing_eori }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
