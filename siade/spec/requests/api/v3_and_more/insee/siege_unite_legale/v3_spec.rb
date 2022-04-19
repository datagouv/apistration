require 'swagger_helper'

RSpec.describe 'INSEE: Siège Unité Légale', type: %i[request swagger] do
  path '/v3/insee/sirene/unites_legales/{siren}/siege' do
    get SwaggerData.get('insee.siege_unite_legale.title') do
      tags(*SwaggerData.get('insee.siege_unite_legale.tags'))

      tags 'Informations générales'

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Établissement trouvé', vcr: { cassette_name: 'insee/siege/active_GE_with_token' } do
          description SwaggerData.get('insee.siege_unite_legale.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.etablissement.attributes'),
            links: SwaggerData.get('insee.etablissement.links'),
            meta: SwaggerData.get('insee.etablissement.meta')
          )

          run_test!
        end

        response '404', 'Non trouvé', vcr: { cassette_name: 'insee/siege/non_existent_with_token' } do
          let(:siren) { non_existent_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
