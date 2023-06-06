require 'swagger_helper'

RSpec.describe 'CNAF: Complementaire Santé Solidaire', api: :particulier, type: %i[request swagger] do
  path '/api/v2/complementaire-sante-solidaire' do
    get SwaggerData.get('cnaf.c2s.title') do
      tags(*SwaggerData.get('cnaf.c2s.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :nomUsage,
        in: :query,
        type: :string,
        description: "Nom d'usage",
        example: 'DUPONT',
        required: false

      parameter name: :nomNaissance,
        in: :query,
        type: :string,
        description: 'Nom de naissance',
        example: 'MARTIN',
        required: false

      parameter name: :prenoms,
        in: :query,
        schema: {
          type: :array,
          minItems: 1,
          items: { type: :string },
          example: %w[MARTIN PIERRE]
        },
        description: 'Liste des prénoms',
        required: false

      parameter name: :anneeDateDeNaissance,
        in: :query,
        type: :integer,
        description: 'Année de naissance. Ne pas la renseigner si celle-ci est inconnue',
        required: false,
        example: 1990

      parameter name: :moisDateDeNaissance,
        in: :query,
        type: :integer,
        description: 'Mois de naissance. Ne pas le renseigner si celui-ci est inconnu. Cette valeur est ignorée si anneeDateDeNaissance est vide.',
        required: false,
        example: 1

      parameter name: :jourDateDeNaissance,
        in: :query,
        type: :integer,
        description: 'Jour de naissance. Ne pas le renseigner si celui-ci est inconnu. Cette valeur est ignorée si moisDateDeNaissance ou anneeDateDeNaissance est vide.',
        required: false,
        example: 1

      parameter name: :codeInseeLieuDeNaissance,
        in: :query,
        type: :string,
        example: '08480',
        description: "Code Insee à 5 chiffres du lieu de naissance de la personne sur 5 chiffres. Ne pas remplir si la personne est née à l'étranger.",
        required: false

      parameter name: :codePaysLieuDeNaissance,
        in: :query,
        type: :string,
        description: 'Code Insee à 5 chiffres du pays de naissance (France = 99100)',
        example: '99100',
        required: true

      parameter name: :sexe,
        in: :query,
        description: 'Sexe de la personne, masculin ou féminin',
        required: true,
        type: :string,
        example: 'F'

      # rubocop:disable RSpec/VariableName
      let(:'X-Api-Key') { x_api_key }

      let(:nomUsage) { 'DUPONT' }
      let(:nomNaissance) { 'DUPOND' }
      let(:prenoms) { %w[Anne Marie Jacqueline] }
      let(:anneeDateDeNaissance) { 1970 }
      let(:moisDateDeNaissance) { 8 }
      let(:jourDateDeNaissance) { 16 }
      let(:codeInseeLieuDeNaissance) { '08480' }
      let(:codePaysLieuDeNaissance) { '99100' }
      let(:sexe) { 'F' }
      # rubocop:enable RSpec/VariableName

      let(:x_api_key) { nil }
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
        let(:x_api_key) { TokenFactory.new(scopes).valid }
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
        let(:x_api_key) { TokenFactory.new(scopes).valid }
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
