require 'swagger_helper'

RSpec.describe 'INSEE: Etablissement', type: %i[request swagger] do
  path '/v3/insee/etablissements/{siret}' do
    get SwaggerInformation.get('insee.etablissement.title') do
      tags(*SwaggerInformation.get('insee.etablissement.tags'))

      common_action_attributes

      parameter name: :siret, in: :path, type: :string

      unauthorized_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Etablissement trouvé', vcr: { cassette_name: 'insee/siret/active_GE_with_token' } do
          description SwaggerInformation.get('insee.etablissement.description')

          schema build_rswag_response(
            id: sirets_insee_v3[:active_GE],
            type: 'etablissement',
            attributes: SwaggerInformation.get('insee.etablissement.attributes'),
            links: SwaggerInformation.get('insee.etablissement.links'),
            meta: SwaggerInformation.get('insee.etablissement.meta')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Non trouvé', vcr: { cassette_name: 'insee/siret/non_existent_with_token' } do
          let(:siret) { non_existent_siret }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
