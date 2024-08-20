require 'swagger_helper'

RSpec.describe 'API Particulier: Mesri: Statut Etudiant with Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/mesri/statut_etudiant/civility' do
    get SwaggerData.get('mesri.commons.title') do
      tags(*SwaggerData.get('mesri.commons.tags'))

      common_action_attributes

      parameters_cnav_identite_pivot(
        params: %w[
          nomNaissance
          prenoms
          anneeDateDeNaissance
          moisDateDeNaissance
          jourDateDeNaissance
          codeCogInseeCommuneDeNaissance
          sexeEtatCivil
          nomCommuneNaissance
          codeCogInseeDepartementDeNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          anneeDateDeNaissance
          moisDateDeNaissance
          jourDateDeNaissance
          sexeEtatCivil
        ]
      )

      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[Jean] }
      let(:anneeDateDeNaissance) { '2000' }
      let(:moisDateDeNaissance) { '01' }
      let(:jourDateDeNaissance) { '01' }
      let(:codeCogInseeCommuneDeNaissance) { '75113' }
      let(:sexeEtatCivil) { 'm' }
      let(:code_cog_insee_departement_de_naissance) { nil }
      let(:nom_commune_naissance) { nil }

      unauthorized_request

      forbidden_request

      too_many_requests(MESRI::StudentStatus::WithCivility)

      let(:scopes) { %i[mesri_identite mesri_statut mesri_regime mesri_etablissements] }

      describe 'with valid token and mandatory params', :valid do
        context 'when the student is found' do
          before do
            stub_mesri_with_civility_valid
          end

          response '200', 'Étudiant identifié' do
            description SwaggerData.get('mesri.commons.description')

            schema build_rswag_response_api_particulier(
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

            build_rswag_example(NotFoundError.new('MESRI', "Aucun étudiant n'a pu être trouvé avec les critères de recherche fournis"))

            run_test!
          end
        end

        common_provider_errors_request('MESRI', MESRI::StudentStatus::WithCivility)
        common_network_error_request('MESRI', MESRI::StudentStatus::WithCivility)
      end
    end
  end
end
