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

      describe 'with valid mandatory params', valid: true do
        response 200, 'Attestation found', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
          description SwaggerData.get('probtp.attestation_cotisation_retraite.description')

          schema build_rswag_document_response(
            document_url_properties: SwaggerData.get('probtp.attestation_cotisation_retraite.document_url_properties')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Attestation non trouvée', vcr: { cassette_name: 'probtp/attestation/with_not_found_siret' } do
          let(:siret) { not_found_siret(:probtp) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
