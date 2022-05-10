require 'swagger_helper'

RSpec.describe 'ACOSS: Attestations sociales', type: %i[request swagger] do
  path '/v3/acoss/attestations_sociales/{siren}' do
    get SwaggerData.get('acoss.attestation_sociale.title') do
      tags(*SwaggerData.get('acoss.attestation_sociale.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren(:acoss) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:acoss) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'acoss/with_valid_siren', match_requests_on: strict_match_vcr_requests_on_attributes.excluding(:body) } do
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
            documents_errors('ACOSS').concat([ACOSSError.new(:ongoing_manual_verification)])
          )

          not_found_error_request('ACOSS', ACOSS::AttestationsSociales)
          common_network_error_request('ACOSS', ACOSS::AttestationsSociales)
        end
      end
    end
  end
end
