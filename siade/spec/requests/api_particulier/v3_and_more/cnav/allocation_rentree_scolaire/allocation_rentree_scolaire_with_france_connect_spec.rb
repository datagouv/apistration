require 'swagger_helper'

RSpec.describe 'API Particulier: CNAV: Allocation de rentrée scolaire (ARS) with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/allocation_rentree_scolaire/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.ars.title')}" do
      tags(*SwaggerData.get('cnav.ars.tags'))

      common_action_attributes

      cacheable_request

      let(:scopes) { %i[cnav_allocation_rentree_scolaire] }

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request
      missing_france_connect_bearer_token_request

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_cnav_authenticate('allocation_rentree_scolaire')
        end

        context 'when the Allocation de Rentrée Scolaire is found' do
          before do
            stub_cnav_valid_with_franceconnect_data('allocation_rentree_scolaire', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.ars.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.ars.attributes')
            )

            run_test!
          end
        end

        describe 'when the user is not found' do
          response '422', "Impossible d'identifier l'allocataire" do
            let(:codeCogInseePaysNaissance) { '99623' }
            context 'when the allocataire is not identified' do
              before do
                stub_sngi_404('allocation_rentree_scolaire')
              end

              build_rswag_example(UnprocessableEntityError.new(:civility))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
        end

        describe 'when the ars is not found' do
          response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
            build_dossier_allocataire_absent_rswag_example

            context 'when the dossier is not found at MSA' do
              before do
                stub_cnav_404('allocation_rentree_scolaire', 'MSA')
              end

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'when the dossier is not found at CNAF' do
              before do
                stub_cnav_404('allocation_rentree_scolaire', 'CNAF')
              end

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'when the allocataire is not referenced' do
              before do
                stub_rncps_404('allocation_rentree_scolaire')
              end

              build_rswag_example(NotFoundError.new('CNAF & MSA', "L'allocataire n'est pas référencé auprès des caisses éligibles", title: 'Allocataire non référencé', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
        end

        response '502', 'Erreur du fournisseur' do
          context 'when an unexpected error occurs' do
            before do
              stub_cnav_404('allocation_rentree_scolaire')
            end

            build_rswag_example(ProviderUnknownError.new('CNAV', 'Une erreur inattendue est survenue lors de la collecte des données'), :unexpected_error)

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end
      end
    end
  end
end
