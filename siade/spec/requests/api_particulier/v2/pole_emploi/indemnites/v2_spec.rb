require 'swagger_helper'

RSpec.describe 'MEN: Scolarites', api: :particulierv2, type: %i[request swagger] do
  path '/api/v2/paiements-pole-emploi' do
    get SwaggerData.get('pole_emploi.indemnites.title') do
      tags(*SwaggerData.get('pole_emploi.indemnites.tags'))

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
        type: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.type'),
        description: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.description'),
        example: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.example'),
        required: SwaggerData.get('pole_emploi.indemnites.parameters.identifiant.required')

      # rubocop:disable RSpec/VariableName
      let(:'X-Api-Key') { x_api_key }
      # rubocop:enable RSpec/VariableName

      let(:identifiant) { 'whatever' }

      let(:x_api_key) { nil }
      let(:scopes) { nil }

      describe 'with valid token and mandatory params', vcr: { cassette_name: 'pole_emploi/oauth2' } do
        let(:x_api_key) { TokenFactory.new(scopes).valid }
        let(:scopes) { %w[men_statut_scolarite men_statut_boursier men_echelon_bourse] }

        before do
          stub_request(:get, "#{Siade.credentials[:pole_emploi_indemnites_url]}?loginMnemotechnique=#{identifiant}")
            .to_return(
              status: 200,
              body: read_payload_file('pole_emploi/indemnites/valid.json')
            )
        end

        response '200', 'Paiements trouvées' do
          description SwaggerData.get('pole_emploi.indemnites.description')

          schema build_rswag_response_api_particulier(
            attributes: SwaggerData.get('pole_emploi.indemnites.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          before do
            stub_request(:get, "#{Siade.credentials[:pole_emploi_indemnites_url]}?loginMnemotechnique=#{identifiant}")
              .to_return(
                status: 204
              )
          end

          response '400', 'Paramètre(s) invalide(s)' do
            let(:identifiant) { nil }

            build_rswag_example(UnprocessableEntityError.new(:identifiant_pole_emploi))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '404', 'Non trouvée' do
            let(:sexe) { 'f' }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '503', 'Erreur du fournisseur' do
            provider_unknown_error = ProviderUnknownError.new('France Travail')

            stubbed_organizer_error(
              PoleEmploi::Indemnites,
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
              PoleEmploi::Indemnites,
              provider_timeout_error
            )

            run_test!
          end
        end
      end
    end
  end
end
