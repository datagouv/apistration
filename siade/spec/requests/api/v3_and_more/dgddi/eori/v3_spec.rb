require 'swagger_helper'

RSpec.describe 'DGDDI: EORI', type: %i[request swagger] do
  path '/v3/dgddi/eoris/{siret_or_eori}' do
    get SwaggerData.get('dgddi.eori.title') do
      tags(*SwaggerData.get('dgddi.eori.tags'))

      parameter_siret_or_eori

      common_action_attributes

      unauthorized_request do
        let(:siret_or_eori) { valid_eori }
      end

      forbidden_request do
        let(:siret_or_eori) { valid_eori }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Entité trouvée', vcr: { cassette_name: 'dgddi/eori/valid_eori' } do
          description SwaggerData.get('dgddi.eori.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('dgddi.eori.attributes')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret_or_eori) { valid_eori }

          unprocessable_entity_error_request(:siret_or_eori)

          not_found_error_request('DGDDI', DGDDI::EORI)
          common_provider_errors_request('DGDDI', DGDDI::EORI)
          common_network_error_request('DGDDI', DGDDI::EORI)
        end
      end
    end
  end
end
