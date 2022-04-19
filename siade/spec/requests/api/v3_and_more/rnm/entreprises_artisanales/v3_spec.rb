require 'swagger_helper'

RSpec.describe 'RNM: Entreprises artisanales', type: %i[request swagger] do
  path '/v3/rnm/entreprises/{siren}' do
    get SwaggerData.get('rnm.entreprise_artisanale.title') do
      tags(*SwaggerData.get('rnm.entreprise_artisanale.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
          description SwaggerData.get('rnm.entreprise_artisanale.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('rnm.entreprise_artisanale.attributes')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
          let(:siren) { not_found_siren(:rnm_cma) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
