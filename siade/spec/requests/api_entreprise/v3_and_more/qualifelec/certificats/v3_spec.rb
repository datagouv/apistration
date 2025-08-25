require 'swagger_helper'

RSpec.describe 'Qualifelec: Certificats', api: :entreprise, type: %i[request swagger] do
  path '/v3/qualifelec/etablissements/{siret}/certificats' do
    get SwaggerData.get('qualifelec.certificats.title') do
      tags(*SwaggerData.get('qualifelec.certificats.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { valid_siret(:qualifelec) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:qualifelec) }
      end

      let(:siret) { valid_siret(:qualifelec) }

      before do
        stub_qualifelec_auth_success
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée' do
          before do
            stub_qualifelec_certificates
          end

          description SwaggerData.get('qualifelec.certificats.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('qualifelec.certificats.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret(:qualifelec) }

          unprocessable_content_error_request(:siret) do
            let(:siret) { 'lol' }
          end

          too_many_requests(Qualifelec::Certificats) do
            let(:siret) { valid_siret(:qualifelec) }
          end

          response '404', 'Non trouvée' do
            before do
              stub_qualifelec_404
            end

            let(:siret) { not_found_siret }

            build_rswag_example(NotFoundError.new('Qualifelec'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          unprocessable_content_error_request(%i[siret])
          common_provider_errors_request('Qualifelec', Qualifelec::Certificats)
          common_network_error_request('Qualifelec', Qualifelec::Certificats)
        end
      end
    end
  end
end
