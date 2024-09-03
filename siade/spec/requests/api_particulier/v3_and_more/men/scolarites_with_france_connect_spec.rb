require 'swagger_helper'

RSpec.describe 'MEN: Scolarites with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/men/scolarites/france_connect' do
    get SwaggerData.get('men.scolarite.title') do
      tags(*SwaggerData.get('men.scolarite.tags'))

      common_action_attributes

      parameter name: :codeEtablissement,
        in: :query,
        type: SwaggerData.get('men.scolarite.parameters.code_etablissement.type'),
        description: SwaggerData.get('men.scolarite.parameters.code_etablissement.description'),
        example: SwaggerData.get('men.scolarite.parameters.code_etablissement.example'),
        required: true

      parameter name: :anneeScolaire,
        in: :query,
        type: SwaggerData.get('men.scolarite.parameters.annee_scolaire.type'),
        description: SwaggerData.get('men.scolarite.parameters.annee_scolaire.description'),
        example: SwaggerData.get('men.scolarite.parameters.annee_scolaire.examples.long.value'),
        required: true

      describe 'with a FranceConnect token and mandatory params', :valid do
        let(:Authorization) { 'Bearer super_valid_token' }
        let(:codeEtablissement) { '0511474A' }
        let(:anneeScolaire) { '2021' }
        let(:scopes) { %i[men_statut_scolarite men_statut_boursier men_echelon_bourse] }

        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_men_scolarites_auth
        end

        describe 'when found' do
          before { stub_men_scolarites_valid }

          response '200', 'Scolarité trouvée', vcr: { cassette_name: 'men/scolarites/valid' } do
            description SwaggerData.get('men.scolarite.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('men.scolarite.attributes')
            )

            run_test!
          end
        end

        describe 'when not found' do
          before { stub_men_scolarites_not_found }

          response '404', 'Non trouvée', vcr: { cassette_name: 'men/scolarites/not_found' } do
            let(:sexe) { 'f' }

            build_rswag_example(NotFoundError.new('MEN', 'Aucun élève n\'a pu être trouvé avec les critères de recherche fournis'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        # TODO: Waiting FCv2 to be merge to provide error examples
      end
    end
  end
end
