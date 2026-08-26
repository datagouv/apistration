require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Allocation de rentrée scolaire (ARS) with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/allocation_rentree_scolaire/identite' do
    get "[Identité] #{SwaggerData.get('cnav.ars.title')}" do
      tags(*SwaggerData.get('cnav.ars.tags'))

      common_action_attributes

      cacheable_request

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          nomUsage
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseePaysNaissance
          codeCogInseeCommuneNaissance
          nomCommuneNaissance
          codeCogInseeDepartementNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          codeCogInseePaysNaissance
        ],
        api: 'cnav'
      )

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:sexeEtatCivil) { 'M' }
      let(:anneeDateNaissance) { 1980 }
      let(:moisDateNaissance) { 6 }
      let(:jourDateNaissance) { 12 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:codeCogInseeCommuneNaissance) { '17300' }
      let(:codeCogInseeDepartementNaissance) { nil }
      let(:nomCommuneNaissance) { nil }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(CNAV::AllocationRentreeScolaire)

      let(:scopes) { %i[cnav_allocation_rentree_scolaire] }

      before do
        stub_cnav_authenticate('allocation_rentree_scolaire')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('allocation_rentree_scolaire', siret: '13002526500013')
        end

        describe 'when the ars is found' do
          response '200', 'Allocation de Rentrée Scolaire active trouvée' do
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

              build_rswag_example(UnprocessableEntityError.new(:sngi, provider: 'Sécurité sociale'))

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

        response '502', 'Erreur du fournisseur', document: false do
          context 'when an unexpected error occurs' do
            before do
              stub_cnav_404('allocation_rentree_scolaire')
            end

            build_rswag_example(ProviderUnknownError.new('CNAV', 'Une erreur inattendue est survenue lors de la collecte des données'), :unexpected_error)

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::AllocationRentreeScolaire)
        common_network_error_request('CNAV', CNAV::AllocationRentreeScolaire)
      end
    end
  end
end
