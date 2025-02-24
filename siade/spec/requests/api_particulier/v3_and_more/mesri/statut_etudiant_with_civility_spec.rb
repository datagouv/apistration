require 'swagger_helper'

RSpec.describe 'API Particulier: Mesri: Statut Etudiant with Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/mesri/statut_etudiant/identite' do
    get "[Identité] #{SwaggerData.get('mesri.commons.title')}" do
      tags(*SwaggerData.get('mesri.commons.tags'))

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
          sexeEtatCivil
        ],
        api: 'statut_etudiant'
      )

      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[Jean] }
      let(:anneeDateNaissance) { '2000' }
      let(:moisDateNaissance) { '01' }
      let(:jourDateNaissance) { '01' }
      let(:codeCogInseeCommuneNaissance) { '75113' }
      let(:sexeEtatCivil) { 'm' }
      let(:codeCogInseeDepartementNaissance) { nil }
      let(:nomCommuneNaissance) { nil }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(MESRI::StudentStatus::WithCivility)

      let(:scopes) { %i[mesri_identite mesri_admissions mesri_admission_inscrit mesri_admission_regime_formation mesri_admission_commune_etudes mesri_admission_etablissement_etudes] }

      describe 'with valid token and mandatory params', :valid do
        context 'when the student is found' do
          before do
            stub_mesri_with_civility_valid
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
            stub_mesri_with_civility_not_found
          end

          response '404', 'Étudiant non identifié' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('MESRI', "Aucun étudiant n'a pu être trouvé avec les critères de recherche fournis.", with_identifiant_message: false))

            run_test!
          end
        end

        common_provider_errors_request('MESRI', MESRI::StudentStatus::WithCivility)
        common_network_error_request('MESRI', MESRI::StudentStatus::WithCivility)
      end
    end
  end
end
