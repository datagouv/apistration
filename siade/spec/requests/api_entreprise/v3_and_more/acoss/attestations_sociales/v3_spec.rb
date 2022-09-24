require 'swagger_helper'

RSpec.describe 'URSSAF: Attestation de vigilance', type: %i[request swagger], api: :entreprise do
  path '/v3/urssaf/unites_legales/{siren}/attestation_vigilance' do
    get SwaggerData.get('acoss.attestation_sociale.title') do
      tags(*SwaggerData.get('acoss.attestation_sociale.tags'))

      parameter_siren

      cacheable_request

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren(:acoss) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:acoss) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'acoss/with_valid_siren', match_requests_on: strict_match_vcr_requests_on_attributes.excluding(:body_sanitized) } do
          cacheable_response

          description SwaggerData.get('acoss.attestation_sociale.description')

          rate_limit_headers

          schema build_rswag_document_response(
            document_url_properties: SwaggerData.get('acoss.attestation_sociale.document_url_properties')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:acoss) }

          unprocessable_entity_error_request(:siren)

          common_provider_errors_request(
            'ACOSS',
            ACOSS::AttestationsSociales,
            documents_errors('ACOSS')
            .concat([
              ACOSSError.new(:ongoing_manual_verification),
              ACOSSError.new(:manual_verification_asked),
              ACOSSError.new(:cannot_deliver_document)
            ])
          )

          response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'acoss/with_non_existent_siren', match_requests_on: strict_match_vcr_requests_on_attributes.excluding(:body_sanitized) } do
            let(:siren) { not_found_siren }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('ACOSS', ACOSS::AttestationsSociales)
        end
      end
    end
  end
end
