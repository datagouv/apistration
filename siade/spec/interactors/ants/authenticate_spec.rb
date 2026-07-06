RSpec.describe ANTS::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when ants siv2 authentication succeeds' do
    before do
      stub_request(:post, Siade.credentials[:ants_siv2_token_url])
        .with(body: { client_id: Siade.credentials[:ants_siv2_client_id], grant_type: 'client_credentials' })
        .to_return(
          status: 200,
          body: { access_token: 'test_token', expires_in: 7200 }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to eq('test_token')
    end
  end
end
