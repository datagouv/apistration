require 'swagger_helper'

RSpec.describe 'API Particulier: Mesri: Statut Etudiant with INE', api: :particulier, type: %i[request swagger] do
  path '/v3/mesri/statut_etudiant/ine' do
    get "[INE] #{SwaggerData.get('mesri.commons.title')}" do
      tags(*SwaggerData.get('mesri.commons.tags'))

      common_action_attributes

      unauthorized_request do
        let(:ine) { '1234567890A' }
      end

      forbidden_request('api_particulier') do
        let(:ine) { '1234567890A' }
      end

      too_many_requests(MESRI::StudentStatus::WithINE) do
        let(:ine) { '1234567890A' }
      end

      parameter name: :ine,
        in: :query,
        description: SwaggerData.get('mesri.statut_etudiant.parameters.ine.description'),
        example: SwaggerData.get('mesri.statut_etudiant.parameters.ine.example'),
        schema: {
          type: :string,
          pattern: SwaggerData.get('mesri.statut_etudiant.parameters.ine.pattern')
        },
        required: true

      let(:scopes) { %i[mesri_identite mesri_admissions mesri_admission_inscrit mesri_admission_regime_formation mesri_admission_commune_etudes mesri_admission_etablissement_etudes] }

      let(:ine) { '1234567890A' }

      describe 'with valid token and mandatory params', :valid do
        context 'when the student is found' do
          before do
            stub_mesri_valid
          end

          response '200', 'Étudiant identifié' do
            description SwaggerData.get('mesri.commons.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('mesri.commons.attributes')
            )

            run_test!
          end
        end

        context 'when the student is not found' do
          before do
            stub_mesri_not_found
          end

          response '404', 'Étudiant non identifié' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('MESRI', "Aucun étudiant n'a pu être trouvé avec les critères de recherche fournis.", with_identifiant_message: false))

            run_test!
          end
        end

        common_provider_errors_request('MESRI', MESRI::StudentStatus::WithINE)
        common_network_error_request('MESRI', MESRI::StudentStatus::WithINE)
      end
    end
  end
end
