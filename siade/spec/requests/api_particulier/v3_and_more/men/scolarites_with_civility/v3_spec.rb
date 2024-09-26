require 'swagger_helper'

RSpec.describe 'MEN: Scolarites with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/men/scolarites/identite' do
    get SwaggerData.get('men.scolarite.title') do
      tags(*SwaggerData.get('men.scolarite.tags'))

      common_action_attributes

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          prenoms
          sexeEtatCivil
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          sexeEtatCivil
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
        ]
      )

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

      let(:nomNaissance) { 'NOMFAMILLE' }
      let(:'prenoms[]') { %w[prenom] }
      let(:anneeDateNaissance) { '2000' }
      let(:moisDateNaissance) { '06' }
      let(:jourDateNaissance) { '10' }
      let(:sexeEtatCivil) { 'f' }
      let(:codeEtablissement) { '0511474A' }
      let(:anneeScolaire) { '2021' }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(MEN::Scolarites)

      let(:scopes) { %i[men_statut_scolarite men_statut_boursier men_echelon_bourse] }
      describe 'with valid token and mandatory params', :valid do
        response '200', 'Scolarité trouvée', vcr: { cassette_name: 'men/scolarites/valid' } do
          description SwaggerData.get('men.scolarite.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('men.scolarite.attributes')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'men/scolarites/not_found' } do
          let(:sexe) { 'f' }

          build_rswag_example(NotFoundError.new('MEN', 'Aucun élève n\'a pu être trouvé avec les critères de recherche fournis.', with_identifiant_message: false))

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        common_provider_errors_request('MEN', MEN::Scolarites)
        common_network_error_request('MEN', MEN::Scolarites)
      end
    end
  end
end
