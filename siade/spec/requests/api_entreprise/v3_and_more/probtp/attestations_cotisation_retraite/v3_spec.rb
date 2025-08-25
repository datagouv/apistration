require 'swagger_helper'

RSpec.describe 'PROBTP : Attestations cotisations retraite', api: :entreprise, type: %i[request swagger] do
  path '/v3/probtp/etablissements/{siret}/attestation_cotisations_retraite' do
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

      too_many_requests(PROBTP::AttestationsCotisationsRetraite) do
        let(:siret) { eligible_siret(:probtp) }
      end

      describe 'with valid token and mandatory params', :valid do
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

          unprocessable_content_error_request(:siret)

          common_provider_errors_request(
            'ProBTP',
            PROBTP::AttestationsCotisationsRetraite,
            documents_errors('ProBTP')
          )

          response '404', 'Attestation non trouvée', vcr: { cassette_name: 'probtp/attestation/with_not_found_siret' } do
            let(:siret) { not_found_siret(:probtp) }

            build_rswag_example(NotFoundError.new('ProBTP'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('ProBTP', PROBTP::AttestationsCotisationsRetraite)
        end
      end
    end
  end
end
