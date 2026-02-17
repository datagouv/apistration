RSpec.describe INPI::RNE::Authenticate, type: :interactor do
  subject(:authenticate) { described_class.call }

  context 'when inpi rne authentication succeed', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(authenticate.token).to be_present
    end
  end

  context 'when primary username cache key is present but fallback succeeds' do
    let(:primary_username) { Siade.credentials[:inpi_rne_login_username] }
    let(:fallback_username) { Siade.credentials[:inpi_rne_login_username_fallback] }
    let(:fallback_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU1ODg4MDB9.cached_test' }

    before do
      Rails.cache.write("inpi_rne_authenticate_failed_#{primary_username}", '1')

      stub_request(:post, Siade.credentials[:inpi_rne_login_url])
        .with(body: hash_including('username' => fallback_username))
        .to_return(status: 200, body: { 'token' => fallback_token }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    after do
      Rails.cache.delete("inpi_rne_authenticate_failed_#{primary_username}")
    end

    it { is_expected.to be_a_success }

    it 'returns fallback token' do
      expect(authenticate.token).to eq(fallback_token)
    end
  end

  context 'when both primary and fallback username cache keys are present' do
    let(:primary_username) { Siade.credentials[:inpi_rne_login_username] }
    let(:fallback_username) { Siade.credentials[:inpi_rne_login_username_fallback] }

    before do
      Rails.cache.write("inpi_rne_authenticate_failed_#{primary_username}", '1')
      Rails.cache.write("inpi_rne_authenticate_failed_#{fallback_username}", '1')
    end

    after do
      Rails.cache.delete("inpi_rne_authenticate_failed_#{primary_username}")
      Rails.cache.delete("inpi_rne_authenticate_failed_#{fallback_username}")
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(MaintenanceError) }
  end

  context 'when primary authentication fails but fallback succeeds' do
    let(:primary_username) { Siade.credentials[:inpi_rne_login_username] }
    let(:fallback_username) { Siade.credentials[:inpi_rne_login_username_fallback] }
    let(:fallback_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU1ODg4MDB9.test' }

    before do
      stub_request(:post, Siade.credentials[:inpi_rne_login_url])
        .with(body: hash_including('username' => primary_username))
        .to_return(status: 401, body: { 'code' => '401', 'errorCode' => 'unauthorized', 'message' => 'Identifiants invalides.' }.to_json, headers: { 'Content-Type' => 'application/json' })

      stub_request(:post, Siade.credentials[:inpi_rne_login_url])
        .with(body: hash_including('username' => fallback_username))
        .to_return(status: 200, body: { 'token' => fallback_token }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it { is_expected.to be_a_success }

    it 'returns fallback token' do
      expect(authenticate.token).to eq(fallback_token)
    end

    it 'tracks primary authentication failure' do
      expect(MonitoringService.instance).to receive(:track).with(:error, "INPI RNE authentication failed for username: #{primary_username}")

      subject
    end

    it 'does not mark fallback username as failed in cache' do
      subject

      expect(Rails.cache.exist?("inpi_rne_authenticate_failed_#{fallback_username}")).to be false
    end
  end

  context 'when both primary and fallback authentication fail' do
    let(:primary_username) { Siade.credentials[:inpi_rne_login_username] }
    let(:fallback_username) { Siade.credentials[:inpi_rne_login_username_fallback] }

    before do
      stub_request(:post, Siade.credentials[:inpi_rne_login_url])
        .to_return(status: 401, body: { 'code' => '401', 'errorCode' => 'unauthorized', 'message' => 'Identifiants invalides.' }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    after do
      Rails.cache.delete("inpi_rne_authenticate_failed_#{fallback_username}")
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(MaintenanceError) }

    it 'tracks both authentication failures' do
      expect(MonitoringService.instance).to receive(:track).with(:error, "INPI RNE authentication failed for username: #{primary_username}")
      expect(MonitoringService.instance).to receive(:track).with(:error, "INPI RNE authentication failed for username: #{fallback_username}")

      subject
    end

    it 'marks fallback username as failed in cache' do
      subject

      expect(Rails.cache.exist?("inpi_rne_authenticate_failed_#{fallback_username}")).to be true
    end
  end

  context 'with load balancing using fallback account as primary' do
    let(:primary_username) { Siade.credentials[:inpi_rne_login_username] }
    let(:fallback_username) { Siade.credentials[:inpi_rne_login_username_fallback] }
    let(:fallback_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU1ODg4MDB9.lb_test' }

    before do
      allow_any_instance_of(described_class).to receive(:randomize_account!) do |instance| # rubocop:disable RSpec/AnyInstance
        instance.instance_variable_set(:@account_suffix, '_fallback')
      end
    end

    context 'when fallback account authentication succeeds' do
      before do
        stub_request(:post, Siade.credentials[:inpi_rne_login_url])
          .with(body: hash_including('username' => fallback_username))
          .to_return(status: 200, body: { 'token' => fallback_token }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it { is_expected.to be_a_success }

      it 'authenticates with fallback credentials' do
        expect(authenticate.token).to eq(fallback_token)
      end
    end

    context 'when fallback account fails (401) but primary succeeds' do
      let(:primary_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU1ODg4MDB9.primary_lb' }

      before do
        stub_request(:post, Siade.credentials[:inpi_rne_login_url])
          .with(body: hash_including('username' => fallback_username))
          .to_return(status: 401, body: { 'code' => '401', 'errorCode' => 'unauthorized', 'message' => 'Identifiants invalides.' }.to_json, headers: { 'Content-Type' => 'application/json' })

        stub_request(:post, Siade.credentials[:inpi_rne_login_url])
          .with(body: hash_including('username' => primary_username))
          .to_return(status: 200, body: { 'token' => primary_token }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it { is_expected.to be_a_success }

      it 'falls back to primary credentials' do
        expect(authenticate.token).to eq(primary_token)
      end
    end

    context 'when both accounts fail (401)' do
      before do
        stub_request(:post, Siade.credentials[:inpi_rne_login_url])
          .to_return(status: 401, body: { 'code' => '401', 'errorCode' => 'unauthorized', 'message' => 'Identifiants invalides.' }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      after do
        Rails.cache.delete("inpi_rne_authenticate_failed_#{primary_username}")
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(MaintenanceError) }
    end

    context 'when fallback account is cached as failed' do
      let(:primary_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU1ODg4MDB9.primary_cached' }

      before do
        Rails.cache.write("inpi_rne_authenticate_failed_#{fallback_username}", '1')

        stub_request(:post, Siade.credentials[:inpi_rne_login_url])
          .with(body: hash_including('username' => primary_username))
          .to_return(status: 200, body: { 'token' => primary_token }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      after do
        Rails.cache.delete("inpi_rne_authenticate_failed_#{fallback_username}")
      end

      it { is_expected.to be_a_success }

      it 'uses primary account as fallback' do
        expect(authenticate.token).to eq(primary_token)
      end
    end
  end
end
