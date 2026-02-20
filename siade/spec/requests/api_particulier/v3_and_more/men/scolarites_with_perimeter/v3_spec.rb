require 'swagger_helper'

RSpec.describe 'MEN: Scolarites with perimeter', api: :particulier, type: %i[request swagger] do
  path '/v3/men/scolarites/identite_perimetre' do
    get SwaggerData.get('men.scolarite_perimetre.title') do
      tags(*SwaggerData.get('men.scolarite_perimetre.tags'))

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

      parameter name: :anneeScolaire,
        in: :query,
        type: SwaggerData.get('men.scolarite_perimetre.parameters.annee_scolaire.type'),
        description: SwaggerData.get('men.scolarite_perimetre.parameters.annee_scolaire.description'),
        example: SwaggerData.get('men.scolarite_perimetre.parameters.annee_scolaire.examples.long.value'),
        required: true

      parameter name: :degreEtablissement,
        in: :query,
        type: SwaggerData.get('men.scolarite_perimetre.parameters.degre_etablissement.type'),
        description: SwaggerData.get('men.scolarite_perimetre.parameters.degre_etablissement.description'),
        example: SwaggerData.get('men.scolarite_perimetre.parameters.degre_etablissement.example'),
        required: true

      parameter name: :'codesCogInseeCommunes[]',
        in: :query,
        schema: { type: :array, items: { type: :string } },
        description: SwaggerData.get('men.scolarite_perimetre.parameters.codes_cog_insee_communes.description'),
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

      parameter name: :'identifiantsSirenIntercommunalites[]',
        in: :query,
        schema: { type: :array, items: { type: :string } },
        description: SwaggerData.get('men.scolarite_perimetre.parameters.identifiants_siren_intercommunalites.description'),
        required: false

      let(:nomNaissance) { 'NOMFAMILLE' }
      let(:'prenoms[]') { %w[prenom] }
      let(:anneeDateNaissance) { '2000' }
      let(:moisDateNaissance) { '06' }
      let(:jourDateNaissance) { '10' }
      let(:sexeEtatCivil) { 'f' }
      let(:anneeScolaire) { '2021' }
      let(:degreEtablissement) { '2D' }
      let(:'codesCogInseeCommunes[]') { %w[75056] }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(MEN::ScolaritesPerimetre)

      let(:scopes) { %i[men_statut_scolarite] }

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_men_scolarites_auth
        end

        describe 'when found' do
          before { stub_men_scolarites_perimetre_valid }

          response '200', 'Scolarite trouvee' do
            description SwaggerData.get('men.scolarite_perimetre.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('men.scolarite.attributes')
            )

            run_test!
          end
        end

        describe 'when not found' do
          before { stub_men_scolarites_perimetre_not_found }

          response '404', 'Non trouvee' do
            build_rswag_example(NotFoundError.new('MEN', "Aucun eleve n'a pu etre trouve avec les criteres de recherche fournis", with_identifiant_message: false))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          unprocessable_content_error_request(:degre_etablissement) do
            let(:degreEtablissement) { 'invalid' }
          end

          unprocessable_content_error_request(:codes_cog_insee_communes) do
            let(:'codesCogInseeCommunes[]') { %w[ABCDE] }
          end

          common_provider_errors_request('MEN', MEN::ScolaritesPerimetre)

          common_network_error_request('MEN', MEN::ScolaritesPerimetre)
        end
      end
    end
  end
end
