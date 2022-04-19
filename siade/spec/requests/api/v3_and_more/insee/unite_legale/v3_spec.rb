require 'swagger_helper'

RSpec.describe 'INSEE: Unités légales', type: %i[request swagger] do
  path '/v3/insee/sirene/unites_legales/{siren}' do
    get SwaggerData.get('insee.unite_legale.title') do
      tags(*SwaggerData.get('insee.unite_legale.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Unité légale trouvée', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
          description SwaggerData.get('insee.unite_legale.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.unite_legale.attributes'),
            links: SwaggerData.get('insee.unite_legale.links'),
            meta: SwaggerData.get('insee.unite_legale.meta')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'insee/siren/non_existent_with_token' } do
          let(:siren) { non_existent_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
