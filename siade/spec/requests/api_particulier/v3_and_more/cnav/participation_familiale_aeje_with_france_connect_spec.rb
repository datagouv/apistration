require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Participation familial AEJE with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/participation_familiale_aeje/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.aeje.title')}" do
      tags(*SwaggerData.get('cnav.aeje.tags'))

      common_action_attributes

      let(:scopes) { %i[aeje_allocataires aeje_enfants aeje_adresse aeje_parametres_calcul_participation_familiale] }

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      before do
        allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
        allow(Rails.env).to receive_messages(env: 'staging', staging?: true)
        allow(Siade.credentials).to receive(:[]).and_call_original
        allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_whatever_client_id).and_return('345')
        allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_whatever_client_secret).and_return('345')
        allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_enabled).and_return(true)
      end

      describe 'with a FranceConnect token' do
        response '200', 'Dossier trouvé', pending: 'Implement Endpoint' do
          description SwaggerData.get('cnav.aeje.description')

          cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

          schema build_rswag_response(
            attributes: SwaggerData.get('cnav.aeje.attributes')
          )

          run_test!
        end

        response '404', 'Dossier non trouvé', pending: 'Implement Endpoint' do
          schema '$ref' => '#/components/schemas/Error'

          build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant.', with_identifiant_message: false))

          run_test!
        end
      end
    end
  end
end
