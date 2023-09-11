require 'swagger_helper'

RSpec.describe 'INPI: Latest Brevets', api: :entreprise, type: %i[request swagger] do
  path '/v3/inpi/unites_legales/{siren}/brevets' do
    get SwaggerData.get('inpi.brevets.title') do
      tags(*SwaggerData.get('inpi.brevets.tags'))

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

      too_many_requests(INPI::Brevets) do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Brevets trouvés', vcr: { cassette_name: 'inpi/brevets/with_valid_siren' } do
          description SwaggerData.get('inpi.brevets.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('inpi.brevets.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:inpi) }

          unprocessable_entity_error_request(:siren)

          response '404', 'Brevets non trouvés', vcr: { cassette_name: 'inpi/brevets/with_siren_not_found' } do
            let(:siren) { not_found_siren(:inpi) }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INPI', INPI::Brevets)
          common_network_error_request('INPI', INPI::Brevets)
        end
      end
    end
  end
end
