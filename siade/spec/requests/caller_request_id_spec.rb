require 'rails_helper'

RSpec.describe 'Request id supplied by the caller', api: :entreprise do
  subject(:make_request) do
    get "/v4/dgfip/unites_legales/#{siren}/attestation_fiscale",
      params: api_entreprise_mandatory_params,
      headers: { 'Authorization' => "Bearer #{yes_jwt}", 'X-Request-Id' => request_id }
  end

  let(:siren) { valid_siren }

  before do
    mock_dgfip_authenticate
    mock_valid_dgfip_attestation_fiscale(siren, valid_dgfip_user_id)
  end

  after { Rack::Attack.reset! }

  context 'when it is not an UUID' do
    let(:request_id) { 'client-123' }

    it 'is rejected before reaching the provider' do
      make_request

      expect(response).to have_http_status(:unprocessable_content)
      expect(response_json[:errors].first).to include(code: '00405')
    end
  end

  context 'when it is an UUID' do
    let(:request_id) { SecureRandom.uuid }

    it 'is forwarded to the provider' do
      make_request

      expect(response).to have_http_status(:ok)
      expect(
        a_request(:get, %r{/adelie/v1/attestationFiscale})
          .with(headers: { 'X-Correlation-ID' => request_id, 'X-Request-ID' => request_id })
      ).to have_been_made
    end
  end
end
