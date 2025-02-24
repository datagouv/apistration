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

        describe 'when the rsa is not found' do
          response '404', 'Dossier non trouvé' do
            before do
              stub_cnav_404('revenu_solidarite_active')
            end

            let(:codeCogInseePaysNaissance) { '99623' }

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.', with_identifiant_message: false))

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::RevenuSolidariteActive)
        common_network_error_request('CNAV', CNAV::RevenuSolidariteActive)
      end
    end
  end
end
