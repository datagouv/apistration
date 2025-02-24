require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: allocation adulte handicape with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/allocation_adulte_handicape/identite' do
    get "[Identité] #{SwaggerData.get('cnav.aah.title')}" do
      tags(*SwaggerData.get('cnav.aah.tags'))

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

      too_many_requests(CNAV::AllocationAdulteHandicape)

      let(:scopes) { %i[allocation_adulte_handicape] }

      before do
        stub_cnav_authenticate('allocation_adulte_handicape')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('allocation_adulte_handicape', siret: '13002526500013')
        end

        describe 'when the pa is found' do
          response '200', 'Allocation Adulte Handicape active trouvée' do
            description SwaggerData.get('cnav.aah.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.aah.attributes')
            )

            run_test!
          end
        end

        describe 'when the pa is not found' do
          response '404', 'Dossier non trouvé' do
            before do
              stub_cnav_404('allocation_adulte_handicape')
            end

            let(:codeCogInseePaysNaissance) { '99623' }

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.', with_identifiant_message: false))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::AllocationAdulteHandicape)
        common_network_error_request('CNAV', CNAV::AllocationAdulteHandicape)
      end
    end
  end
end
