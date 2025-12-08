RSpec.describe CNOUS::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when cnous authentication succeed' do
    before do
      stub_request(:post, Siade.credentials[:cnous_authenticate_url])
        .to_return(
          status: 200,
          body: { access_token: 'test_token', expires_in: 7200 }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end
end
