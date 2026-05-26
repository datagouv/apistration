require 'swagger_helper'

RSpec.describe 'Délégations éditeur' do
  let(:editor) { create(:editor, :delegable) }
  let(:editor_token) { create(:editor_token, editor:) }

  before { host! 'entreprise.api.gouv.fr' }

  path '/editeur/api/v1/delegations' do
    get 'Lister les délégations de l’éditeur' do
      tags 'Délégations'
      produces 'application/json'
      security [{ bearer_editor_token: [] }]
      description <<~DESC
        Renvoie la liste des délégations dont dispose l'éditeur authentifié
        sur l'API courante (entreprise ou particulier, déterminée par le
        host appelé). Inclut les délégations actives et révoquées.
      DESC

      parameter name: :page, in: :query, schema: { type: :integer, minimum: 1 }, required: false,
        description: 'Page courante (défaut 1).'
      parameter name: :per_page, in: :query, schema: { type: :integer, minimum: 1, maximum: 100 }, required: false,
        description: 'Nombre d’entrées par page (défaut 50, max 100).'

      response '200', 'Liste des délégations' do
        schema type: :object,
          required: %w[data meta],
          properties: {
            data: { type: :array, items: { '$ref' => '#/components/schemas/Delegation' } },
            meta: { '$ref' => '#/components/schemas/PaginationMeta' }
          }

        let(:Authorization) { "Bearer #{editor_token.rehash}" }
        let(:page) { nil }
        let(:per_page) { nil }

        before do
          create(:editor_delegation, editor:,
            authorization_request: create(:authorization_request, :validated,
              api: 'entreprise', external_id: '1001',
              siret: '13002526500013', intitule: 'Délégation exemple',
              scopes: %w[unites_legales_etablissements_insee]))
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.fetch('data').size).to eq(1)
          expect(body.fetch('data').first).to include(
            'siret' => '13002526500013',
            'statut' => 'active'
          )
          expect(body.fetch('meta')).to include('total' => 1)
        end
      end

      response '401', 'Token éditeur manquant' do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }
        let(:page) { nil }
        let(:per_page) { nil }

        run_test!
      end

      response '401', 'Token éditeur invalide' do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { 'Bearer not-a-valid-jwt' }
        let(:page) { nil }
        let(:per_page) { nil }

        run_test!
      end
    end
  end
end
