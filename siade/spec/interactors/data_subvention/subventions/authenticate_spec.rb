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

  context 'when the provider replies with an expiration date' do
    let(:expiration_date) { 2.days.from_now }
    let(:payload) do
      JSON.parse(read_payload_file('data_subvention/subventions/authenticate.json')).tap { |body|
        body['user']['jwt']['expirateDate'] = expiration_date.iso8601(3)
      }.to_json
    end

    before do
      stub_request(:post, "#{Siade.credentials[:data_subvention_url]}/auth/login")
        .to_return(status: 200, body: payload)
    end

    it 'caches the token up to that date' do
      expect(EncryptedCache.instance).to receive(:write).with(
        :'data_subvention/subventions/authenticate',
        'data_subvention_token',
        expires_in: be_within(5).of(2.days.to_i - 10)
      )

      subject
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
