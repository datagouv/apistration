require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: complementaire sante solidaire with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/complementaire_sante_solidaire/identite' do
    get "[Identité] #{SwaggerData.get('cnav.c2s.title')}" do
      tags(*SwaggerData.get('cnav.c2s.tags'))

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

      too_many_requests(CNAV::ComplementaireSanteSolidaire)

      let(:scopes) { %i[complementaire_sante_solidaire] }

      before do
        stub_cnav_authenticate('complementaire_sante_solidaire')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('complementaire_sante_solidaire', siret: '13002526500013')
        end

        describe 'when the pa is found' do
          response '200', 'Complementaire Sante Solidaire trouvée' do
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

              build_rswag_example(NotFoundError.new('RNCPS', "Le dossier allocataire n'a pas été trouvé auprès du RNCPS.", title: 'Dossier allocataire absent RNCPS', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Allocataire non référencé' do
              before do
                stub_rncps_404('complementaire_sante_solidaire')
              end

              build_rswag_example(NotFoundError.new('RNCPS', "L'allocataire n'est pas référencé auprès des caisses éligibles", title: 'Allocataire non référencé', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Erreur inattendue' do
              before do
                stub_cnav_404('complementaire_sante_solidaire')
              end

              build_rswag_example(NotFoundError.new('RNCPS', 'Une erreur inattendue est survenue lors de la collecte des données', title: 'Erreur inattendue', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
          # rubocop:enable RSpec/ContextWording
        end

        common_provider_errors_request('CNAV', CNAV::ComplementaireSanteSolidaire)
        common_network_error_request('CNAV', CNAV::ComplementaireSanteSolidaire)
      end
    end
  end
end
