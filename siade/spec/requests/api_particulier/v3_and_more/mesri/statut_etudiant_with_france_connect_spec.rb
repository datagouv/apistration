require 'swagger_helper'

RSpec.describe 'API Particulier: Mesri: Statut Etudiant with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/mesri/statut_etudiant/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('mesri.commons.title')}" do
      tags(*SwaggerData.get('mesri.commons.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[mesri_identite mesri_admissions mesri_admission_inscrit mesri_admission_regime_formation mesri_admission_commune_etudes mesri_admission_etablissement_etudes] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
        end

        context 'when the student is found' do
          before do
            stub_mesri_with_civility_valid
          end

          response '200', 'Étudiant identifié' do
            description SwaggerData.get('mesri.commons.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('mesri.commons.attributes_without_identity')
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

            build_rswag_example(NotFoundError.new('MESRI', "Aucun étudiant n'a pu être trouvé.", with_identifiant_message: false))

            run_test!
          end
        end
      end

      # TODO: Waiting FCv2 to be merge to provide error examples
    end
  end
end
