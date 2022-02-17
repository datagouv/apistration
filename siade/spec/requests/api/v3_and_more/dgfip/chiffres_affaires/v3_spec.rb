require 'swagger_helper'

RSpec.describe 'DGFIP: chiffres d\'affaires', type: %i[request swagger] do
  path '/v3/dgfip/chiffres_affaires/{siret}' do
    get SwaggerData.get('dgfip.chiffres_affaires.title') do
      tags(*SwaggerData.get('dgfip.chiffres_affaires.tags'))

      common_action_attributes

      parameter_siret

      unauthorized_request do
        let(:siret) { valid_siret(:exercice) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:exercice) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Exercices trouvés', vcr: { cassette_name: 'dgfip/chiffres_affaires/valid' } do
          description SwaggerData.get('dgfip.chiffres_affaires.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            type: 'exercice',
            properties: SwaggerData.get('dgfip.chiffres_affaires.attributes')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'dgfip/chiffres_affaires/not_found' } do
          let(:siret) { not_found_siret }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
