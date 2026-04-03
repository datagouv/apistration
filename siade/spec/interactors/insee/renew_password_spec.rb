RSpec.describe INSEE::RenewPassword, type: :interactor do
  subject(:renew) do
    described_class.call(
      token:,
      old_password:,
      new_password:,
      provider_name: 'insee'
    )
  end

  let(:token) { 'valid-bearer-token' }
  let(:old_password) { 'OldP4ssword!xyz' }
  let(:new_password) { 'NewP4ssword!abc' }
  let(:insee_sirene_url) { Siade.credentials[:insee_sirene_url] }
  let(:renew_url) { %r{#{insee_sirene_url}/api-sirene/prive/3.11/renouvellement} }

  context 'when the renewal succeeds' do
    before do
      stub_request(:post, renew_url)
        .with(
          headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
          body: { oldPassword: old_password, newPassword: new_password }.to_json
        )
        .to_return(status: 200, body: '{}')
    end

    it { is_expected.to be_a_success }

    it 'sends a POST with correct body' do
      renew

      expect(WebMock).to have_requested(:post, renew_url)
        .with(body: { oldPassword: old_password, newPassword: new_password }.to_json)
    end

    it 'sends the Authorization header' do
      renew

      expect(WebMock).to have_requested(:post, renew_url)
        .with(headers: { 'Authorization' => "Bearer #{token}" })
    end
  end

  context 'when the old password is incorrect (400)' do
    before do
      stub_request(:post, renew_url)
        .to_return(status: 400, body: '{"message":"Ancien mot de passe incorrect"}')
    end

    it { is_expected.to be_a_success }

    it 'returns the 400 response' do
      expect(renew.response.code).to eq('400')
    end
  end

  context 'when the new password is invalid (400)' do
    before do
      stub_request(:post, renew_url)
        .to_return(status: 400, body: '{"message":"Le mot de passe ne respecte pas les règles"}')
    end

    it { is_expected.to be_a_success }

    it 'returns the 400 response' do
      expect(renew.response.code).to eq('400')
    end
  end
end
