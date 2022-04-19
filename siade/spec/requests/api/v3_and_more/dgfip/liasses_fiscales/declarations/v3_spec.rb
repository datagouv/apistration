require 'swagger_helper'

RSpec.describe 'DGFIP: Déclarations des liasses Fiscales', type: %i[request swagger] do
  path '/v3/dgfip/liasses_fiscales/declarations/{year}/{siren}' do
    get SwaggerData.get('dgfip.liasses_fiscales.declarations.title') do
      tags(*SwaggerData.get('dgfip.liasses_fiscales.declarations.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string
      parameter name: :year, in: :path, type: :integer

      let(:year) { 2017 }

      unauthorized_request do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
          description SwaggerData.get('dgfip.liasses_fiscales.declarations.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('dgfip.liasses_fiscales.declarations.attributes'),
            meta: SwaggerData.get('dgfip.liasses_fiscales.declarations.meta')
          )

          run_test!
        end

        response '502', 'Non trouvée', vcr: { cassette_name: 'dgfip/liasses_fiscales/with_non_existent_siren' } do
          let(:siren) { non_existent_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
