require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Revenu de solidarité active with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/revenu_solidarite_active/identite' do
    get "[Identité] #{SwaggerData.get('cnav.rsa.title')}" do
      tags(*SwaggerData.get('cnav.rsa.tags'))

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

      too_many_requests(CNAV::RevenuSolidariteActive)

      let(:scopes) { %i[revenu_solidarite_active] }

      before do
        stub_cnav_authenticate('revenu_solidarite_active')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('revenu_solidarite_active', siret: '13002526500013')
        end

        describe 'when the rsa is found' do
          response '200', 'Revenu solidarité active trouvée' do
            description SwaggerData.get('cnav.rsa.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.rsa.attributes')
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
                stub_sngi_404('revenu_solidarite_active')
              end

              build_rswag_example(UnprocessableEntityError.new(:civility))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
          # rubocop:enable RSpec/ContextWording
        end

        describe 'when the rsa is not found' do
          # rubocop:disable RSpec/ContextWording
          response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
            build_dossier_allocataire_absent_rswag_example

            context 'Dossier non trouvé MSA' do
              before do
                stub_cnav_404('revenu_solidarite_active', 'MSA')
              end

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé CNAF' do
              before do
                stub_cnav_404('revenu_solidarite_active', 'CNAF')
              end

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Allocataire non référencé' do
              before do
                stub_rncps_404('revenu_solidarite_active')
              end

              build_rswag_example(NotFoundError.new('CNAF & MSA', "L'allocataire n'est pas référencé auprès des caisses éligibles", title: 'Allocataire non référencé', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
          # rubocop:enable RSpec/ContextWording
        end

        response '502', 'Erreur du fournisseur', document: false do
          # rubocop:disable RSpec/ContextWording
          context 'Erreur inattendue' do
            before do
              stub_cnav_404('revenu_solidarite_active')
            end

            build_rswag_example(ProviderUnknownError.new('CNAV', 'Une erreur inattendue est survenue lors de la collecte des données'), :unexpected_error)

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
          # rubocop:enable RSpec/ContextWording
        end

        common_provider_errors_request('CNAV', CNAV::RevenuSolidariteActive)
        common_network_error_request('CNAV', CNAV::RevenuSolidariteActive)
      end
    end
  end
end
