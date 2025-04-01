require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: prime activite with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/prime_activite/identite' do
    get "[Identité] #{SwaggerData.get('cnav.prime_activite.title')}" do
      tags(*SwaggerData.get('cnav.prime_activite.tags'))

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
          sexeEtatCivil
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

      too_many_requests(CNAV::PrimeActivite)

      let(:scopes) { %i[prime_activite] }

      before do
        stub_cnav_authenticate('prime_activite')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('prime_activite', siret: '13002526500013')
        end

        describe 'when the pa is found' do
          response '200', 'Prime Activite active trouvée' do
            description SwaggerData.get('cnav.prime_activite.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.prime_activite.attributes')
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
                stub_sngi_404('prime_activite')
              end

              build_rswag_example(UnprocessableEntityError.new(:civility))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
          # rubocop:enable RSpec/ContextWording
        end

        describe 'when the pa is not found' do
          # rubocop:disable RSpec/ContextWording
          response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
            context 'Dossier non trouvé MSA' do
              before do
                stub_cnav_404('prime_activite', 'MSA')
              end

              build_rswag_example(NotFoundError.new('MSA', "Le dossier allocataire n'a pas été trouvé auprès de la MSA.", title: 'Dossier allocataire absent MSA', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé CNAF' do
              before do
                stub_cnav_404('prime_activite', 'CNAF')
              end

              build_rswag_example(NotFoundError.new('CNAF', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", title: 'Dossier allocataire absent CNAF', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Allocataire non référencé' do
              before do
                stub_rncps_404('prime_activite')
              end

              build_rswag_example(NotFoundError.new('CNAF & MSA', "L'allocataire n'est pas référencé auprès des caisses éligibles", title: 'Allocataire non référencé', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Erreur inattendue' do
              before do
                stub_cnav_404('prime_activite')
              end

              build_rswag_example(NotFoundError.new('CNAF & MSA', 'Une erreur inattendue est survenue lors de la collecte des données', title: 'Erreur inattendue', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
          # rubocop:enable RSpec/ContextWording
        end

        common_provider_errors_request('CNAV', CNAV::PrimeActivite)
        common_network_error_request('CNAV', CNAV::PrimeActivite)
      end
    end
  end
end
