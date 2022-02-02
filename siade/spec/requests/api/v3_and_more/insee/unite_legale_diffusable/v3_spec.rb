require 'swagger_helper'

RSpec.describe 'INSEE: Unités légales diffusibles', type: %i[request swagger] do
  path '/v3/insee/sirene/unites_legales/diffusibles/{siren}' do
    get SwaggerData.get('insee.unite_legale_diffusable.title') do
      tags(*SwaggerData.get('insee.unite_legale_diffusable.tags'))

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
          let(:siren) { sirens_insee_v3[:active_GE] }

          description SwaggerData.get('insee.unite_legale_diffusable.description')

          schema build_rswag_response(
            id: '130025265',
            type: 'entreprise',
            attributes: SwaggerData.get('insee.unite_legale_diffusable.attributes'),
            links: SwaggerData.get('insee.unite_legale.links'),
            meta: SwaggerData.get('insee.unite_legale.meta')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'insee/siren/non_diffusable_with_token' } do
          let(:siren) { non_diffusable_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
