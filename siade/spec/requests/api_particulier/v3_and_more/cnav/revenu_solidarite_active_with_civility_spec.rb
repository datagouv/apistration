require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Revenu de solidarité active with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/revenu_solidarite_active/civility' do
    get SwaggerData.get('cnav.rsa.title') do
      tags(*SwaggerData.get('cnav.rsa.tags'))

      common_action_attributes

      cacheable_request

      parameters_cnav_identite_pivot(
        params: %w[
          nomUsage
          nomNaissance
          prenoms
          anneeDateDeNaissance
          moisDateDeNaissance
          jourDateDeNaissance
          codeCogInseeCommuneDeNaissance
          codePaysLieuDeNaissance
          sexeEtatCivil
          nomCommuneNaissance
          codeCogInseeDepartementDeNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          anneeDateDeNaissance
          moisDateDeNaissance
          jourDateDeNaissance
          sexeEtatCivil
        ]
      )

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:sexeEtatCivil) { 'M' }
      let(:anneeDateDeNaissance) { 1980 }
      let(:moisDateDeNaissance) { 6 }
      let(:jourDateDeNaissance) { 12 }
      let(:codePaysLieuDeNaissance) { '99100' }
      let(:codeCogInseeCommuneDeNaissance) { '17300' }
      let(:codeCogInseeDepartementDeNaissance) { nil }
      let(:nomCommuneNaissance) { nil }

      unauthorized_request

      forbidden_request

      too_many_requests(CNAV::RevenuSolidariteActive)

      let(:scopes) { %i[revenu_solidarite_active] }

      before do
        stub_cnav_authenticate('revenu_solidarite_active')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('revenu_solidarite_active', siret: '10000000000008')
        end

        describe 'when the rsa is found' do
          response '200', 'Revenu solidarité active trouvée' do
            description SwaggerData.get('cnav.rsa.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response_api_particulier(
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

            let(:codePaysLieuDeNaissance) { '99623' }

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.'))

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::RevenuSolidariteActive)
        common_network_error_request('CNAV', CNAV::RevenuSolidariteActive)
      end
    end
  end
end
