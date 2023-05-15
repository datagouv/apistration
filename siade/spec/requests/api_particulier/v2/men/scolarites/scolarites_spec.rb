require 'swagger_helper'

RSpec.describe 'MEN: Scolarites', api: :particulier, type: %i[request swagger] do
  path '/api/v2/scolarites' do
    get SwaggerData.get('men.scolarite.title') do
      tags(*SwaggerData.get('men.scolarite.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :nom,                in: :query, type: :string
      parameter name: :prenom,             in: :query, type: :string
      parameter name: :sexe,               in: :query, type: :string
      parameter name: :dateNaissance,     in: :query, type: :string
      parameter name: :codeEtablissement, in: :query, type: :string
      parameter name: :anneeScolaire,     in: :query, type: :string

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

        context 'with all scopes' do
          response '200', 'Scolarité trouvée', vcr: { cassette_name: 'men/scolarites/valid' } do
            description SwaggerData.get('men.scolarite.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('men.scolarite.attributes')
            )

            run_test!
          end
        end

        context 'with restricted scopes', document: false do
          let(:scopes) { %w[men_statut_scolarite men_echelon_bourse] }

          response '200', 'Scolarité trouvée', vcr: { cassette_name: 'men/scolarites/valid' } do
            description SwaggerData.get('men.scolarite.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('men.scolarite.attributes').except('est_boursier')
            )

            run_test!
          end
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
