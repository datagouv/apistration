require 'swagger_helper'

RSpec.describe 'RNM: Entreprises artisanales', type: %i[request swagger] do
  path '/v3/rnm/entreprises/{siren}' do
    get 'Récupération des informations d\'une entreprise artisanale' do
      tags 'Informations générales'

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
          schema build_rswag_response(
            id: valid_siren(:rnm_cma),
            type: 'entreprise',
            attributes: SwaggerInformation.get('rnm.entreprise_artisanale.attributes')
          )

          run_test!
        end

        response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
          let(:siren) { not_found_siren(:rnm_cma) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
