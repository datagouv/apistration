require 'swagger_helper'

RSpec.describe 'API Particulier: CNOUS: Statut Etudiant with FranceConnect v4', api: :particulier, type: %i[request swagger] do
  path '/v4/cnous/etudiant_boursier/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnous.commons.title')}" do
      tags(*SwaggerData.get('cnous.commons.tags'))

      common_action_attributes

      parameter name: :campaignYear,
        in: :query,
        description: SwaggerData.get('cnous.etudiant_boursier.parameters.campaignYear.description'),
        example: SwaggerData.get('cnous.etudiant_boursier.parameters.campaignYear.example'),
        schema: {
          type: :integer,
          minimum: SwaggerData.get('cnous.etudiant_boursier.parameters.campaignYear.minimum')
        },
        required: false

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

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
              attributes: SwaggerData.get('cnous.commons.v4_attributes_without_identity')
            )

            run_test!
          end
        end
      end
    end
  end
end
