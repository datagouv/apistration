require 'swagger_helper'

RSpec.describe 'MEN: Scolarites', api: :particulierv2, type: %i[request swagger] do
  path '/api/v2/scolarites' do
    get SwaggerData.get('men.scolarite.v2.title') do
      deprecated true

      tags(*SwaggerData.get('men.scolarite.v2.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :recipient,
        in: :query,
        type: :string,
        description: SwaggerData.get('parameters.recipient.description'),
        example: SwaggerData.get('parameters.recipient.example'),
        required: false

      parameter name: :nom,
        in: :query,
        type: SwaggerData.get('men.scolarite.v2.parameters.nom.type'),
        description: SwaggerData.get('men.scolarite.v2.parameters.nom.description'),
        example: SwaggerData.get('men.scolarite.v2.parameters.nom.example'),
        required: SwaggerData.get('men.scolarite.v2.parameters.nom.required')

      parameter name: :prenom,
        in: :query,
        type: SwaggerData.get('men.scolarite.v2.parameters.prenom.type'),
        description: SwaggerData.get('men.scolarite.v2.parameters.prenom.description'),
        example: SwaggerData.get('men.scolarite.v2.parameters.prenom.example'),
        required: SwaggerData.get('men.scolarite.v2.parameters.prenom.required')

      parameter name: :sexe,
        in: :query,
        type: SwaggerData.get('men.scolarite.v2.parameters.sexe.type'),
        description: SwaggerData.get('men.scolarite.v2.parameters.sexe.description'),
        example: SwaggerData.get('men.scolarite.v2.parameters.sexe.example'),
        required: SwaggerData.get('men.scolarite.v2.parameters.sexe.required')

      parameter name: :dateNaissance,
        in: :query,
        type: SwaggerData.get('men.scolarite.v2.parameters.date_naissance.type'),
        description: SwaggerData.get('men.scolarite.v2.parameters.date_naissance.description'),
        example: SwaggerData.get('men.scolarite.v2.parameters.date_naissance.example'),
        required: SwaggerData.get('men.scolarite.v2.parameters.date_naissance.required')

      parameter name: :codeEtablissement,
        in: :query,
        type: SwaggerData.get('men.scolarite.v2.parameters.code_etablissement.type'),
        description: SwaggerData.get('men.scolarite.v2.parameters.code_etablissement.description'),
        example: SwaggerData.get('men.scolarite.v2.parameters.code_etablissement.example'),
        required: true

      parameter name: :anneeScolaire,
        in: :query,
        type: SwaggerData.get('men.scolarite.v2.parameters.annee_scolaire.type'),
        description: SwaggerData.get('men.scolarite.v2.parameters.annee_scolaire.description'),
        example: SwaggerData.get('men.scolarite.v2.parameters.annee_scolaire.examples.long.value'),
        required: SwaggerData.get('men.scolarite.v2.parameters.annee_scolaire.required')

      # rubocop:disable RSpec/VariableName
      let(:'X-Api-Key') { x_api_key }

      let(:dateNaissance) { '2000-06-10' }
      let(:codeEtablissement) { '0511474A' }
      let(:anneeScolaire) { '2021' }
      # rubocop:enable RSpec/VariableName
      let(:nom) { 'NOMFAMILLE' }
      let(:prenom) { 'prenom' }
      let(:sexe) { 'f' }

      describe 'with valid token and mandatory params' do
        context 'when user does not have any boursier scopes' do
          let(:x_api_key) { TokenFactory.new(scopes).valid }
          let!(:scopes) { %w[men_statut_identite men_statut_scolarite men_statut_etablissement men_statut_module_elementaire_formation] }

          response '200', 'Scolarité trouvée v2', vcr: { cassette_name: 'men/scolarites/valid_v2' } do
            description SwaggerData.get('men.scolarite.v2.description')

            schema build_rswag_response_api_particulier_v2(
              attributes: SwaggerData.get('men.scolarite.v2.attributes')
            )

            run_test!
          end
        end

        context 'when user has included boursier scopes' do
          let(:x_api_key) { TokenFactory.new(scopes).valid }
          let!(:scopes) { %w[men_statut_scolarite men_statut_boursier men_echelon_bourse] }

          response '200', 'Scolarité trouvée', vcr: { cassette_name: 'men/scolarites/valid' } do
            description SwaggerData.get('men.scolarite.v2.description')

            schema build_rswag_response_api_particulier_v2(
              attributes: SwaggerData.get('men.scolarite.v2.attributes')
            )

            run_test!
          end
        end

        describe 'server errors' do
          let(:x_api_key) { TokenFactory.new(scopes).valid }
          let!(:scopes) { %w[men_statut_scolarite men_statut_boursier men_echelon_bourse] }

          response '400', 'Paramètre(s) invalide(s)' do
            let(:sexe) { 'invalid' }

            build_rswag_example(UnprocessableEntityError.new(:gender), :unprocessable_content_error_gender_error)

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'men/scolarites/not_found' } do
            let(:sexe) { 'f' }

            build_rswag_example(NotFoundError.new('MEN', 'Aucun élève n\'a pu être trouvé avec les critères de recherche fournis'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '503', 'Erreur du fournisseur' do
            provider_unknown_error = ProviderUnknownError.new('MEN')

            stubbed_organizer_error(
              MEN::Scolarites,
              provider_unknown_error
            )

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(provider_unknown_error, :unknown_error)

            run_test!
          end

          response '504', 'Erreur d\'intermédiaire' do
            schema '$ref' => '#/components/schemas/Error'

            provider_timeout_error = ProviderTimeoutError.new('MEN')

            stubbed_organizer_error(
              MEN::Scolarites,
              provider_timeout_error
            )

            run_test!
          end
        end
      end
    end
  end
end
