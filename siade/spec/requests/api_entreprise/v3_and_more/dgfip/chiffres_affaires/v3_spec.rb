require 'swagger_helper'

RSpec.describe 'DGFIP: chiffres d\'affaires', api: :entreprise, type: %i[request swagger] do
  path '/v3/dgfip/etablissements/{siret}/chiffres_affaires' do
    get SwaggerData.get('dgfip.chiffres_affaires.title') do
      tags(*SwaggerData.get('dgfip.chiffres_affaires.tags'))

      cacheable_request

      common_action_attributes

      parameter_siret

      unauthorized_request do
        let(:siret) { valid_siret(:exercice) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:exercice) }
      end

      too_many_requests(DGFIP::ChiffresAffaires) do
        let(:siret) { valid_siret(:exercice) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Exercices trouvés' do
          before do
            mock_valid_dgfip_chiffres_affaires(siret)
          end

          description SwaggerData.get('dgfip.chiffres_affaires.description')

          cacheable_response(extra_description: SwaggerData.get('response.headers.cache_duration_1_hour'))

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('dgfip.chiffres_affaires.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          response '404', 'Non trouvée' do
            before do
              mock_invalid_dgfip_chiffres_affaires(404)
            end

            let(:siret) { not_found_siret }

            build_rswag_example(NotFoundError.new('DGFIP - Adélie'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          unprocessable_content_error_request(:siret)

          common_provider_errors_request('DGFIP - Adélie', DGFIP::ChiffresAffaires)
          common_network_error_request('DGFIP - Adélie', DGFIP::ChiffresAffaires)
        end
      end
    end
  end
end
