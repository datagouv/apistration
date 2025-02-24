require 'swagger_helper'

RSpec.describe 'API Particulier: CNOUS: Statut Etudiant with INE', api: :particulier, type: %i[request swagger] do
  path '/v3/cnous/etudiant_boursier/ine' do
    get "[INE] #{SwaggerData.get('cnous.commons.title')}" do
      tags(*SwaggerData.get('cnous.commons.tags'))

      common_action_attributes

      unauthorized_request do
        let(:ine) { '1234567890A' }
      end

      forbidden_request('api_particulier') do
        let(:ine) { '1234567890A' }
      end

      too_many_requests(CNOUS::StudentScholarshipWithINE) do
        let(:ine) { '1234567890A' }
      end

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
              attributes: SwaggerData.get('cnous.commons.attributes')
            )

            run_test!
          end
        end

        context 'when the student is not found' do
          before do
            mock_cnous_not_found_call('ine')
          end

          response '404', 'Étudiant non identifié' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNOUS', "Aucun étudiant boursier n'a pu être trouvé avec les critères de recherche fournis. Veuillez vérifier que l'identifiant correspond au périmètre couvert par l'API.", with_identifiant_message: false))

            run_test!
          end
        end

        common_provider_errors_request('CNOUS', CNOUS::StudentScholarshipWithINE)
        common_network_error_request('CNOUS', CNOUS::StudentScholarshipWithINE)
      end
    end
  end
end
