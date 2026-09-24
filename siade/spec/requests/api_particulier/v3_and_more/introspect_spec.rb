require 'swagger_helper'

RSpec.describe 'Introspection du jeton', api: :particulier, type: %i[request swagger] do
  path '/v3/token/introspect' do
    get 'Introspection du jeton' do
      tags 'Jeton'
      produces 'application/json'
      description "Décrit le jeton utilisé pour appeler cet endpoint : périmètres de données accordés, demande d'habilitation associée, dates d'émission et d'expiration.\n\nCet endpoint ne consomme aucun périmètre particulier : tout jeton valide peut l'appeler.\n\nIl remplace `/api/introspect`, qui ne renvoie que la liste des périmètres et reste disponible pour compatibilité."

      security [{ jwt_bearer_token: [] }]

      parameter name: :recipient,
        in: :query,
        type: :string,
        description: "SIRET de l'organisation pour laquelle un jeton éditeur souhaite décrire sa délégation. Sans effet pour les autres types de jetons.",
        example: '13002526500013',
        required: false

      delegation_id_action_attribute

      response '200', 'Description du jeton' do
        let(:Authorization) { "Bearer #{yes_jwt}" }

        schema build_rswag_introspection_response

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body.dig('data', 'id')).to be_present
          expect(body.dig('data', 'scopes')).to eq(Scope.all)
        end
      end

      unauthorized_request
    end
  end
end
