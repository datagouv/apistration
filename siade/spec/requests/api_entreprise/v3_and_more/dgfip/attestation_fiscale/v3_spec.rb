require 'swagger_helper'

RSpec.describe 'DGFIP: Attestation fiscale', api: :entreprise, type: %i[request swagger] do
  path '/v3/dgfip/unites_legales/{siren}/attestation_fiscale' do
    get SwaggerData.get('dgfip.attestations_fiscales.v3.title') do
      deprecated true

      tags(*SwaggerData.get('dgfip.attestations_fiscales.v3.tags'))

      parameter_siren

      cacheable_request

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren }
      end

      forbidden_request do
        let(:siren) { valid_siren }
      end

      too_many_requests(DGFIP::AttestationFiscale) do
        let(:siren) { valid_siren }
      end

      describe 'with valid token and mandatory params', :valid do
        let(:siren) { valid_siren }

        response '200', 'Attestation fiscale trouvée' do
          before do
            mock_dgfip_authenticate
            mock_valid_dgfip_attestation_fiscale(siren, valid_dgfip_user_id)
          end

          cacheable_response(extra_description: SwaggerData.get('dgfip.attestations_fiscales.v4.cache_duration'))

          description SwaggerData.get('dgfip.attestations_fiscales.v3.description')

          rate_limit_headers

          schema build_rswag_document_response(
            document_url_properties: SwaggerData.get('dgfip.attestations_fiscales.v3.document_url_properties')
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

            build_rswag_example(NotFoundError.new('DGFIP - Adélie'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          unprocessable_content_error_request(:siren)

          common_provider_errors_request(
            'DGFIP - Adélie',
            DGFIP::AttestationFiscale,
            documents_errors('DGFIP - Adélie')
          )

          common_network_error_request('DGFIP - Adélie', DGFIP::AttestationFiscale)
        end
      end
    end
  end
end
