require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Prime Activite with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/prime_activite/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.prime_activite.title')}" do
      tags(*SwaggerData.get('cnav.prime_activite.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[prime_activite prime_activite_majoration] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('prime_activite')
        end

        context 'when the prime activite is found' do
          before do
            stub_cnav_valid_with_franceconnect_data('prime_activite', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.prime_activite.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.prime_activite.attributes')
            )

            run_test!
          end
        end

        context 'when the prime activite is not found' do
          before do
            stub_cnav_404('prime_activite')
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
