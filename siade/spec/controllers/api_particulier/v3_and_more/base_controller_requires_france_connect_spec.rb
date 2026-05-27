# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::V3AndMore::BaseController, 'requires france connect' do
  controller(described_class) do
    include APIParticulier::RequiresFranceConnect

    def show
      render json: france_connect_service_user_identity.to_h, status: :ok
    end
  end

  subject(:make_call) do
    routes.draw { get 'show' => 'api_particulier/v3_and_more/base#show' }

    request.headers['Authorization'] = authorization if authorization

    get :show, params: { recipient:, api_version: 3, token: yes_jwt }
  end

  let(:recipient) { valid_siret(:recipient) }
  let(:authorization) { 'Bearer fc_pivot_token' }

  before do
    allow(Siade.credentials).to receive(:[]).and_call_original
    allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_base_client_id).and_return('345')
    allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_base_client_secret).and_return('345')

    allow(controller).to receive(:verify_api_version!).and_return(true)
  end

  context 'when no FranceConnect bearer token is provided (only API token via query string)' do
    let(:authorization) { nil }

    it 'rejects the request with 401' do
      expect(make_call.status).to eq(401)
    end

    it 'returns the missing FranceConnect token error code' do
      body = JSON.parse(make_call.body)

      expect(body.dig('errors', 0, 'code')).to eq('50004')
    end

    it 'does not raise NoMethodError when reading the FC identity' do
      expect { make_call }.not_to raise_error
    end
  end

  context 'when a valid FranceConnect bearer token is provided' do
    before do
      mock_valid_france_connect_checktoken(scopes: %w[openid identite_pivot allowed_scope])
    end

    it 'allows the request through' do
      expect(make_call.status).to eq(200)
    end
  end
end
