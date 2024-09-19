require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Quotient Familial with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/quotient_familial/france_connect' do
    get SwaggerData.get('cnav.quotient-familial-v2.title') do
      tags(*SwaggerData.get('cnav.quotient-familial-v2.tags'))

      common_action_attributes

      let(:scopes) { %i[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse] }

      describe 'with a FranceConnect token' do
        let(:recipient) { valid_siret(:recipient) }
        let(:Authorization) { 'Bearer super_valid_token' }

        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('quotient_familial_v2')
        end

        context 'when the quotient familial is found' do
          before do
            stub_cnav_valid_with_franceconnect_data('quotient_familial_v2', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.quotient-familial-v2.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.quotient-familial-v2.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.quotient-familial-v2.attributes')
            )

            run_test!
          end
        end

        context 'when the quotient_familial is not found' do
          before do
            stub_cnav_404('quotient_familial_v2')
          end

          response '404', 'Dossier non trouvé' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.'))

            run_test!
          end
        end
      end
    end
  end
end
