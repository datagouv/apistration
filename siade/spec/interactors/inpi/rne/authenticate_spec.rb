RSpec.describe INPI::RNE::Authenticate, type: :interactor do
  subject(:authenticate) { described_class.call }

  context 'when inpi rne authentication succeed', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(authenticate.token).to be_present
    end
  end

  context 'when inpi rne authentication fails with a 401 error (password expired)' do
    before do
      stub_request(:post, Siade.credentials[:inpi_rne_login_url])
        .to_return(status: 401, body: { 'code' => '401', 'webserviceCode' => 'LOGIN_AUTHENTICATOR', 'errorCode' => 'unauthorized', 'message' => 'Identifiants invalides.', 'type' => 'unauthorized' }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(MaintenanceError) }

    it 'tracks custom error with username' do
      expect(MonitoringService.instance).to receive(:track).with(:error, "INPI RNE authentication failed for username: #{Siade.credentials[:inpi_rne_login_username]}")

      subject
    end

    it 'sets a cache key based on username' do
      subject

      expect(Rails.cache.exist?(:"inpi_rne_authenticate_failed_#{Siade.credentials[:inpi_rne_login_username]}")).to be true

      Rails.cache.delete("inpi_rne_authenticate_failed_#{Siade.credentials[:inpi_rne_login_username]}")
    end
  end

  context 'when cache key for authentication is present' do
    before do
      Rails.cache.write("inpi_rne_authenticate_failed_#{Siade.credentials[:inpi_rne_login_username]}", '1')
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(MaintenanceError) }
  end
end
