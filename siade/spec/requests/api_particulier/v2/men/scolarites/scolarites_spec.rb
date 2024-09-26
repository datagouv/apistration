require 'swagger_helper'

RSpec.describe 'MEN: Scolarites', api: :particulierv2, type: %i[request swagger] do
  path '/api/v2/scolarites' do
    get SwaggerData.get('men.scolarite.title') do
      tags(*SwaggerData.get('men.scolarite.tags'))

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
        type: SwaggerData.get('men.scolarite.parameters.nom.type'),
        description: SwaggerData.get('men.scolarite.parameters.nom.description'),
        example: SwaggerData.get('men.scolarite.parameters.nom.example'),
        required: SwaggerData.get('men.scolarite.parameters.nom.required')

      parameter name: :prenom,
        in: :query,
        type: SwaggerData.get('men.scolarite.parameters.prenom.type'),
        description: SwaggerData.get('men.scolarite.parameters.prenom.description'),
        example: SwaggerData.get('men.scolarite.parameters.prenom.example'),
        required: SwaggerData.get('men.scolarite.parameters.prenom.required')

      parameter name: :sexe,
        in: :query,
        type: SwaggerData.get('men.scolarite.parameters.sexe.type'),
        description: SwaggerData.get('men.scolarite.parameters.sexe.description'),
        example: SwaggerData.get('men.scolarite.parameters.sexe.example'),
        required: SwaggerData.get('men.scolarite.parameters.sexe.required')

      parameter name: :dateNaissance,
        in: :query,
        type: SwaggerData.get('men.scolarite.parameters.date_naissance.type'),
        description: SwaggerData.get('men.scolarite.parameters.date_naissance.description'),
        example: SwaggerData.get('men.scolarite.parameters.date_naissance.example'),
        required: SwaggerData.get('men.scolarite.parameters.date_naissance.required')

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
        required: SwaggerData.get('men.scolarite.parameters.annee_scolaire.required')

      # rubocop:disable RSpec/VariableName
      let(:'X-Api-Key') { x_api_key }

      let(:dateNaissance) { '2000-06-10' }
      let(:codeEtablissement) { '0511474A' }
      let(:anneeScolaire) { '2021' }
      # rubocop:enable RSpec/VariableName
      let(:nom) { 'NOMFAMILLE' }
      let(:prenom) { 'prenom' }
      let(:sexe) { 'f' }

      let(:x_api_key) { nil }
      let(:scopes) { nil }

      describe 'with valid token and mandatory params' do
        let(:x_api_key) { TokenFactory.new(scopes).valid }
        let(:scopes) { %w[men_statut_scolarite men_statut_boursier men_echelon_bourse] }

        response '200', 'Scolarité trouvée', vcr: { cassette_name: 'men/scolarites/valid' } do
          description SwaggerData.get('men.scolarite.description')

          schema build_rswag_response_api_particulier_v2(
            attributes: SwaggerData.get('men.scolarite.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          response '400', 'Paramètre(s) invalide(s)' do
            let(:sexe) { 'invalid' }

            build_rswag_example(UnprocessableEntityError.new(:gender), :unprocessable_entity_error_gender_error)

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
