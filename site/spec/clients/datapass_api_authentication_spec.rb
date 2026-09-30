RSpec.describe DatapassAPIAuthentication do
  include ActiveSupport::Testing::TimeHelpers

  subject(:authentication) { described_class.new }

  let(:url) { 'https://datapass.example.test/api/v1' }
  let(:token_url) { "#{url}/oauth/token" }

  before do
    stub_credential(:datapass_api, url:, client_id: 'datapass_client_id', client_secret: 'datapass_client_secret')
  end

  def stub_token_request(access_token: 'datapass_access_token', expires_in: 7200)
    stub_request(:post, token_url)
      .with(
        body: {
          grant_type: 'client_credentials',
          client_id: 'datapass_client_id',
          client_secret: 'datapass_client_secret',
          scope: 'read_authorizations write_authorizations'
        }
      )
      .to_return(
        status: 200,
        headers: { 'Content-Type' => 'application/json' },
        body: { access_token:, token_type: 'Bearer', expires_in:, created_at: 1_613_749_329, scope: 'read_authorizations write_authorizations' }.to_json
      )
  end

  describe '#access_token' do
    context 'when DataPass grants a token' do
      let!(:token_request) { stub_token_request }

      it 'returns the access token' do
        expect(authentication.access_token).to eq('datapass_access_token')
      end

      it 'reuses the token until it expires' do
        2.times { described_class.new.access_token }

        expect(token_request).to have_been_requested.once
      end

      it 'requests a new token once the previous one expired' do
        described_class.new.access_token

        travel_to(2.hours.from_now) { described_class.new.access_token }

        expect(token_request).to have_been_requested.twice
      end
    end

    context 'when DataPass does not tell when the token expires' do
      let!(:token_request) { stub_token_request(expires_in: nil) }

      it 'does not cache the token' do
        2.times { described_class.new.access_token }

        expect(token_request).to have_been_requested.twice
      end
    end

    context 'when DataPass rejects the client credentials' do
      before do
        stub_request(:post, token_url).to_return(
          status: 401,
          headers: { 'Content-Type' => 'application/json' },
          body: { error: 'invalid_client' }.to_json
        )
      end

      it 'raises an unauthorized error' do
        expect { authentication.access_token }.to raise_error(DatapassAPIClient::Unauthorized) do |error|
          expect(error.status).to eq(401)
        end
      end
    end
  end

  describe '.invalidate_token_cache!' do
    let!(:token_request) { stub_token_request }

    it 'forces the next call to request a new token' do
      described_class.new.access_token
      described_class.invalidate_token_cache!
      described_class.new.access_token

      expect(token_request).to have_been_requested.twice
    end
  end
end
