require 'swagger_helper'

RSpec.describe 'Douanes: Immatriculations EORI', api: :entreprise, type: %i[request swagger] do
  path '/v3/douanes/etablissements/{siret_or_eori}/immatriculations_eori' do
    get SwaggerData.get('dgddi.eori.title') do
      tags(*SwaggerData.get('dgddi.eori.tags'))

      parameter_siret_or_eori

      common_action_attributes

      unauthorized_request do
        let(:siret_or_eori) { valid_eori }
      end

      forbidden_request do
        let(:siret_or_eori) { valid_eori }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entité trouvée', vcr: { cassette_name: 'dgddi/eori/valid_eori' } do
          description SwaggerData.get('dgddi.eori.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('dgddi.eori.attributes')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret_or_eori) { valid_eori }

          unprocessable_content_error_request(:siret_or_eori)

          response '404', 'Non trouvée', vcr: { cassette_name: 'dgddi/eori/non_existing_eori' } do
            let(:siret_or_eori) { non_existing_eori }

            build_rswag_example(NotFoundError.new('DGDDI'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('DGDDI', DGDDI::EORI)
          common_network_error_request('DGDDI', DGDDI::EORI)
        end
      end
    end
  end
end
