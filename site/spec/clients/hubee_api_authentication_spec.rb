RSpec.describe HubEEAPIAuthentication do
  describe '#access_token' do
    subject(:access_token) { described_class.new.access_token }

    let(:auth_url) { Rails.application.credentials.hubee_auth_url }

    before do
      stub_request(:post, auth_url)
        .with(body: 'grant_type=client_credentials&scope=DATAPASS')
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: { access_token: 'hubee_access_token' }.to_json
        )
    end

    it 'requests a token with the datapass scope' do
      expect(access_token).to eq('hubee_access_token')
    end
  end
end
