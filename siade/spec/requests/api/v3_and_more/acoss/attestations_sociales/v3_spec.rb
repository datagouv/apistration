require 'swagger_helper'

RSpec.describe 'ACOSS: Attestations sociales', type: %i[request swagger] do
  path '/v3/acoss/attestations_sociales/{siren}' do
    get SwaggerInformation.get('acoss.attestation_sociale.title') do
      tags(*SwaggerInformation.get('acoss.attestation_sociale.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren(:acoss) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:acoss) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'acoss/with_valid_siren', match_requests_on: strict_match_vcr_requests_on_attributes.excluding(:body) } do
          description SwaggerInformation.get('acoss.attestation_sociale.description')

          rate_limit_headers

          schema build_rswag_document_response(
            id: valid_siren(:acoss),
            document_url_properties: SwaggerInformation.get('acoss.attestation_sociale.document_url_properties')
          )

          run_test!
        end

        response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'acoss/with_non_existent_siren', match_requests_on: strict_match_vcr_requests_on_attributes.excluding(:body) } do
          let(:siren) { not_found_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
