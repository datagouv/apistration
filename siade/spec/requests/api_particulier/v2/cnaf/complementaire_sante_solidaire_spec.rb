require 'swagger_helper'

RSpec.describe 'CNAF: Complementaire Santé Solidaire', api: :particulier, type: %i[request swagger] do
  path '/api/v2/complementaire-sante-solidaire' do
    get SwaggerData.get('cnaf.c2s.title') do
      tags(*SwaggerData.get('cnaf.c2s.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :nomUsage,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.nomUsage.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.nomUsage.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.nomUsage.example'),
        required: false

      parameter name: :nomNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.nomNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.nomNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.nomNaissance.example'),
        required: false

      parameter name: :prenoms,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.prenoms.type'),
          minItems: SwaggerData.get('cnaf.c2s.parameters.prenoms.minItems'),
          items: { type: :string },
          example: SwaggerData.get('cnaf.c2s.parameters.prenoms.example')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.prenoms.description'),
        required: false

      parameter name: :anneeDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.anneeDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.anneeDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.anneeDateDeNaissance.example'),
        required: false

      parameter name: :moisDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.moisDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.moisDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.moisDateDeNaissance.example'),
        required: false

      parameter name: :jourDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.jourDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.jourDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.jourDateDeNaissance.example'),
        required: false

      parameter name: :codeInseeLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.description'),
        required: false

      parameter name: :codePaysLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.description'),
        required: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.required')

      parameter name: :sexe,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.sexe.type'),
          enum: SwaggerData.get('cnaf.c2s.parameters.sexe.enum')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.sexe.description'),
        required: SwaggerData.get('cnaf.c2s.parameters.sexe.required'),
        example: SwaggerData.get('cnaf.c2s.parameters.sexe.example')

      let(:'X-Api-Key') { TokenFactory.new(scopes).valid }

      let(:codePaysLieuDeNaissance) { '99100' }
      let(:sexe) { 'F' }

      let(:scopes) { nil }

      let(:mocked_data) do
        {
          status: 200,
          payload: {
            status: 'beneficiaire_avec_participation_financiere',
            dateDebut: '2022-02-01',
            dateFin: '2023-02-0'
          }
        }
      end

      before do
        allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
      end

      describe 'with valid token and mandatory params' do
        let(:scopes) { %w[] }

        context 'with all scopes' do
          response '200', 'Complementaire santé solidaire trouvée' do
            description SwaggerData.get('cnaf.c2s.description')

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnaf.c2s.attributes')
            )

            run_test!
          end
        end
      end

      describe 'server errors' do
        let(:scopes) { %w[] }

        response '400', 'Mauvais paramètres d\'appels' do
          let(:mocked_data) do
            {
              status: 400,
              payload: {
                error: 'bad_request',
                reason: 'Le codePaysLieuDeNaissance est manquant',
                message: 'Le codePaysLieuDeNaissance est manquant'
              }
            }
          end

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '401', 'Votre jeton d\'Api n\'a pas été trouvé ou n\'est pas actif' do
          let(:mocked_data) do
            {
              status: 401,
              payload: {
                error: 'access_denied',
                reason: 'Token not found or inactive',
                message: "Votre jeton d'API n'a pas été trouvé ou n'est pas actif"
              }
            }
          end

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
          let(:mocked_data) do
            {
              status: 404,
              payload: {
                error: 'not_found',
                reason: 'Dossier allocataire inexistant. Le document ne peut être édité.',
                message: 'Dossier allocataire inexistant. Le document ne peut être édité.'
              }
            }
          end

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '500', 'Une erreur interne s\'est produite, l\'équipe a été prévenue.' do
          let(:mocked_data) do
            {
              status: 500,
              payload: {
                error: 'error',
                reason: 'Internal server error',
                message: "Une erreur interne s'est produite, l'équipe a été prévenue."
              }
            }
          end

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '503', 'Une erreur est survenue lors de l\'appel au fournisseur de donnée' do
          provider_unknown_error = ProviderUnknownError.new('CNAF')

          let(:mocked_data) do
            {
              status: 503,
              payload: {
                error: 'network_error',
                reason: 'timeout of 10000 ms exceeded',
                message: 'Une erreur est survenue lors de l\'appel au fournisseur de donnée'
              }
            }
          end

          schema '$ref' => '#/components/schemas/Error'

          build_rswag_example(provider_unknown_error, :unknown_error)

          run_test!
        end
      end
    end
  end
end
