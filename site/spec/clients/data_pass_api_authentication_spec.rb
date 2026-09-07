RSpec.describe DataPassAPIAuthentication do
  describe '#access_token' do
    subject(:access_token) { described_class.new.access_token }

    let(:auth_url) { "#{DataPass::BASE_URL}/api/oauth/token" }

    before do
      allow(AdminApientreprise).to receive(:credentials).and_return(
        datapass_client_id: 'test_client_id',
        datapass_client_secret: 'test_client_secret'
      )

      stub_request(:post, auth_url)
        .with(
          body: 'grant_type=client_credentials&client_id=test_client_id&client_secret=test_client_secret&scope=read_authorizations',
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: { access_token: 'data_pass_access_token' }.to_json
        )
    end

    it 'requests a token with the read_authorizations scope' do
      expect(access_token).to eq('data_pass_access_token')
    end
  end
end
