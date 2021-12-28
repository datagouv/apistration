require 'swagger_helper'

RSpec.describe 'PROBTP: Conformites Cotisations Retraite', type: %i[request swagger] do
  path '/v3/probtp/conformites_cotisations_retraite/{siret}' do
    get SwaggerInformation.get('probtp.conformites_cotisations_retraite.title') do
      tags(*SwaggerInformation.get('probtp.conformites_cotisations_retraite.tags'))

      common_action_attributes

      parameter name: :siret, in: :path, type: :string

      unauthorized_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      forbidden_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_eligible_siret' } do
          description SwaggerInformation.get('probtp.conformites_cotisations_retraite.description')

          rate_limit_headers

          schema build_rswag_response(
            id: eligible_siret(:probtp),
            type: 'entreprise',
            attributes: SwaggerInformation.get('probtp.conformites_cotisations_retraite.attributes')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_not_found_siret' } do
          let(:siret) { not_found_siret(:probtp) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
