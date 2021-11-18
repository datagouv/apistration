require 'swagger_helper'

RSpec.describe 'DGDDI: EORI', type: %i[request swagger] do
  path '/v3/dgddi/eoris/{siret_or_eori}' do
    get SwaggerInformation.get('dgddi.eori.title') do
      tags(*SwaggerInformation.get('dgddi.eori.tags'))

      common_action_attributes

      parameter name: :siret_or_eori, in: :path, type: :string

      unauthorized_request do
        let(:siret_or_eori) { valid_eori }
      end

      forbidden_request do
        let(:siret_or_eori) { valid_eori }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entité trouvée', vcr: { cassette_name: 'dgddi/eori/valid_eori' } do
          description SwaggerInformation.get('dgddi.eori.description')

          schema build_rswag_response(
            id: valid_eori,
            type: 'entreprise',
            attributes: SwaggerInformation.get('dgddi.eori.attributes')
          )

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
