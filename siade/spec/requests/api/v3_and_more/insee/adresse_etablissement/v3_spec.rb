require 'swagger_helper'

RSpec.describe 'INSEE: Adresse Etablissement', type: %i[request swagger] do
  path '/v3/insee/sirene/etablissements/{siret}/adresse' do
    get SwaggerInformation.get('insee.adresse_etablissement.title') do
      tags(*SwaggerInformation.get('insee.adresse_etablissement.tags'))

      common_action_attributes

      parameter name: :siret, in: :path, type: :string

      unauthorized_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Etablissement trouvé', vcr: { cassette_name: 'insee/siret/active_GE_with_token' } do
          description SwaggerInformation.get('insee.adresse_etablissement.description')

          schema build_rswag_response(
            id: sirets_insee_v3[:active_GE],
            type: 'adresse',
            attributes: SwaggerInformation.get('insee.adresse_etablissement.attributes'),
            links: SwaggerInformation.get('insee.adresse_etablissement.links'),
            meta: SwaggerInformation.get('insee.adresse_etablissement.meta')
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
