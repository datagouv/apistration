require 'swagger_helper'

RSpec.describe 'INSEE: Entreprises', type: %i[request swagger] do
  path '/v3/insee/entreprises/{siren}' do
    get 'Récupération des informations d\'une entreprise' do
      tags 'Informations générales'

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'api_insee_fr/siren/active_GE_with_token' } do
          let(:siren) { sirens_insee_v3[:active_GE] }

          schema build_rswag_response(
            id: '130025265',
            type: 'entreprise',
            attributes: SwaggerInformation.get('insee.entreprise.attributes'),
            links: SwaggerInformation.get('insee.entreprise.links'),
            meta: SwaggerInformation.get('insee.entreprise.meta')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'api_insee_fr/siren/non_existent_with_token' } do
          let(:siren) { non_existent_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
