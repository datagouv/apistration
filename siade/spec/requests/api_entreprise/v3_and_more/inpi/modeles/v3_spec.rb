require 'swagger_helper'

RSpec.describe 'INPI: Modeles', type: %i[request swagger], api: :entreprise do
  path '/v3/inpi/unites_legales/{siren}/modeles' do
    get SwaggerData.get('inpi.modeles.title') do
      tags(*SwaggerData.get('inpi.modeles.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      parameter name: :limit,
        in: :query,
        type: :number,
        description: 'Limite le nombre de résultats retournés. Valeur entre 1 et 20 (Défaut 5)',
        example: 10

      let(:limit) { nil }

      unauthorized_request do
        let(:siren) { valid_siren(:inpi) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Modèles trouvés', vcr: { cassette_name: 'inpi/modeles/with_valid_siren' } do
          description SwaggerData.get('inpi.modeles.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('inpi.modeles.attributes'),
            item_links: SwaggerData.get('inpi.modeles.links')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:inpi) }

          unprocessable_entity_error_request(:siren)

          response '404', 'Modèles non trouvés', vcr: { cassette_name: 'inpi/modeles/not_found_siren' } do
            let(:siren) { not_found_siren(:inpi) }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INPI', INPI::Modeles)
          common_network_error_request('INPI', INPI::Modeles)
        end
      end
    end
  end
end
