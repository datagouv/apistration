require 'rails_helper'

RSpec.describe 'Editor::API::V1::Delegations' do
  let(:endpoint) { '/editeur/api/v1/delegations' }
  let(:editor) { create(:editor, :delegable) }
  let(:editor_token) { create(:editor_token, editor:) }
  let(:headers) { { 'Authorization' => "Bearer #{editor_token.rehash}" } }

  before { host! 'entreprise.api.localtest.me' }

  describe 'GET /editeur/api/v1/delegations' do
    context 'when no Authorization header is provided' do
      it 'returns 401 with a JSON error' do
        get endpoint

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body).to eq('error' => 'Unauthorized')
      end
    end

    context 'when the Authorization header is malformed' do
      it 'returns 401 if the scheme is not Bearer' do
        get endpoint, headers: { 'Authorization' => 'Basic deadbeef' }

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 if the Bearer token is empty' do
        get endpoint, headers: { 'Authorization' => 'Bearer ' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the JWT is expired' do
      let(:editor_token) { create(:editor_token, :expired, editor:) }

      it 'returns 401' do
        get endpoint, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the EditorToken is blacklisted' do
      let(:editor_token) { create(:editor_token, :blacklisted, editor:) }

      it 'returns 401' do
        get endpoint, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the JWT belongs to a non-editor Token (admin)' do
      let(:authorization_request) { create(:authorization_request, :validated) }
      let(:admin_token) do
        Token.create!(
          Token.default_create_params.merge(
            authorization_request:,
            scopes: []
          )
        )
      end
      let(:headers) { { 'Authorization' => "Bearer #{admin_token.rehash}" } }

      it 'returns 401 — admin tokens must not authenticate against the editor API' do
        get endpoint, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when listing delegations' do
      let!(:active_delegation_a) do
        create(:editor_delegation, editor:,
          authorization_request: create(:authorization_request, :validated,
            api: 'entreprise',
            external_id: '1001',
            siret: '13002526500013',
            intitule: 'Délégation A',
            scopes: %w[unites_legales_etablissements_insee associations]),
          created_at: 2.days.ago)
      end
      let!(:active_delegation_b) do
        create(:editor_delegation, editor:,
          authorization_request: create(:authorization_request, :validated,
            api: 'entreprise',
            external_id: '1002',
            siret: '13002526500021',
            intitule: 'Délégation B',
            scopes: []),
          created_at: 1.day.ago)
      end
      let!(:revoked_delegation) do
        create(:editor_delegation, editor:, revoked_at: 1.hour.ago,
          authorization_request: create(:authorization_request, :validated,
            api: 'entreprise',
            external_id: '999',
            intitule: 'Révoquée'))
      end
      let!(:other_editor_delegation) do
        create(:editor_delegation,
          editor: create(:editor, :delegable, name: 'Other Editor'),
          authorization_request: create(:authorization_request, :validated,
            api: 'entreprise',
            external_id: '777'))
      end

      it 'returns all delegations of the current editor (active and revoked)' do
        get endpoint, headers: headers

        expect(response).to have_http_status(:ok)
        ids = response.parsed_body.fetch('data').pluck('id')
        expect(ids).to contain_exactly(
          active_delegation_a.id, active_delegation_b.id, revoked_delegation.id
        )
      end

      it 'does not leak delegations from other editors' do
        get endpoint, headers: headers

        ids = response.parsed_body.fetch('data').pluck('id')
        expect(ids).not_to include(other_editor_delegation.id)
      end

      it 'serializes each delegation with the expected fields and types' do
        get endpoint, headers: headers

        entry = response.parsed_body.fetch('data').find { |d| d['id'] == active_delegation_a.id }
        expect(entry).to include(
          'id' => active_delegation_a.id,
          'authorization_request_id' => 1001,
          'siret' => '13002526500013',
          'intitule' => 'Délégation A',
          'scopes' => %w[unites_legales_etablissements_insee associations],
          'statut' => 'active'
        )
        expect(entry['created_at']).to match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z\z/)
      end

      it 'marks revoked delegations with statut=revoked' do
        get endpoint, headers: headers

        entry = response.parsed_body.fetch('data').find { |d| d['id'] == revoked_delegation.id }
        expect(entry).to include('statut' => 'revoked')
      end
    end

    context 'when paginating' do
      before do
        51.times do |i|
          create(:editor_delegation, editor:,
            authorization_request: create(:authorization_request, :validated,
              api: 'entreprise', external_id: (10_000 + i).to_s),
            created_at: i.minutes.ago)
        end
      end

      it 'returns 50 entries per page by default with full meta block' do
        get endpoint, headers: headers

        body = response.parsed_body
        expect(body.fetch('data').size).to eq(50)
        expect(body.fetch('meta')).to eq(
          'page' => 1,
          'per_page' => 50,
          'total' => 51,
          'total_pages' => 2
        )
      end

      it 'returns the remaining entries on page 2' do
        get endpoint, params: { page: 2 }, headers: headers

        body = response.parsed_body
        expect(body.fetch('data').size).to eq(1)
        expect(body.fetch('meta')).to include('page' => 2, 'total_pages' => 2)
      end

      it 'caps per_page to 100 to avoid unbounded queries' do
        get endpoint, params: { per_page: 200 }, headers: headers

        body = response.parsed_body
        expect(body.fetch('data').size).to eq(51)
        expect(body.fetch('meta')).to include('per_page' => 100)
      end

      it 'accepts custom per_page within the cap' do
        get endpoint, params: { per_page: 10 }, headers: headers

        body = response.parsed_body
        expect(body.fetch('data').size).to eq(10)
        expect(body.fetch('meta')).to include('per_page' => 10, 'total_pages' => 6)
      end
    end
  end
end
