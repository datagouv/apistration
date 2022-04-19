require 'swagger_helper'

RSpec.describe 'INSEE: Adresse Etablissement diffusible', type: %i[request swagger] do
  path '/v3/insee/sirene/etablissements/diffusibles/{siret}/adresse' do
    get SwaggerData.get('insee.adresse_etablissement_diffusable.title') do
      tags(*SwaggerData.get('insee.adresse_etablissement_diffusable.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Etablissement trouvé', vcr: { cassette_name: 'insee/siret/active_GE_with_token' } do
          description SwaggerData.get('insee.adresse_etablissement_diffusable.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.adresse_etablissement_diffusable.attributes'),
            links: SwaggerData.get('insee.adresse_etablissement.links'),
            meta: SwaggerData.get('insee.adresse_etablissement.meta')
          )

          run_test!
        end

        response '404', 'Non trouvé', vcr: { cassette_name: 'insee/siret/non_existent_with_token' } do
          let(:siret) { non_existent_siret }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
