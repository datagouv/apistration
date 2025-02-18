require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Participation familial PSU with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/participation_familial_psu/identite' do
    get SwaggerData.get('cnav.psu.title') do
      tags(*SwaggerData.get('cnav.psu.tags'))

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

      too_many_requests(CNAV::ParticipationFamilialPSU)

      let(:scopes) { %i[psu_allocataires psu_enfants psu_adresse psu_parametres_calcul_tarif] }

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Dossier trouvé', pending: 'Implement Endpoint' do
          description SwaggerData.get('cnav.psu.description')

          cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('cnav.psu.attributes')
          )

          run_test!
        end

        response '404', 'Dossier non trouvé', pending: 'Implement Endpoint' do
          build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.', with_identifiant_message: false))

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        common_provider_errors_request('CNAV', CNAV::ParticipationFamilialPSU)
        common_network_error_request('CNAV', CNAV::ParticipationFamilialPSU)
      end
    end
  end
end
