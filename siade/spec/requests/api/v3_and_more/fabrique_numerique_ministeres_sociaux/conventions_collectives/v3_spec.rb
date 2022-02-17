require 'swagger_helper'

RSpec.describe 'FabriqueNumeriqueMinisteresSociaux: Conventionscollectives', type: %i[request swagger] do
  path '/v3/fabrique_numerique_ministeres_sociaux/conventions_collectives/{siret}' do
    get SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.title') do
      tags(*SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.tags'))

      common_action_attributes

      parameter_siret

      unauthorized_request do
        let(:siret) { valid_siret(:conventions_collectives) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:conventions_collectives) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
          description SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            type: 'convention_collective',
            properties: SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.attributes')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/not_found_siret' } do
          let(:siret) { not_found_siret(:conventions_collectives) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
