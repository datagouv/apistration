require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Revenu Solidarite Active with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/revenu_solidarite_active/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.rsa.title')}" do
      tags(*SwaggerData.get('cnav.rsa.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[revenu_solidarite_active revenu_solidarite_active_majoration] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('revenu_solidarite_active')
        end

        context 'when the rsa is found' do
          before do
            stub_cnav_valid_with_franceconnect_data('revenu_solidarite_active', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.rsa.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.rsa.attributes')
            )

            run_test!
          end
        end

        context 'when the rsa is not found' do
          before do
            stub_cnav_404('revenu_solidarite_active')
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
