require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Participation familiale EAJE with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/participation_familiale_eaje/identite' do
    get "[Identité] #{SwaggerData.get('cnav.eaje.title')}" do
      tags(*SwaggerData.get('cnav.eaje.tags'))

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

      too_many_requests(CNAV::ParticipationFamilialeEAJE)

      let(:scopes) { %i[cnav_participation_familiale_eaje_allocataires cnav_participation_familiale_eaje_enfants cnav_participation_familiale_eaje_adresse cnav_participation_familiale_eaje_parametres_calcul] }

      before do
        stub_cnav_authenticate('participation_familiale_eaje')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_authenticate('participation_familiale_eaje')
        end

        context 'when found' do
          before { stub_cnav_valid('participation_familiale_eaje', siret: '13002526500013') }

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.eaje.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.eaje.attributes')
            )

            run_test!
          end
        end

        context 'when not found' do
          before { stub_cnav_404('participation_familiale_eaje') }

          response '404', 'Dossier non trouvé' do
            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.', with_identifiant_message: false))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::ParticipationFamilialeEAJE)
        common_network_error_request('CNAV', CNAV::ParticipationFamilialeEAJE)
      end
    end
  end
end
