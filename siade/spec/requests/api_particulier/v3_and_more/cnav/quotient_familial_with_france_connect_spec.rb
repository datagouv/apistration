require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Quotient Familial with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/quotient_familial/france_connect' do
    get SwaggerData.get('cnav.quotient-familial-v2.title') do
      tags(*SwaggerData.get('cnav.quotient-familial-v2.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse] }

      describe 'with a FranceConnect token' do
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

        describe 'when the quotient familial is not found' do
          response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
            # rubocop:disable RSpec/ContextWording
            context 'Allocataire non identifié' do
              before do
                stub_cnav_404('quotient_familial_v2', nil)
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "L'allocataire que vous cherchez n'a pas été reconnu.", title: 'Allocataire non identifié', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé MSA' do
              before do
                stub_cnav_404('quotient_familial_v2', '00171001')
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la MSA.", title: 'Dossier allocataire absent MSA', with_identifiant_message: false, subcode: '004'))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé CNAF' do
              before do
                stub_cnav_404('quotient_familial_v2', '00810011')
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", title: 'Dossier allocataire absent CNAF', with_identifiant_message: false, subcode: '005'))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
            # rubocop:enable RSpec/ContextWording
          end
        end
      end
    end
  end
end
