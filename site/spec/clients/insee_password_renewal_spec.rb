RSpec.describe INSEEPasswordRenewal do
  subject(:renewal) do
    described_class.new.renew(
      token: 'a-valid-bearer-token',
      old_password: 'OldP4ssword-xyz',
      new_password: 'NewP4ssword-abc'
    )
  end

  context 'when INSEE accepts the renewal' do
    before { stub_request(:post, described_class::RENEWAL_URL).to_return(status: 200, body: '{}') }

    it 'returns the response' do
      expect(renewal.status).to eq(200)
    end

    it 'sends both passwords' do
      renewal

      expect(WebMock).to have_requested(:post, described_class::RENEWAL_URL)
        .with(body: { oldPassword: 'OldP4ssword-xyz', newPassword: 'NewP4ssword-abc' }.to_json)
    end

    it 'sends the bearer token' do
      renewal

      expect(WebMock).to have_requested(:post, described_class::RENEWAL_URL)
        .with(headers: { 'Authorization' => 'Bearer a-valid-bearer-token' })
    end
  end

  context 'when INSEE rejects the renewal' do
    before do
      stub_request(:post, described_class::RENEWAL_URL)
        .to_return(status: 400, body: '{"message":"Ancien mot de passe incorrect"}')
    end

    it 'returns the response instead of raising' do
      expect(renewal.status).to eq(400)
    end

    it 'calls INSEE only once' do
      renewal

      expect(WebMock).to have_requested(:post, described_class::RENEWAL_URL).once
    end
  end
end
