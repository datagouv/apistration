require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/openapi-editor.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Éditeur — API Entreprise',
        version: 'v1',
        description: <<~DESC
          API destinée aux SaaS éditeurs intégrant API Entreprise via le système
          de délégation. Permet à un éditeur authentifié par token éditeur de
          récupérer la liste de ses délégations, puis de mapper `siret → id`
          pour passer `X-Delegation-Id` lors des appels métier vers
          `entreprise.api.gouv.fr`.
        DESC
      },
      paths: {},
      components: {
        securitySchemes: {
          bearer_editor_token: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT',
            description: "JWT éditeur (cf. dashboard éditeur > onglet 'Jetons de délégation')."
          }
        },
        schemas: {
          Delegation: {
            type: :object,
            required: %w[id authorization_request_id siret intitule scopes statut created_at],
            properties: {
              id: {
                type: :string, format: :uuid,
                description: "Identifiant unique de la délégation (UUID). À passer dans l'en-tête `X-Delegation-Id` sur les appels métier.",
                example: '0d3e1c40-66cb-4d54-9c44-5b53d1c1de5d'
              },
              authorization_request_id: {
                type: :integer,
                description: 'Identifiant DataPass de la demande d’habilitation associée.',
                example: 1234
              },
              siret: {
                type: :string,
                description: "SIRET de l'administration cliente.",
                example: '13002526500013'
              },
              intitule: {
                type: :string,
                description: "Intitulé fonctionnel de l'habilitation tel que renseigné dans DataPass."
              },
              scopes: {
                type: :array,
                items: { type: :string },
                description: 'Liste des scopes API techniquement accessibles via cette délégation.'
              },
              statut: {
                type: :string,
                enum: %w[active revoked],
                description: 'Statut courant de la délégation.'
              },
              created_at: {
                type: :string, format: 'date-time',
                description: 'Date de création de la délégation (ISO 8601 UTC).'
              }
            }
          },
          PaginationMeta: {
            type: :object,
            properties: {
              page: { type: :integer, example: 1 },
              per_page: { type: :integer, example: 50 },
              total: { type: :integer, example: 137 },
              total_pages: { type: :integer, example: 3 }
            }
          },
          UnauthorizedError: {
            type: :object,
            properties: {
              error: { type: :string, example: 'Unauthorized' }
            }
          }
        }
      },
      servers: [
        { url: 'https://entreprise.api.gouv.fr', description: 'Production — API Entreprise' },
        { url: 'https://particulier.api.gouv.fr', description: 'Production — API Particulier' }
      ]
    }
  }

  config.openapi_format = :yaml
end
