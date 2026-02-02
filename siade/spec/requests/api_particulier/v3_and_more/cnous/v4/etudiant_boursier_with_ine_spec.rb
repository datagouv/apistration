require 'swagger_helper'

RSpec.describe 'API Particulier: CNOUS: Statut Etudiant with INE v4', api: :particulier, type: %i[request swagger] do
  path '/v4/cnous/etudiant_boursier/ine' do
    get "[INE] #{SwaggerData.get('cnous.commons.title')}" do
      tags(*SwaggerData.get('cnous.commons.tags'))

      common_action_attributes

      parameter name: :ine,
        in: :query,
        description: SwaggerData.get('cnous.etudiant_boursier.parameters.ine.description'),
        example: SwaggerData.get('cnous.etudiant_boursier.parameters.ine.example'),
        schema: {
          type: :string,
          pattern: SwaggerData.get('cnous.etudiant_boursier.parameters.ine.pattern')
        },
        required: true

      let(:scopes) { %i[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

      let(:ine) { '1234567890A' }

      before do
        mock_cnous_authenticate
      end

      describe 'with valid token and mandatory params', :valid do
        context 'when the student is found' do
          before do
            mock_cnous_valid_call('ine')
          end

          response '200', 'Étudiant identifié' do
            description SwaggerData.get('cnous.commons.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('cnous.commons.v4_attributes')
            )

            run_test!
          end
        end
      end
    end
  end
end
