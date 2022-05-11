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

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'infogreffe/extraits_rcs/with_valid_siren' } do
          description SwaggerData.get('infogreffe.extraits_rcs.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('infogreffe.extraits_rcs.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:extrait_rcs) }

          unprocessable_entity_error_request(:siren)

          response '404', 'Non trouvée', vcr: { cassette_name: 'infogreffe/extraits_rcs/with_siren_not_found' } do
            let(:siren) { not_found_siren(:extrait_rcs) }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('Infogreffe', Infogreffe::ExtraitsRCS)
          common_network_error_request('Infogreffe', Infogreffe::ExtraitsRCS)
        end
      end
    end
  end
end
