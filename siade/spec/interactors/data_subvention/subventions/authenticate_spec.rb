RSpec.describe DataSubvention::Subventions::Authenticate, type: :interactor do
  subject { described_class.call }

  before do
    stub_datasubvention_subventions_authenticate
  end

  context 'when on happy path' do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(subject.token).to be_present
    end
  end

  context 'when provider is down and replies with valid JSON missing the user/jwt structure' do
    before do
      stub_request(:post, "#{Siade.credentials[:data_subvention_url]}/auth/login")
        .to_return(status: 500, body: '{"error":"Internal Server Error"}')
    end

    it { is_expected.to be_a_failure }

    it 'fails with a ProviderUnknownError' do
      expect(subject.errors.first).to be_a(ProviderUnknownError)
    end
  end
end
