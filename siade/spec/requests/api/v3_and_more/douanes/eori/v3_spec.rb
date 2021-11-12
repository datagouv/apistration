require 'swagger_helper'

RSpec.describe 'Douanes: EORI', type: %i[request swagger] do
  path '/v3/douanes/eoris/{siret_or_eori}' do
    get SwaggerInformation.get('douanes.eori.title') do
      tags(*SwaggerInformation.get('douanes.eori.tags'))

      tags 'Informations générales'

      common_action_attributes

      parameter name: :siret_or_eori, in: :path, type: :string

      unauthorized_request do
        let(:siret_or_eori) { valid_eori }
      end

      forbidden_request do
        let(:siret_or_eori) { valid_eori }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'douanes/eori/valid_eori' } do
          schema build_rswag_response(
            id: valid_eori,
            type: 'entreprise',
            attributes: SwaggerInformation.get('douanes.eori.attributes')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'douanes/eori/non_existing_eori' } do
          let(:siret_or_eori) { non_existing_eori }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end

