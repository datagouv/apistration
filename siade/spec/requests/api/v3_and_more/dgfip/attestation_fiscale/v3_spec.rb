require 'swagger_helper'

RSpec.describe 'DGFIP: Attestationfiscale', type: %i[request swagger] do
  path '/v3/dgfip/attestations_fiscales/{siren}' do
    get SwaggerData.get('dgfip.attestations_fiscales.title') do
      tags(*SwaggerData.get('dgfip.attestations_fiscales.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren }
      end

      forbidden_request do
        let(:siren) { valid_siren }
      end

      describe 'with valid token and mandatory params', valid: true do
        let(:siren) { valid_siren }

        response '200', 'Attestation fiscale trouvée' do
          before do
            mock_dgfip_authenticate
            mock_valid_dgfip_attestation_fiscale(siren, valid_dgfip_user_id)
          end

          description SwaggerData.get('dgfip.attestations_fiscales.description')

          rate_limit_headers

          schema build_rswag_document_response(
            document_url_properties: SwaggerData.get('dgfip.attestations_fiscales.document_url_properties')
          )

          run_test!
        end

        describe 'server errors' do
          response '404', 'Non trouvée' do
            let(:siren) { valid_siren }

            before do
              mock_dgfip_authenticate
              mock_invalid_dgfip_attestation_fiscale(404)
            end

            schema '$ref' => '#/components/schemas/NotFound'

            run_test!
          end

          unprocessable_entity_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          common_provider_errors_request('DGFIP', DGFIP::AttestationFiscale)
          common_network_error_request('DGFIP', DGFIP::AttestationFiscale)
        end
      end
    end
  end
end
