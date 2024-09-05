require 'swagger_helper'

RSpec.describe 'API Particulier: CNOUS: Statut Etudiant with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/cnous/etudiant_boursier/france_connect' do
    get SwaggerData.get('cnous.commons.title') do
      tags(*SwaggerData.get('cnous.commons.tags'))

      common_action_attributes

      let(:scopes) { %i[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

      before do
        mock_cnous_authenticate
        mock_cnous_valid_call('france_connect')
      end

      describe 'with a FranceConnect token' do
        let(:recipient) { valid_siret(:recipient) }
        let(:Authorization) { 'Bearer super_valid_token' }

        before do
          mock_valid_france_connect_checktoken(scopes:)
        end

        context 'when the student is found' do
          response '200', 'Étudiant identifié' do
            description SwaggerData.get('cnous.commons.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnous.commons.attributes')
            )

            run_test!
          end
        end

        context 'when the student is not found' do
          before do
            mock_cnous_not_found_call('france_connect')
          end

          response '404', 'Étudiant non identifié' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNOUS'), "Aucun étudiant boursier n'a pu être trouvé avec les critères de recherche fournis Veuillez vérifier que l'identifiant correspond au périmètre couvert par l'API.")

            run_test!
          end
        end
      end

      # TODO: Waiting FCv2 to be merge to provide error examples
    end
  end
end
