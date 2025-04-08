require 'swagger_helper'

RSpec.describe 'Pole Emploi: Indemnites', api: :particulierv2, type: %i[request swagger] do
  path '/api/v2/paiements-pole-emploi' do
    get SwaggerData.get('france_travail.indemnites.title') do
      deprecated true

      tags(*SwaggerData.get('france_travail.indemnites.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :recipient,
        in: :query,
        type: :string,
        description: SwaggerData.get('parameters.recipient.description'),
        example: SwaggerData.get('parameters.recipient.example'),
        required: false

      parameter name: :identifiant,
        in: :query,
        type: SwaggerData.get('france_travail.commons.parameters.identifiant.type'),
        description: SwaggerData.get('france_travail.commons.parameters.identifiant.description'),
        example: SwaggerData.get('france_travail.commons.parameters.identifiant.example'),
        required: SwaggerData.get('france_travail.commons.parameters.identifiant.required')

      # rubocop:disable RSpec/VariableName
      let(:'X-Api-Key') { x_api_key }
      # rubocop:enable RSpec/VariableName

      let(:identifiant) { 'whatever' }

      let(:x_api_key) { nil }
      let(:scopes) { nil }

      describe 'with valid token and mandatory params', vcr: { cassette_name: 'france_travail/oauth2' } do
        let(:x_api_key) { TokenFactory.new(scopes).valid }
        let(:scopes) { %w[pole_emploi_paiements] }

        before do
          stub_france_travail_indemnites_valid(identifiant:)
        end

        response '200', 'Paiements trouvées' do
          description SwaggerData.get('france_travail.indemnites.description')

          schema build_rswag_response_api_particulier_v2(
            attributes: SwaggerData.get('france_travail.indemnites.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          before do
            stub_france_travail_indemnites_not_found(identifiant:)
          end

          response '400', 'Paramètre(s) invalide(s)' do
            let(:identifiant) { nil }

            build_rswag_example(UnprocessableEntityError.new(:identifiant))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '404', 'Non trouvée' do
            let(:sexe) { 'f' }

            build_rswag_example(NotFoundError.new('France Travail', 'Aucune situation France Travail n\'a pu être trouvée avec les critères de recherche fournis'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '503', 'Erreur du fournisseur' do
            provider_unknown_error = ProviderUnknownError.new('France Travail')

            stubbed_organizer_error(
              FranceTravail::Indemnites,
              provider_unknown_error
            )

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(provider_unknown_error, :unknown_error)

            run_test!
          end

          response '504', 'Erreur d\'intermédiaire' do
            schema '$ref' => '#/components/schemas/Error'

            provider_timeout_error = ProviderTimeoutError.new('France Travail')

            stubbed_organizer_error(
              FranceTravail::Indemnites,
              provider_timeout_error
            )

            run_test!
          end
        end
      end
    end
  end
end
