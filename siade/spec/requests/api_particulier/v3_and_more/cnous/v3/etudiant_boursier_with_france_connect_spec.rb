require 'swagger_helper'

RSpec.describe 'API Particulier: CNOUS: Statut Etudiant with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/cnous/etudiant_boursier/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnous.commons.title')}" do
      tags(*SwaggerData.get('cnous.commons.tags'))
      deprecated true

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

      before do
        mock_cnous_authenticate
        mock_cnous_valid_call('france_connect')
      end

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
        end

        context 'when the student is found' do
          response '200', 'Étudiant identifié' do
            description SwaggerData.get('cnous.commons.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('cnous.commons.attributes_without_identity')
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

            build_rswag_example(NotFoundError.new('CNOUS', "Aucun étudiant boursier n'a pu être trouvé.", with_identifiant_message: false))

            run_test!
          end
        end

        context 'when the provider returns a bad request' do
          before do
            mock_cnous_bad_request_call('france_connect')
          end

          response '422', 'Paramètres invalides' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(UnprocessableEntityError.new(:civility))

            run_test!
          end
        end
      end

      # TODO: Waiting FCv2 to be merge to provide error examples
    end
  end
end
