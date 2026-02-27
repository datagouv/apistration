require 'swagger_helper'

RSpec.describe 'MEN: Scolarites with civility', api: :particulier, type: %i[request swagger] do
  path '/v4/men/scolarites/identite' do
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
        required: false

      parameter name: :anneeScolaire,
        in: :query,
        type: SwaggerData.get('men.scolarite.parameters.annee_scolaire.type'),
        description: SwaggerData.get('men.scolarite.parameters.annee_scolaire.description'),
        example: SwaggerData.get('men.scolarite.parameters.annee_scolaire.examples.long.value'),
        required: true

      parameter name: :degreEtablissement,
        in: :query,
        type: SwaggerData.get('men.scolarite_perimetre.parameters.degre_etablissement.type'),
        description: SwaggerData.get('men.scolarite_perimetre.parameters.degre_etablissement.description'),
        example: SwaggerData.get('men.scolarite_perimetre.parameters.degre_etablissement.example'),
        required: false

      parameter name: :'codesBcnDepartements[]',
        in: :query,
        schema: { type: :array, items: { type: :string } },
        description: SwaggerData.get('men.scolarite_perimetre.parameters.codes_bcn_departements.description'),
        required: false

      parameter name: :'codesBcnRegions[]',
        in: :query,
        schema: { type: :array, items: { type: :string } },
        description: SwaggerData.get('men.scolarite_perimetre.parameters.codes_bcn_regions.description'),
        required: false

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
        describe 'with code_etablissement mode' do
          response '200', 'Scolarite trouvee', vcr: { cassette_name: 'men/scolarites/valid_v2' } do
            description SwaggerData.get('men.scolarite.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('men.scolarite.attributes')
            )

            run_test!
          end

          response '404', 'Non trouvee', vcr: { cassette_name: 'men/scolarites/not_found_v2' } do
            let(:sexe) { 'f' }

            build_rswag_example(NotFoundError.new('MEN', 'Aucun élève n\'a pu être trouvé avec les critères de recherche fournis.', with_identifiant_message: false))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'with perimetre mode' do
          let(:codeEtablissement) { nil }
          let(:degreEtablissement) { '2D' }
          let(:'codesBcnRegions[]') { %w[11] }

          before do
            stub_men_scolarites_auth
          end

          describe 'when found' do
            before { stub_men_scolarites_perimetre_valid }

            response '200', 'Scolarite trouvee par perimetre' do
              schema build_rswag_response(
                attributes: SwaggerData.get('men.scolarite.attributes')
              )

              run_test!
            end
          end

          describe 'when not found' do
            before { stub_men_scolarites_perimetre_not_found }

            response '404', 'Non trouvee par perimetre' do
              build_rswag_example(NotFoundError.new('MEN', "Aucun eleve n'a pu etre trouve avec les criteres de recherche fournis", with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end
        end

        describe 'with mutual exclusivity error' do
          let(:codeEtablissement) { '0511474A' }
          let(:'codesBcnRegions[]') { %w[11] }

          unprocessable_content_error_request(:code_etablissement_et_perimetre)
        end

        common_provider_errors_request('MEN', MEN::Scolarites)
        common_network_error_request('MEN', MEN::Scolarites)
      end
    end
  end
end
