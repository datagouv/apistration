require 'swagger_helper'

RSpec.describe 'FranceTravail: Indemnites with identifiant', api: :particulier, type: %i[request swagger] do
  path '/v3/france_travail/indemnites/identifiant' do
    get SwaggerData.get('france_travail.indemnites.title') do
      tags(*SwaggerData.get('france_travail.indemnites.tags'))

      common_action_attributes

      parameter name: :identifiant,
        in: :query,
        type: SwaggerData.get('france_travail.commons.parameters.identifiant.type'),
        description: SwaggerData.get('france_travail.commons.parameters.identifiant.description'),
        example: SwaggerData.get('france_travail.commons.parameters.identifiant.example'),
        required: SwaggerData.get('france_travail.commons.parameters.identifiant.required')

      let(:identifiant) { 'identifiant_france_travail' }
      let(:scopes) { %i[pole_emploi_indemnites] }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(FranceTravail::Indemnites)

      describe 'with valid token and mandatory params', :valid, vcr: { cassette_name: 'france_travail/oauth2' } do
        describe 'when it is found' do
          before do
            stub_france_travail_indemnites_valid(identifiant:)
          end

          response '200', 'Indemnites trouvées' do
            description SwaggerData.get('france_travail.indemnites.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('france_travail.indemnites.attributes')
            )

            run_test!
          end
        end

        describe 'when it is not found' do
          before do
            stub_france_travail_indemnites_not_found(identifiant:)
          end

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('France Travail', 'Aucune situation France Travail n\'a pu être trouvée avec les critères de recherche fournis.', with_identifiant_message: false))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        common_provider_errors_request('France Travail', FranceTravail::Indemnites)
        common_network_error_request('France Travail', FranceTravail::Indemnites)
      end
    end
  end
end
