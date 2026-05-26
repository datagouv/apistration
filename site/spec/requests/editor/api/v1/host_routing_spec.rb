require 'rails_helper'

RSpec.describe 'Editor API host routing' do
  let(:endpoint) { '/editeur/api/v1/delegations' }
  let(:editor) { create(:editor, :delegable) }
  let(:editor_token) { create(:editor_token, editor:) }
  let(:headers) { { 'Authorization' => "Bearer #{editor_token.rehash}" } }

  context 'when called on the entreprise host' do
    before { host! 'entreprise.api.localtest.me' }

    it 'reaches the controller (200 with a valid token)' do
      get endpoint, headers: headers

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when called on the particulier host' do
    before { host! 'particulier.api.localtest.me' }

    it 'reaches the controller (200 with a valid token)' do
      get endpoint, headers: headers

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when called on the production entreprise host' do
    before { host! 'entreprise.api.gouv.fr' }

    it 'reaches the controller' do
      get endpoint, headers: headers

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when called on the production particulier host' do
    before { host! 'particulier.api.gouv.fr' }

    it 'reaches the controller' do
      get endpoint, headers: headers

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when called on a host that is not entreprise/particulier' do
    before { host! 'dashboard.example.com' }

    it 'does not match the route — auth never runs' do
      expect { get endpoint, headers: headers }.to raise_error(ActionController::RoutingError)
    end
  end

  context 'when called on a host that just contains the word entreprise' do
    before { host! 'evil-entreprise.example.com' }

    it 'does not match the route' do
      expect { get endpoint, headers: headers }.to raise_error(ActionController::RoutingError)
    end
  end

  context 'when the editor has delegations on both APIs' do
    let!(:entreprise_delegation) do
      create(:editor_delegation, editor:,
        authorization_request: create(:authorization_request, :validated,
          api: 'entreprise', external_id: '1001'))
    end
    let!(:particulier_delegation) do
      create(:editor_delegation, editor:,
        authorization_request: create(:authorization_request, :validated,
          api: 'particulier', external_id: '2001'))
    end

    it 'only returns entreprise delegations when called on the entreprise host' do
      host! 'entreprise.api.localtest.me'

      get endpoint, headers: headers

      ids = response.parsed_body.fetch('data').pluck('id')
      expect(ids).to contain_exactly(entreprise_delegation.id)
    end

    it 'only returns particulier delegations when called on the particulier host' do
      host! 'particulier.api.localtest.me'

      get endpoint, headers: headers

      ids = response.parsed_body.fetch('data').pluck('id')
      expect(ids).to contain_exactly(particulier_delegation.id)
    end
  end
end
