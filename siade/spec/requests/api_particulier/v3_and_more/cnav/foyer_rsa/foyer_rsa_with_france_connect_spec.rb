require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Foyer RSA with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/foyer_rsa/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.foyer_rsa.title')}" do
      tags(*SwaggerData.get('cnav.foyer_rsa.tags'))

      common_action_attributes

      cacheable_request

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request
      missing_france_connect_bearer_token_request

      let(:scopes) { %i[cnav_foyer_rsa_beneficiaires cnav_foyer_rsa_personnes_a_charge] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('foyer_rsa')
        end

        context 'when found' do
          before { stub_cnav_valid_with_franceconnect_data('foyer_rsa', siret: recipient) }

          response '200', 'Foyer trouvé' do
            description SwaggerData.get('cnav.foyer_rsa.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.foyer_rsa.attributes')
            )

            run_test!
          end
        end

        context 'when not found' do
          before { stub_cnav_404('foyer_rsa', 'CNAF') }

          response '404', 'Dossier non trouvé' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(
              NotFoundError.new('CNAF', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", title: 'Dossier allocataire absent CNAF', with_identifiant_message: false)
                .add_meta(origin: 'CNAF')
            )

            run_test!
          end
        end
      end
    end
  end
end
