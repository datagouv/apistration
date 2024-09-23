require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: allocation adulte handicape with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/allocation_adulte_handicape/civility' do
    get SwaggerData.get('cnav.aah.title') do
      tags(*SwaggerData.get('cnav.aah.tags'))

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
          sexeEtatCivil
          codePaysLieuDeNaissance
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

            let(:codePaysLieuDeNaissance) { '99623' }

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.'), false)

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
