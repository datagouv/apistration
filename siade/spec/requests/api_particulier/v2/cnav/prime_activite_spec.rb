require 'swagger_helper'

RSpec.describe "CNAV: Prime d'activité", api: :particulierv2, type: %i[request swagger] do
  path '/api/v2/prime-activite' do
    get SwaggerData.get('cnav.v2.prime_activite.title') do
      tags(*SwaggerData.get('cnav.v2.prime_activite.tags'))

      produces 'application/json'

      cacheable_request

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :recipient,
        in: :query,
        type: :string,
        description: SwaggerData.get('parameters.recipient_FC.description'),
        example: SwaggerData.get('parameters.recipient_FC.example'),
        required: false

      security [franceConnectToken: [], apiKey: []]

      parameters_cnav_identite_pivot_v2

      let(:scopes) { %i[prime_activite] }

      before do
        stub_cnav_authenticate('prime_activite')
      end

      describe 'without a FranceConnect token' do
        before do
          stub_cnav_valid('prime_activite', siret: '13002526500013')
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
            description SwaggerData.get('cnav.v2.prime_activite.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.v2.commons.cache_duration'))

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.v2.prime_activite.attributes')
            )

            run_test!
          end
        end

        describe 'with transcogage params', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
          let(:codeInseeLieuDeNaissance) { nil }
          let(:nomCommuneNaissance) { 'Gennevilliers' }
          let(:codeInseeDepartementNaissance) { '92' }
          let(:anneeDateDeNaissance) { 2000 }

          before do
            stub_cnav_valid('prime_activite', siret: '13002526500013', extra_params: { codeLieuNaissance: '92036', dateNaissance: '2000-06-12' })
          end

          describe 'with valid token and mandatory params' do
            response '200', 'Prime activité trouvée' do
              description SwaggerData.get('cnav.v2.prime_activite.description')

              cacheable_response(extra_description: SwaggerData.get('cnav.v2.commons.cache_duration'))

              schema build_rswag_response_api_particulier(
                attributes: SwaggerData.get('cnav.v2.prime_activite.attributes')
              )

              run_test!
            end
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
              stub_cnav_404('prime_activite')
            end

            let(:codePaysLieuDeNaissance) { '99623' }

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '503', 'Erreur du fournisseur' do
            provider_unknown_error = ProviderUnknownError.new('CNAV')

            stubbed_organizer_error(
              CNAV::PrimeActivite,
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
              CNAV::PrimeActivite,
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
            stub_cnav_valid_with_franceconnect_data('prime_activite', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.v2.prime_activite.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.v2.commons.cache_duration'))

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.v2.prime_activite.attributes')
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
            stub_cnav_valid_with_franceconnect_data('prime_activite', siret: recipient)
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.v2.prime_activite.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.v2.commons.cache_duration'))

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.v2.prime_activite.attributes')
            )

            run_test!
          end
        end
      end
    end
  end
end
