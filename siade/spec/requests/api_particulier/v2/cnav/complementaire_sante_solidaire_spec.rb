require 'swagger_helper'

RSpec.describe 'CNAV: Complementaire Santé Solidaire', api: :particulier, type: %i[request swagger] do
  path '/api/v2/complementaire-sante-solidaire' do
    get SwaggerData.get('cnav.c2s.title') do
      tags(*SwaggerData.get('cnav.c2s.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :recipient,
        in: :query,
        type: :string,
        description: SwaggerData.get('parameters.recipient_FC.description'),
        example: SwaggerData.get('parameters.recipient_FC.example'),
        required: false

      security [franceConnectToken: [], apiKey: []]

      parameters_cnav_identite_pivot

      parameter name: :nomCommuneNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnav.c2s.parameters.nomCommuneNaissance.type'),
          minLength: SwaggerData.get('cnav.c2s.parameters.nomCommuneNaissance.minLength'),
          example: SwaggerData.get('cnav.c2s.parameters.nomCommuneNaissance.example')
        },
        description: SwaggerData.get('cnav.c2s.parameters.nomCommuneNaissance.description'),
        required: false

      parameter name: :codeInseeDepartementNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnav.c2s.parameters.codeInseeDepartementNaissance.type'),
          minLength: SwaggerData.get('cnav.c2s.parameters.codeInseeDepartementNaissance.minLength'),
          maxLength: SwaggerData.get('cnav.c2s.parameters.codeInseeDepartementNaissance.maxLength'),
          example: SwaggerData.get('cnav.c2s.parameters.codeInseeDepartementNaissance.example')
        },
        description: SwaggerData.get('cnav.c2s.parameters.codeInseeDepartementNaissance.description'),
        required: false

      let(:scopes) { %i[complementaire_sante_solidaire] }

      before do
        stub_cnav_authenticate('complementaire_sante_solidaire')
      end

      describe 'without a FranceConnect token' do
        let(:Authorization) { nil }
        let(:'X-Api-Key') { TokenFactory.new(scopes).valid }

        let(:nomNaissance) { 'CHAMPION' }
        let(:'prenoms[]') { %w[JEAN-PASCAL] }
        let(:sexe) { 'M' }
        let(:anneeDateDeNaissance) { 1980 }
        let(:moisDateDeNaissance) { 6 }
        let(:jourDateDeNaissance) { 12 }
        let(:codePaysLieuDeNaissance) { '99100' }

        describe 'with transcogage params', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
          let(:codeInseeLieuDeNaissance) { nil }
          let(:nomCommuneNaissance) { 'Gennevilliers' }
          let(:codeInseeDepartementNaissance) { '92' }
          let(:anneeDateDeNaissance) { 2000 }

          before do
            stub_cnav_valid('complementaire_sante_solidaire', siret: '10000000000008', extra_params: { codeLieuNaissance: '92036', dateNaissance: '2000-06-12' })
          end

          describe 'with valid token and mandatory params' do
            response '200', 'Complémentaire Santé trouvée' do
              description SwaggerData.get('cnav.quotient-familial-v2.description')

              schema build_rswag_response_api_particulier(
                attributes: SwaggerData.get('cnav.quotient-familial-v2.attributes')
              )

              run_test!
            end
          end
        end

        context 'with code insee lieu de naissance' do
          let(:codeInseeLieuDeNaissance) { '17300' }

          before do
            stub_cnav_valid('complementaire_sante_solidaire', siret: '10000000000008')
          end

          describe 'with valid token and mandatory params' do
            response '200', 'Complémentaire Santé trouvée' do
              description SwaggerData.get('cnav.c2s.description')

              schema build_rswag_response_api_particulier(
                attributes: SwaggerData.get('cnav.c2s.attributes')
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

            response '404', 'Dossier complémentaire inexistant. Le document ne peut être édité.' do
              before do
                stub_cnav_404('complementaire_sante_solidaire')
              end

              let(:codePaysLieuDeNaissance) { '99623' }

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            response '503', 'Erreur du fournisseur' do
              provider_unknown_error = ProviderUnknownError.new('CNAV')

              stubbed_organizer_error(
                CNAV::ComplementaireSanteSolidaire,
                provider_unknown_error
              )

              schema '$ref' => '#/components/schemas/Error'

              build_rswag_example(provider_unknown_error, :unknown_error)

              run_test!
            end

            response '504', 'Erreur d\'intermédiaire' do
              schema '$ref' => '#/components/schemas/Error'

              provider_timeout_error = ProviderTimeoutError.new('CNAV')

              stubbed_organizer_error(
                CNAV::ComplementaireSanteSolidaire,
                provider_timeout_error
              )

              run_test!
            end
          end
        end
      end

      describe 'with a FranceConnect token' do
        let(:scopes) { %i[complementaire_sante_solidaire openid identite_pivot] }
        let(:recipient) { valid_siret(:recipient) }

        describe 'with no token and valid FranceConnect token' do
          let(:'X-Api-Key') { nil }
          let(:Authorization) { 'Bearer super_valid_token' }

          before do
            mock_valid_france_connect_checktoken(scopes:)
            stub_cnav_valid_with_franceconnect_data('complementaire_sante_solidaire', siret: recipient)
          end

          response '200', 'Quotient Familial trouvée' do
            description SwaggerData.get('cnav.c2s.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.c2s.attributes')
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
            stub_cnav_valid_with_franceconnect_data('complementaire_sante_solidaire', siret: recipient)
          end

          response '200', 'Quotient Familial trouvée' do
            description SwaggerData.get('cnav.c2s.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.c2s.attributes')
            )

            run_test!
          end
        end
      end
    end
  end
end
