require 'swagger_helper'

RSpec.describe 'API Particulier: CNOUS: Etudiant Boursier with Civility v4', api: :particulier, type: %i[request swagger] do
  path '/v4/cnous/etudiant_boursier/identite' do
    get "[Identité] #{SwaggerData.get('cnous.commons.title')}" do
      tags(*SwaggerData.get('cnous.commons.tags'))

      common_action_attributes

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseeCommuneNaissance
          nomCommuneNaissance
          codeCogInseeDepartementNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
        ]
      )

      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[Jean Charlie] }
      let(:anneeDateNaissance) { 2000 }
      let(:moisDateNaissance) { 1 }
      let(:jourDateNaissance) { 1 }
      let(:codeCogInseeCommuneNaissance) { 'Paris' }
      let(:sexeEtatCivil) { 'M' }

      before do
        mock_cnous_authenticate
      end

      let(:scopes) { %i[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

      describe 'with valid token and mandatory params', :valid do
        context 'when the student is found' do
          before do
            mock_cnous_valid_call('civility')
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
