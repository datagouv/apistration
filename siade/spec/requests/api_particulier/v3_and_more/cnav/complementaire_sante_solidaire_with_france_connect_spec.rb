require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Complementaire Sante Solidaire with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/complementaire_sante_solidaire/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.c2s.title')}" do
      tags(*SwaggerData.get('cnav.c2s.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[complementaire_sante_solidaire] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('complementaire_sante_solidaire')
        end

        context 'when the complementaire sante solidaire is found' do
          before do
            stub_cnav_valid_with_franceconnect_data('complementaire_sante_solidaire', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.c2s.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.c2s.attributes')
            )

            run_test!
          end
        end

        describe 'when the user is not found' do
          response '422', "Impossible d'identifier l'allocataire" do
            let(:codeCogInseePaysNaissance) { '99623' }
            # rubocop:disable RSpec/ContextWording
            context 'Allocataire non identifié' do
              before do
                stub_sngi_404('complementaire_sante_solidaire')
              end

              build_rswag_example(UnprocessableEntityError.new(:civility))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
          # rubocop:enable RSpec/ContextWording
        end

        describe 'when the css is not found' do
          # rubocop:disable RSpec/ContextWording
          response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
            context 'Dossier non trouvé RNCPS' do
              before do
                stub_cnav_404('complementaire_sante_solidaire', 'RNCPS')
              end

              build_rswag_example(NotFoundError.new('RNCPS', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", title: 'Dossier allocataire absent RNCPS', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Allocataire non référencé' do
              before do
                stub_rncps_404('complementaire_sante_solidaire')
              end

              build_rswag_example(NotFoundError.new('CNAF & MSA', "L'allocataire n'est pas référencé auprès de la CNAF ni de la MSA", title: 'Allocataire non référencé', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Erreur inatendue' do
              before do
                stub_cnav_404('complementaire_sante_solidaire')
              end

              build_rswag_example(NotFoundError.new('CNAF & MSA', 'Une erreur inatendue est survenue lors de la collecte des données', title: 'Erreur inatendue', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
          # rubocop:enable RSpec/ContextWording
        end
      end
    end
  end
end
