require 'swagger_helper'

RSpec.describe 'DGFIP: Numéro de TVA intracommunautaire', api: :entreprise, type: %i[request swagger] do
  path '/v3/dgfip/numero_tva/{siren}' do
    get SwaggerData.get('dgfip.numero_tva.title') do
      tags(*SwaggerData.get('dgfip.numero_tva.tags'))

      cacheable_request

      common_action_attributes

      parameter_siren

      unauthorized_request do
        let(:siren) { valid_siren(:dgfip) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:dgfip) }
      end

      too_many_requests(DGFIP::TVA) do
        let(:siren) { valid_siren(:dgfip) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Numéro de TVA trouvé' do
          before do
            mock_valid_dgfip_numero_tva(siren)
          end

          let(:siren) { valid_siren(:dgfip) }

          description SwaggerData.get('dgfip.numero_tva.description')

          cacheable_response

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('dgfip.numero_tva.attributes'),
            meta: SwaggerData.get('dgfip.numero_tva.meta')
          )

          run_test!
        end

        describe 'server errors' do
          unprocessable_content_error_request(:siren)

          common_provider_errors_request('DGFIP - TVA', DGFIP::TVA)
          common_network_error_request('DGFIP - TVA', DGFIP::TVA)
        end
      end
    end
  end
end
