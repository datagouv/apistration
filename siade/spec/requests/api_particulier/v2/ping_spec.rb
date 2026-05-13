require 'swagger_helper'

RSpec.describe 'Ping', api: :particulierv2, type: %i[request swagger] do
  path '/api/ping' do
    get "Ping de l'API" do
      tags 'Disponibilité'
      description "Vérifie que l'API est accessible et fonctionnelle. Retourne un code HTTP 200 si l'API est opérationnelle.\n\nCet endpoint **ne nécessite pas d'authentification**."
      security []

      response '200', "L'API est opérationnelle" do
        run_test!
      end
    end
  end
end
