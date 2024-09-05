require 'swagger_helper'

RSpec.describe 'FranceTravail: Statut', api: :particulier, type: %i[request swagger] do
  path '/v3/france_travail/statut/' do
    get SwaggerData.get('france_travail.statut.title') do
      tags(*SwaggerData.get('france_travail.statut.tags'))

      common_action_attributes

      parameter name: :identifiant,
        in: :query,
        type: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.type'),
        description: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.description'),
        example: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.example'),
        required: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.required')

      let(:identifiant) { 'identifiant_france_travail' }
      let(:scopes) { %i[pole_emploi_identite pole_emploi_adresse pole_emploi_contact pole_emploi_inscription] }

      unauthorized_request

      forbidden_request

      too_many_requests(FranceTravail::Statut)

      describe 'with valid token and mandatory params', :valid, vcr: { cassette_name: 'pole_emploi/oauth2' } do
        describe 'when it is found' do
          before do
            stub_france_travail_statut_valid
          end

          response '200', 'Statut trouvé' do
            description SwaggerData.get('france_travail.statut.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('france_travail.statut.attributes')
            )

            run_test!
          end
        end

        describe 'when it is not found' do
          before do
            stub_france_travail_statut_not_found
          end

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('France Travail', 'Aucune situation France Travail n\'a pu être trouvée avec les critères de recherche fournis'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        common_provider_errors_request('France Travail', FranceTravail::Statut)
        common_network_error_request('France Travail', FranceTravail::Statut)
      end
    end
  end
end
