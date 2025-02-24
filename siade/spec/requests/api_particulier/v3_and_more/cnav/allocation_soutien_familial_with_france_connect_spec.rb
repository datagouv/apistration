require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Allocation Soutien Familial with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/allocation_soutien_familial/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.asf.title')}" do
      tags(*SwaggerData.get('cnav.asf.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[allocation_soutien_familial] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('allocation_soutien_familial')
        end

        context 'when the Allocation Soutien Familial is found' do
          before do
            stub_cnav_valid_with_franceconnect_data('allocation_soutien_familial', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.asf.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.asf.attributes')
            )

            run_test!
          end
        end

        context 'when the Allocation Soutien Familial is not found' do
          before do
            stub_cnav_404('allocation_soutien_familial')
          end

          response '404', 'Dossier non trouvé' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.', with_identifiant_message: false))

            run_test!
          end
        end
      end
    end
  end
end
