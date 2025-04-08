require 'swagger_helper'

RSpec.describe 'CNAV: Quotient Familial V2', api: :particulierv2, type: %i[request swagger] do
  path '/api/v2/composition-familiale-v2' do
    get SwaggerData.get('cnav.v2.quotient-familial-v2.title') do
      deprecated true

      tags(*SwaggerData.get('cnav.v2.quotient-familial-v2.tags'))

      cacheable_request

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :recipient,
        in: :query,
        type: :string,
        description: SwaggerData.get('parameters.recipient_FC.description'),
        example: SwaggerData.get('parameters.recipient_FC.example'),
        required: false

      security [franceConnectToken: [], apiKey: []]

      parameters_cnav_identite_pivot_v2

      parameter name: :annee,
        in: :query,
        type: SwaggerData.get('cnav.v2.quotient-familial-v2.parameters.annee.type'),
        description: SwaggerData.get('cnav.v2.quotient-familial-v2.parameters.annee.description'),
        example: SwaggerData.get('cnav.v2.quotient-familial-v2.parameters.annee.example'),
        required: false

      parameter name: :mois,
        in: :query,
        type: SwaggerData.get('cnav.v2.quotient-familial-v2.parameters.mois.type'),
        description: SwaggerData.get('cnav.v2.quotient-familial-v2.parameters.mois.description'),
        example: SwaggerData.get('cnav.v2.quotient-familial-v2.parameters.mois.example'),
        required: false

      let(:scopes) { %i[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse] }

      before do
        stub_cnav_authenticate('quotient_familial_v2')
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
        let(:mois) { 12 }
        let(:annee) { 2023 }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              examples: {
                example.metadata[:example_group][:description] => {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
        end

        context 'with code insee lieu de naissance' do
          let(:codeInseeLieuDeNaissance) { '17300' }

          before do
            stub_cnav_valid('quotient_familial_v2', siret: '13002526500013')
          end

          describe 'with valid token and mandatory params' do
            response '200', 'Quotient Familial trouvée' do
              description SwaggerData.get('cnav.v2.quotient-familial-v2.description')

              cacheable_response(extra_description: SwaggerData.get('cnav.v2.quotient-familial-v2.cache_duration'))

              schema build_rswag_response_api_particulier_v2(
                attributes: SwaggerData.get('cnav.v2.quotient-familial-v2.attributes')
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

            describe 'with invalid time period asked' do
              # rubocop:disable RSpec/ContextWording
              response '400', 'Mauvais paramètres d\'appels' do
                context 'Mois invalide' do
                  let(:annee) { Time.zone.now.year + 1 }

                  build_rswag_example(UnprocessableEntityError.new(:annee))

                  schema '$ref' => '#/components/schemas/Error'

                  run_test!
                end

                context 'Allocataire non identifié' do
                  before do
                    stub_sngi_404('quotient_familial_v2')
                  end

                  build_rswag_example(NotFoundError.new('CNAF & MSA', "Les paramètres fournis ne permettent pas d'identifier un allocataire."))

                  schema '$ref' => '#/components/schemas/Error'

                  run_test!
                end
              end
              # rubocop:enable RSpec/ContextWording
            end

            response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
              let(:codePaysLieuDeNaissance) { '99623' }
              # rubocop:disable RSpec/ContextWording
              context 'Dossier non trouvé MSA' do
                before do
                  stub_cnav_404('quotient_familial_v2', 'MSA')
                end

                build_rswag_example(NotFoundError.new('CNAF & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la MSA."))

                schema '$ref' => '#/components/schemas/Error'

                run_test!
              end

              context 'Dossier non trouvé CNAF' do
                before do
                  stub_cnav_404('quotient_familial_v2', 'CNAF')
                end

                build_rswag_example(NotFoundError.new('CNAF & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."))

                schema '$ref' => '#/components/schemas/Error'

                run_test!
              end

              context 'Allocataire non référencé' do
                before do
                  stub_rncps_404('quotient_familial_v2')
                end

                build_rswag_example(NotFoundError.new('CNAF & MSA', "L'allocataire n'est pas référencé auprès de la CNAF ni de la MSA"))

                schema '$ref' => '#/components/schemas/Error'

                run_test!
              end

              context 'Erreur inattendue' do
                before do
                  stub_cnav_404('quotient_familial_v2')
                end

                build_rswag_example(NotFoundError.new('CNAF & MSA', 'Une erreur inattendue est survenue lors de la collecte des données', title: 'Erreur inattendue', with_identifiant_message: false))

                schema '$ref' => '#/components/schemas/Error'

                run_test!
              end
              # rubocop:enable RSpec/ContextWording
            end

            response '503', 'Erreur du fournisseur' do
              # rubocop:disable RSpec/ContextWording
              context 'Erreur inconnue du fournisseur de donnéé' do
                provider_unknown_error = ProviderUnknownError.new('CNAV')

                stubbed_organizer_error(
                  CNAV::QuotientFamilialV2,
                  provider_unknown_error
                )

                schema '$ref' => '#/components/schemas/Error'

                build_rswag_example(provider_unknown_error, :unknown_error)

                run_test!
              end

              context 'Erreur de fournisseur de donnée : Trop de requêtes effectuées, veuillez réessayer plus tard.' do
                provider_unknown_error = ProviderUnknownError.new('CNAV')

                stubbed_organizer_error(
                  CNAV::QuotientFamilialV2,
                  provider_unknown_error
                )

                schema '$ref' => '#/components/schemas/Error'

                build_rswag_example(provider_unknown_error, 'Erreur de fournisseur de donnée : Trop de requêtes effectuées, veuillez réessayer plus tard.')

                run_test!
              end
              # rubocop:enable RSpec/ContextWording
            end

            response '504', 'Erreur d\'intermédiaire' do
              schema '$ref' => '#/components/schemas/Error'

              provider_timeout_error = ProviderTimeoutError.new('CNAV')

              stubbed_organizer_error(
                CNAV::QuotientFamilialV2,
                provider_timeout_error
              )

              run_test!
            end
          end
        end
      end

      describe 'with a FranceConnect token' do
        let(:Authorization) { 'Bearer france_connect_token' }
        let(:scopes) { %i[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse openid identite_pivot] }
        let(:recipient) { valid_siret(:recipient) }

        describe 'with valid token and valid FranceConnect token' do
          let(:'X-Api-Key') { TokenFactory.new(scopes).valid }

          before do
            mock_valid_france_connect_checktoken(scopes:)
            stub_cnav_valid_with_franceconnect_data('quotient_familial_v2', siret: recipient)
          end

          response '200', 'Quotient Familial trouvé' do
            description SwaggerData.get('cnav.v2.quotient-familial-v2.description')

            schema build_rswag_response_api_particulier_v2(
              attributes: SwaggerData.get('cnav.v2.quotient-familial-v2.attributes')
            )

            run_test!
          end
        end

        describe 'with invalid token and valid FranceConnect token' do
          let(:'X-Api-Key') { nil }

          before do
            mock_valid_france_connect_checktoken(scopes:)
            stub_cnav_valid_with_franceconnect_data('quotient_familial_v2', siret: recipient)
          end

          response '200', 'Quotient Familial trouvé' do
            description SwaggerData.get('cnav.v2.quotient-familial-v2.description')

            schema build_rswag_response_api_particulier_v2(
              attributes: SwaggerData.get('cnav.v2.quotient-familial-v2.attributes')
            )

            run_test!
          end
        end

        describe 'with valid token and invalid FranceConnect token' do
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
      end
    end
  end
end
