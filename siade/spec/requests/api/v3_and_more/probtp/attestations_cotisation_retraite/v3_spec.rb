require 'swagger_helper'

RSpec.describe 'PROBTP : Attestations cotisations retraite', type: %i[request swagger] do
  path '/v3/probtp/attestations_cotisations_retraite/{siret}' do
    get SwaggerData.get('probtp.attestation_cotisation_retraite.title') do
      tags(*SwaggerData.get('probtp.attestation_cotisation_retraite.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      forbidden_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response 200, 'Attestation found', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
          description SwaggerData.get('probtp.attestation_cotisation_retraite.description')

          schema build_rswag_document_response(
            document_url_properties: SwaggerData.get('probtp.attestation_cotisation_retraite.document_url_properties')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret) { eligible_siret(:probtp) }

          unprocessable_entity_error_request(:siret) do
            let(:siret) { 'lol' }
          end

          not_found_error_request('ProBTP', PROBTP::AttestationsCotisationsRetraite)
          common_provider_errors_request('ProBTP', PROBTP::AttestationsCotisationsRetraite)
          common_network_error_request('ProBTP', PROBTP::AttestationsCotisationsRetraite)
        end
      end
    end
  end
end
