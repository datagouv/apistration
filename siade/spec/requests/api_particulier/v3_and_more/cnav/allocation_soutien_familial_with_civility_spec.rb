require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: allocation soutien familial with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/allocation_soutien_familial/identite' do
    get "[Identité] #{SwaggerData.get('cnav.asf.title')}" do
      tags(*SwaggerData.get('cnav.asf.tags'))

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

            let(:codeCogInseePaysNaissance) { '99623' }

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
