require 'swagger_helper'

RSpec.describe 'Infogreffe: Extraitsrcs', type: %i[request swagger] do
  path '/v3/infogreffe/extraits_rcs/{siren}' do
    get SwaggerData.get('infogreffe.extraits_rcs.title') do
      tags(*SwaggerData.get('infogreffe.extraits_rcs.tags'))

      common_action_attributes

      parameter_siren

      unauthorized_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'infogreffe/extraits_rcs/with_valid_siren' } do
          description SwaggerData.get('infogreffe.extraits_rcs.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('infogreffe.extraits_rcs.attributes')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'infogreffe/extraits_rcs/with_siren_not_found' } do
          let(:siren) { not_found_siren(:extrait_rcs) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
