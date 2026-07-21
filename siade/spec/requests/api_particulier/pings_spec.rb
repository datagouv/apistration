require 'swagger_helper'

RSpec.describe 'Pings fournisseurs', api: :particulier, type: %i[request swagger] do
  path '/api/pings' do
    get 'Liste des pings fournisseurs disponibles' do
      tags 'Disponibilité'
      description "Retourne la liste des fournisseurs disposant d'un endpoint de ping, avec leur nom et l'URL du ping associé.\n\nCet endpoint **ne nécessite pas d'authentification**."
      security []
      produces 'application/json'

      response '200', 'Liste des pings fournisseurs' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              name: {
                type: :string,
                description: 'Nom du fournisseur sur la page de statut',
                example: 'CNAV - Quotient familial'
              },
              url: {
                type: :string,
                description: 'URL du ping fournisseur',
                example: 'https://particulier.api.gouv.fr/api/cnaf_msa_quotient_familial/ping'
              }
            },
            required: %w[name url]
          }

        run_test!
      end
    end
  end

  path '/api/{provider}/ping' do
    get "Ping d'un fournisseur de données" do
      tags 'Disponibilité'
      description "Vérifie la disponibilité d'un fournisseur de données spécifique. Retourne le statut du fournisseur ainsi que la date de dernière vérification.\n\nCet endpoint **ne nécessite pas d'authentification**."
      security []
      produces 'application/json'

      parameter name: :provider,
        in: :path,
        type: :string,
        required: true,
        description: 'Identifiant du fournisseur (tel que retourné par `/api/pings`)',
        example: 'cnaf_msa_quotient_familial'

      response '200', 'Le fournisseur est disponible' do
        schema type: :object,
          properties: {
            status: {
              type: :string,
              enum: %w[ok maintenance unknown],
              description: 'Statut du fournisseur'
            },
            last_update: {
              type: :string,
              format: 'date-time',
              description: 'Date de la dernière vérification'
            },
            last_ok_status: {
              type: :string,
              format: 'date-time',
              description: 'Date du dernier statut OK connu'
            },
            until: {
              type: :string,
              format: 'date-time',
              description: 'Date de fin de maintenance (uniquement si status=maintenance)'
            }
          }

        let(:provider) { 'cnaf_msa_quotient_familial' }

        before do
          allow(AccessLogPingView).to receive(:where).and_return(AccessLogPingView.none)
        end

        run_test!
      end

      response '404', 'Fournisseur inconnu' do
        let(:provider) { 'unknown_provider' }

        run_test!
      end
    end
  end
end
