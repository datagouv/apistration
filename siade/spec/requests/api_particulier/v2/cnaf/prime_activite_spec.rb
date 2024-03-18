require 'swagger_helper'

RSpec.describe "CNAF: Prime d'activité", api: :particulier, type: %i[request swagger] do
  path '/api/v2/prime-activite' do
    get SwaggerData.get('cnaf.prime_activite.title') do
      tags(*SwaggerData.get('cnaf.prime_activite.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :recipient,
        in: :query,
        type: :string,
        description: SwaggerData.get('parameters.recipient_FC.description'),
        example: SwaggerData.get('parameters.recipient_FC.example'),
        required: false

      security [franceConnectToken: [], apiKey: []]

      parameter name: :nomUsage,
        in: :query,
        type: SwaggerData.get('cnaf.prime_activite.parameters.nomUsage.type'),
        description: SwaggerData.get('cnaf.prime_activite.parameters.nomUsage.description'),
        example: SwaggerData.get('cnaf.prime_activite.parameters.nomUsage.example'),
        required: false

      parameter name: :nomNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.prime_activite.parameters.nomNaissance.type'),
        description: SwaggerData.get('cnaf.prime_activite.parameters.nomNaissance.description'),
        example: SwaggerData.get('cnaf.prime_activite.parameters.nomNaissance.example'),
        required: false

      parameter name: :'prenoms[]',
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.prime_activite.parameters.prenoms.type'),
          minItems: SwaggerData.get('cnaf.prime_activite.parameters.prenoms.minItems'),
          items: { type: :string },
          example: SwaggerData.get('cnaf.prime_activite.parameters.prenoms.example')
        },
        description: SwaggerData.get('cnaf.prime_activite.parameters.prenoms.description'),
        required: false

      parameter name: :anneeDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.prime_activite.parameters.anneeDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.prime_activite.parameters.anneeDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.prime_activite.parameters.anneeDateDeNaissance.example'),
        required: false

      parameter name: :moisDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.prime_activite.parameters.moisDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.prime_activite.parameters.moisDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.prime_activite.parameters.moisDateDeNaissance.example'),
        required: false

      parameter name: :jourDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.prime_activite.parameters.jourDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.prime_activite.parameters.jourDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.prime_activite.parameters.jourDateDeNaissance.example'),
        required: false

      parameter name: :codeInseeLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.prime_activite.parameters.codeInseeLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.prime_activite.parameters.codeInseeLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.prime_activite.parameters.codeInseeLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.prime_activite.parameters.codeInseeLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.prime_activite.parameters.codeInseeLieuDeNaissance.description'),
        required: false

      parameter name: :codePaysLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.prime_activite.parameters.codePaysLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.prime_activite.parameters.codePaysLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.prime_activite.parameters.codePaysLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.prime_activite.parameters.codePaysLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.prime_activite.parameters.codePaysLieuDeNaissance.description'),
        required: false

      parameter name: :sexe,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.prime_activite.parameters.sexe.type'),
          enum: SwaggerData.get('cnaf.prime_activite.parameters.sexe.enum')
        },
        description: SwaggerData.get('cnaf.prime_activite.parameters.sexe.description'),
        example: SwaggerData.get('cnaf.prime_activite.parameters.sexe.example'),
        required: false

      let(:scopes) { %i[prime_activite] }

      before do
        stub_cnaf_authenticate('prime_activite')
      end

      describe 'without a FranceConnect token' do
        before do
          stub_cnaf_valid('prime_activite', siret: '10000000000008')
        end

        let(:Authorization) { nil }
        let(:'X-Api-Key') { TokenFactory.new(scopes).valid }

        let(:nomNaissance) { 'CHAMPION' }
        let(:'prenoms[]') { %w[JEAN-PASCAL] }
        let(:sexe) { 'M' }
        let(:anneeDateDeNaissance) { 1980 }
        let(:moisDateDeNaissance) { 6 }
        let(:jourDateDeNaissance) { 12 }
        let(:codePaysLieuDeNaissance) { '99100' }
        let(:codeInseeLieuDeNaissance) { '17300' }

        describe 'with valid token and mandatory params' do
          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnaf.prime_activite.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnaf.prime_activite.attributes')
            )

            run_test!
          end
        end

        describe 'server errors' do
          response '400', 'Mauvais paramètres d\'appels' do
            let(:sexe) { 'nope' }

            build_rswag_example(UnprocessableEntityError.new(:gender), :unprocessable_entity_error_gender_error)

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '404', 'Dossier non trouvé' do
            before do
              stub_cnaf_404('prime_activite')
            end

            let(:codePaysLieuDeNaissance) { '99623' }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '503', 'Erreur du fournisseur' do
            provider_unknown_error = ProviderUnknownError.new('CNAF')

            stubbed_organizer_error(
              CNAF::PrimeActivite,
              provider_unknown_error
            )

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(provider_unknown_error, :unknown_error)

            run_test!
          end

          response '504', 'Erreur d\'intermédiaire' do
            schema '$ref' => '#/components/schemas/Error'

            provider_timeout_error = ProviderTimeoutError.new('CNAF')

            stubbed_organizer_error(
              CNAF::PrimeActivite,
              provider_timeout_error
            )

            run_test!
          end
        end
      end

      describe 'with a FranceConnect token' do
        let(:scopes) { %i[prime_activite openid identite_pivot] }
        let(:recipient) { valid_siret(:recipient) }

        describe 'with no token and valid FranceConnect token' do
          let(:'X-Api-Key') { nil }
          let(:Authorization) { 'Bearer super_valid_token' }

          before do
            mock_valid_france_connect_checktoken(scopes:)
            stub_cnaf_valid_with_franceconnect_data('prime_activite', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnaf.prime_activite.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnaf.prime_activite.attributes')
            )

            run_test!
          end
        end

        describe 'with valid token and invalid FranceConnect token' do
          let(:Authorization) { 'Bearer InvalidFranceConnectToken' }
          let(:'X-Api-Key') { TokenFactory.new(scopes).valid }

          before do
            mock_invalid_france_connect_checktoken
          end

          response '401', 'Unauthorized' do
            build_rswag_example(InvalidFranceConnectAccessTokenError.new(:not_found_or_expired))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'with valid token and valid FranceConnect token' do
          let(:'X-Api-Key') { TokenFactory.new(scopes).valid }
          let(:Authorization) { 'Bearer super_valid_token' }

          before do
            mock_valid_france_connect_checktoken(scopes:)
            stub_cnaf_valid_with_franceconnect_data('prime_activite', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnaf.prime_activite.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnaf.prime_activite.attributes')
            )

            run_test!
          end
        end
      end
    end
  end
end
