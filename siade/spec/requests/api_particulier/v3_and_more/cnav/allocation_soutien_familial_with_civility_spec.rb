require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: allocation soutien familial with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/allocation_soutien_familial/identite' do
    get SwaggerData.get('cnav.asf.title') do
      tags(*SwaggerData.get('cnav.asf.tags'))

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

      forbidden_request('api_particulier')

      too_many_requests(CNAV::AllocationSoutienFamilial)

      let(:scopes) { %i[allocation_soutien_familial] }

      before do
        stub_cnav_authenticate('allocation_soutien_familial')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('allocation_soutien_familial', siret: '13002526500013')
        end

        describe 'when the pa is found' do
          response '200', 'Allocation Soutien Familial active trouvée' do
            description SwaggerData.get('cnav.asf.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.asf.attributes')
            )

            run_test!
          end
        end

        describe 'when the pa is not found' do
          response '404', 'Dossier non trouvé' do
            before do
              stub_cnav_404('allocation_soutien_familial')
            end

            let(:codePaysLieuDeNaissance) { '99623' }

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.', with_identifiant_message: false))

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::AllocationSoutienFamilial)
        common_network_error_request('CNAV', CNAV::AllocationSoutienFamilial)
      end
    end
  end
end
