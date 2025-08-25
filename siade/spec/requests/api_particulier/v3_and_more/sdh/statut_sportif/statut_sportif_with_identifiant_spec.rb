require 'swagger_helper'

RSpec.describe 'SDH: Statut Sportif with identifiant SDH', api: :particulier, type: %i[request swagger] do
  path '/v3/sdh/statut_sportif/identifiant' do
    get "[Identifiant] #{SwaggerData.get('sdh.statut_sportif.title')}" do
      tags(*SwaggerData.get('sdh.statut_sportif.tags'))

      common_action_attributes

      parameter name: :identifiant,
        in: :query,
        type: SwaggerData.get('sdh.statut_sportif.parameters.identifiant.type'),
        description: SwaggerData.get('sdh.statut_sportif.parameters.identifiant.description'),
        example: SwaggerData.get('sdh.statut_sportif.parameters.identifiant.example'),
        required: SwaggerData.get('sdh.statut_sportif.parameters.identifiant.required')

      let(:valid_identifiant) { '12345' }
      let(:identifiant) { valid_identifiant }
      let(:recipient) { valid_siret(:recipient) }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(SDH::StatutSportif)

      let(:scopes) do
        %i[
          sdh_statut_sportif_identite
          sdh_statut_sportif_est_sportif_de_haut_niveau
          sdh_statut_sportif_a_ete_sportif_de_haut_niveau
          sdh_statut_sportif_informations_statut
          sdh_statut_sportif_informations_statuts_precedents
        ]
      end

      describe 'with valid token and mandatory params', :valid do
        describe 'when found' do
          response '200', 'Sportif trouvé', pending: 'Implement Endpoint' do
            description SwaggerData.get('sdh.statut_sportif.description')

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('sdh.statut_sportif.attributes')
            )

            run_test!
          end
        end

        describe 'when not found' do
          response '404', 'Non trouvé', pending: 'Implement Endpoint' do
            build_rswag_example(NotFoundError.new('SDH'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          unprocessable_content_error_request(:identifiant) do
            let(:identifiant) { 'lol' }
          end

          common_provider_errors_request('SDH', SDH::StatutSportif)

          common_network_error_request('SDH', SDH::StatutSportif)
        end
      end
    end
  end
end
