require 'swagger_helper'

RSpec.describe 'ADEME: Certificatsrge', type: %i[request swagger] do
  path '/v3/ademe/certificats_rge/{siret}' do
    get SwaggerData.get('ademe.certificats_rge.title') do
      tags(*SwaggerData.get('ademe.certificats_rge.tags'))

      common_action_attributes

      parameter_siret

      parameter name: :limit,
        in: :query,
        type: :number,
        description: "Limite le nombre de résultats retournés. Valeur entre 1 et 1000 (Défault 1000)",
        example: 100

      let(:limit) { nil }

      unauthorized_request do
        let(:siret) { valid_siret(:rge_ademe) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:rge_ademe) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
          description SwaggerData.get('ademe.certificats_rge.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('ademe.certificats_rge.attributes')
          )

          run_test!

          describe 'with optional limit' do
            let(:limit) { 2 }

            response '200', 'Entreprise trouvée', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret_with_limit' } do
              run_test!
            end
          end
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'ademe/certificats_rge/not_found_siret' } do
          let(:siret) { not_found_siret(:rge_ademe) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
