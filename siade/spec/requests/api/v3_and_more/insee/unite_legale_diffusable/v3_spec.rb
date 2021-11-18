require 'swagger_helper'

RSpec.describe 'INSEE: Unités légales diffusables', type: %i[request swagger] do
  path '/v3/insee/unites_legales/diffusables/{siren}' do
    get SwaggerInformation.get('insee.unite_legale_diffusable.title') do
      tags(*SwaggerInformation.get('insee.unite_legale_diffusable.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Unité légale trouvée', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
          let(:siren) { sirens_insee_v3[:active_GE] }

          description SwaggerInformation.get('insee.unite_legale_diffusable.description')

          schema build_rswag_response(
            id: '130025265',
            type: 'entreprise',
            attributes: SwaggerInformation.get('insee.unite_legale_diffusable.attributes'),
            links: SwaggerInformation.get('insee.unite_legale.links'),
            meta: SwaggerInformation.get('insee.unite_legale.meta')
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
