require 'swagger_helper'

RSpec.describe 'INSEE: Successions', api: :entreprise, type: %i[request swagger] do
  path '/v3/insee/sirene/etablissements/{siret}/successions' do
    get SwaggerData.get('insee.successions.title') do
      let(:siret) { sirets_insee_v3[:successions] }

      tags(*SwaggerData.get('insee.successions.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { sirets_insee_v3[:successions] }
      end

      forbidden_request do
        let(:siret) { sirets_insee_v3[:successions] }
      end

      too_many_requests(INSEE::Successions) do
        let(:siret) { sirets_insee_v3[:successions] }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Successions trouvées' do
          before do
            stub_insee_authenticate
            stub_insee_successions_make_request(siret:)
          end

          description SwaggerData.get('insee.successions.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.successions.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          response '404', 'Non trouvée' do
            let(:siret) { sirets_insee_v3[:successions] }

            before do
              stub_insee_authenticate
              stub_insee_successions_not_found(siret:)
            end

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          unprocessable_content_error_request(:siret) do
            let(:siret) { 'lol' }
          end

          common_provider_errors_request('INSEE', INSEE::Successions)

          common_network_error_request('INSEE', INSEE::Successions)
        end
      end
    end
  end
end
