require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Allocation Adulte Handicape with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/allocation_adulte_handicape/france_connect' do
    get SwaggerData.get('cnav.aah.title') do
      tags(*SwaggerData.get('cnav.aah.tags'))

      common_action_attributes

      let(:scopes) { %i[allocation_adulte_handicape] }

      describe 'with a FranceConnect token' do
        let(:recipient) { valid_siret(:recipient) }
        let(:Authorization) { 'Bearer super_valid_token' }

        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('allocation_adulte_handicape')
        end

        context 'when the Allocation Adulte Handicape is found' do
          before do
            stub_cnav_valid_with_franceconnect_data('allocation_adulte_handicape', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.aah.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.aah.attributes')
            )

            run_test!
          end
        end

        context 'when the Allocation Adulte Handicape is not found' do
          before do
            stub_cnav_404('allocation_adulte_handicape')
          end

          response '404', 'Dossier non trouvé' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.'), false)

            run_test!
          end
        end
      end
    end
  end
end
