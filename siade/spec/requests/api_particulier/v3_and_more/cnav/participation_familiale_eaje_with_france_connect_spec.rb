require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Participation familial EAJE with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/participation_familiale_eaje/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.eaje.title')}" do
      tags(*SwaggerData.get('cnav.eaje.tags'))

      common_action_attributes

      cacheable_request

      let(:scopes) { %i[cnav_participation_familiale_eaje_allocataires cnav_participation_familiale_eaje_enfants cnav_participation_familiale_eaje_adresse cnav_participation_familiale_eaje_parametres_calcul] }

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('participation_familiale_eaje')
        end

        context 'when found' do
          before { stub_cnav_valid_with_franceconnect_data('participation_familiale_eaje', siret: recipient) }

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.eaje.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.eaje.attributes')
            )

            run_test!
          end
        end

        context 'when not found' do
          before { stub_cnav_404('participation_familiale_eaje') }

          response '404', 'Dossier non trouvé' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant.', with_identifiant_message: false))

            run_test!
          end
        end
      end
    end
  end
end
