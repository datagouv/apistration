require 'swagger_helper'

RSpec.describe 'API Particulier: CNOUS: Etudiant Boursier with Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/cnous/etudiant_boursier/identite' do
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

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(CNOUS::StudentScholarshipWithCivility)

      let(:scopes) { %i[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

      describe 'with valid token and mandatory params', :valid do
        context 'when the student is found' do
          before do
            mock_cnous_valid_call('civility')
          end

          response '200', 'Étudiant identifié' do
            description SwaggerData.get('cnous.commons.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('cnous.commons.attributes')
            )

            run_test!
          end
        end

        context 'when the student is not found' do
          before do
            mock_cnous_not_found_call('civility')
          end

          response '404', 'Étudiant non identifié' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNOUS', "Aucun étudiant boursier n'a pu être trouvé avec les critères de recherche fournis.", with_identifiant_message: false))

            run_test!
          end
        end

        context 'when the provider returns a bad request' do
          before do
            mock_cnous_bad_request_call('civility')
          end

          response '422', 'Paramètres invalides' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(UnprocessableEntityError.new(:civility))

            run_test!
          end
        end

        common_provider_errors_request('CNOUS', CNOUS::StudentScholarshipWithCivility)
        common_network_error_request('CNOUS', CNOUS::StudentScholarshipWithCivility)
      end
    end
  end
end
