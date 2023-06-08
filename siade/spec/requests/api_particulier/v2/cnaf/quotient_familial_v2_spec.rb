require 'swagger_helper'

RSpec.describe 'CNAF: Complementaire Santé Solidaire', api: :particulier, type: %i[request swagger] do
  path '/api/v2/composition-familiale-v2' do
    get SwaggerData.get('cnaf.quotient-familial-v2.title') do
      tags(*SwaggerData.get('cnaf.quotient-familial-v2.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :nomUsage,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomUsage.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomUsage.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomUsage.example'),
        required: false

      parameter name: :nomNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomNaissance.example'),
        required: false

      parameter name: :prenoms,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.type'),
          minItems: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.minItems'),
          items: { type: :string },
          example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.example')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.description'),
        required: false

      parameter name: :anneeDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.anneeDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.anneeDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.anneeDateDeNaissance.example'),
        required: false

      parameter name: :moisDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.moisDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.moisDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.moisDateDeNaissance.example'),
        required: false

      parameter name: :jourDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.jourDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.jourDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.jourDateDeNaissance.example'),
        required: false

      parameter name: :codeInseeLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.description'),
        required: false

      parameter name: :codePaysLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.description'),
        required: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.required')

      parameter name: :sexe,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.type'),
          enum: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.enum')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.description'),
        required: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.required'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.example')

      parameter name: :annee,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.annee.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.annee.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.annee.example'),
        required: false

      parameter name: :mois,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.mois.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.mois.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.mois.example'),
        required: false

      let(:'X-Api-Key') { TokenFactory.new(scopes).valid }

      let(:codePaysLieuDeNaissance) { '99100' }
      let(:sexe) { 'F' }

      let(:scopes) { %w[] }

      let(:mocked_data) do
        {
          status: 200,
          payload: {}
        }
      end

      before do
        allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
      end

      describe 'with valid token and mandatory params' do
        response '200', 'Complementaire santé solidaire trouvée' do
          description SwaggerData.get('cnaf.quotient-familial-v2.description')

          schema build_rswag_response_api_particulier(
            attributes: SwaggerData.get('cnaf.quotient-familial-v2.attributes')
          )

          run_test!
        end
      end

      describe 'server errors' do
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
