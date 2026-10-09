RSpec.describe INPI::RNE::Authenticate, type: :interactor do
  subject(:authenticate) { described_class.call(params:) }

  let(:params) { {} }
  let(:login_url) { Siade.credentials[:inpi_rne_login_url] }
  let(:primary_username) { Siade.credentials[:inpi_rne_login_username] }
  let(:fallback_username) { Siade.credentials[:inpi_rne_login_username_fallback] }
  let(:ping_username) { Siade.credentials[:inpi_rne_login_ping_username] }
  let(:ping_fallback_username) { Siade.credentials[:inpi_rne_login_ping_username_fallback] }

  def build_token(label)
    JWT.encode({ exp: 1.hour.from_now.to_i, label: }, nil, 'none')
  end

  def stub_authentication(username, status: 200, token: build_token(username))
    body = status == 200 ? { token: } : { code: '401', errorCode: 'unauthorized', message: 'Identifiants invalides.' }

    stub_request(:post, login_url)
      .with(body: hash_including('username' => username))
      .to_return(status:, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def rejection_key(username)
    "inpi_rne_authenticate_failed_#{username}"
  end

  def flag(username)
    RedisService.new.set(rejection_key(username), Time.zone.now.to_i)
  end

  def flagged?(username)
    RedisService.new.exists?(rejection_key(username))
  end

  context 'when inpi rne authentication succeed', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(authenticate.token).to be_present
    end
  end

  context 'when no account is flagged' do
    let!(:primary_request) { stub_authentication(primary_username) }
    let!(:fallback_request) { stub_authentication(fallback_username) }

    before do
      allow_any_instance_of(described_class).to receive(:first_account_index).and_call_original # rubocop:disable RSpec/AnyInstance
    end

    it 'spreads authentications across both accounts' do
      50.times { described_class.call(params:) }

      expect(primary_request).to have_been_requested.once
      expect(fallback_request).to have_been_requested.once
    end
  end

  context 'when drawn account gets a 401' do
    let!(:primary_request) { stub_authentication(primary_username, status: 401) }
    let(:fallback_token) { build_token('fallback') }
    let!(:fallback_request) { stub_authentication(fallback_username, token: fallback_token) }

    it { is_expected.to be_a_success }

    it 'returns the other account token' do
      expect(authenticate.token).to eq(fallback_token)
    end

    it 'flags the rejected account for 24 hours' do
      authenticate

      expect(flagged?(primary_username)).to be true
      expect(flagged?(fallback_username)).to be false
      expect(RedisService.new.ttl(rejection_key(primary_username))).to be_within(5).of(24.hours.to_i)
    end

    it 'shares the flag with every process, whatever their cache namespace' do
      authenticate

      Rails.cache.clear

      expect(flagged?(primary_username)).to be true
    end

    it 'tracks the rejected account once' do
      allow(MonitoringService.instance).to receive(:track)

      authenticate

      expect(MonitoringService.instance).to have_received(:track).with(:error, "INPI RNE authentication failed for username: #{primary_username}").once
    end

    it 'only uses the other account afterwards, even if drawn first' do
      3.times { described_class.call(params:) }

      expect(primary_request).to have_been_requested.once
      expect(fallback_request).to have_been_requested.once
    end
  end

  context 'when one account is already flagged' do
    let!(:primary_request) { stub_authentication(primary_username) }
    let!(:fallback_request) { stub_authentication(fallback_username) }

    before { flag(primary_username) }

    it { is_expected.to be_a_success }

    it 'never calls INPI with the flagged account' do
      authenticate

      expect(primary_request).not_to have_been_requested
      expect(fallback_request).to have_been_requested.once
    end
  end

  context 'when both accounts get a 401' do
    before do
      stub_authentication(primary_username, status: 401)
      stub_authentication(fallback_username, status: 401)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(MaintenanceError) }

    it 'flags both accounts' do
      authenticate

      expect(flagged?(primary_username)).to be true
      expect(flagged?(fallback_username)).to be true
    end
  end

  context 'when both accounts are flagged' do
    before do
      flag(primary_username)
      flag(fallback_username)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(MaintenanceError) }

    it 'does not call INPI' do
      authenticate

      expect(a_request(:post, login_url)).not_to have_been_made
    end
  end

  context 'with the ping account pool' do
    let(:params) { { inpi_rne_account_pool: 'ping' } }

    context 'when ping accounts work' do
      let!(:ping_request) { stub_authentication(ping_username) }

      it { is_expected.to be_a_success }

      it 'authenticates with the ping account' do
        authenticate

        expect(ping_request).to have_been_requested.once
      end
    end

    context 'when first ping account gets a 401' do
      let!(:ping_request) { stub_authentication(ping_username, status: 401) }
      let!(:ping_fallback_request) { stub_authentication(ping_fallback_username) }

      it { is_expected.to be_a_success }

      it 'falls back on the other ping account, never on production ones' do
        authenticate

        expect(ping_request).to have_been_requested.once
        expect(ping_fallback_request).to have_been_requested.once
        expect(a_request(:post, login_url).with(body: hash_including('username' => primary_username))).not_to have_been_made
        expect(a_request(:post, login_url).with(body: hash_including('username' => fallback_username))).not_to have_been_made
        expect(flagged?(ping_username)).to be true
      end
    end

    context 'when both ping accounts are flagged' do
      before do
        flag(ping_username)
        flag(ping_fallback_username)
      end

      its(:errors) { is_expected.to include(MaintenanceError) }

      it 'does not call INPI' do
        authenticate

        expect(a_request(:post, login_url)).not_to have_been_made
      end
    end
  end
end
