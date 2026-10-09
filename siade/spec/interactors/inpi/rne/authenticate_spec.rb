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
    RedisService.new.set(rejection_key(username), Time.zone.now.to_f)
  end

  def ping_last_ok_status_key(identifier)
    "last_ok_status_ping_api_entreprise_#{identifier}"
  end

  def ping_succeeded(identifier, succeeded_at:)
    RedisService.new.dump(ping_last_ok_status_key(identifier), succeeded_at)
  end

  def flagged?(username)
    RedisService.new.exists?(rejection_key(username))
  end

  before do
    RedisService.new.del(ping_last_ok_status_key('inpi/rne'), ping_last_ok_status_key('inpi/rne/actes_bilans'))
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

  context 'when INPI answered 401 to both accounts during an outage' do
    let(:outage_at) { Time.zone.local(2026, 10, 9, 7, 55, 0, 600_000) }

    before do
      stub_authentication(primary_username, status: 401)
      stub_authentication(fallback_username, status: 401)
      Timecop.freeze(outage_at) { described_class.call(params:) }
      WebMock.reset_executed_requests!
    end

    context 'when INPI is back and accepts the passwords' do
      let!(:primary_request) { stub_authentication(primary_username) }
      let!(:fallback_request) { stub_authentication(fallback_username) }

      it 'stays in maintenance while no INPI RNE ping succeeded since the rejections' do
        ping_succeeded('inpi/rne', succeeded_at: outage_at - 5.minutes)

        expect(described_class.call(params:).errors).to include(MaintenanceError)
        expect(primary_request).not_to have_been_requested
        expect(fallback_request).not_to have_been_requested
      end

      it 'stays in maintenance when the ping succeeded earlier within the same second as the rejections' do
        ping_succeeded('inpi/rne', succeeded_at: outage_at - 0.4.seconds)

        expect(described_class.call(params:).errors).to include(MaintenanceError)
        expect(primary_request).not_to have_been_requested
      end

      it 'authenticates again as soon as an INPI RNE ping succeeded after the rejections' do
        ping_succeeded('inpi/rne/actes_bilans', succeeded_at: outage_at + 1.minute)

        expect(described_class.call(params:)).to be_a_success
        expect(primary_request).to have_been_requested.once
      end

      it 'makes both accounts usable again for the following requests' do
        ping_succeeded('inpi/rne', succeeded_at: outage_at + 1.minute)
        described_class.call(params:)
        Rails.cache.clear

        expect(described_class.call(params:)).to be_a_success
        expect(flagged?(primary_username)).to be false
        expect(flagged?(fallback_username)).to be false
      end

      it 'keeps concurrent requests in maintenance while one request retries INPI' do
        ping_succeeded('inpi/rne', succeeded_at: outage_at + 1.minute)
        concurrent_request = nil
        stub_request(:post, login_url)
          .with(body: hash_including('username' => primary_username))
          .to_return do
            concurrent_request = described_class.call(params:)
            { status: 200, body: { token: build_token(primary_username) }.to_json, headers: { 'Content-Type' => 'application/json' } }
          end

        expect(described_class.call(params:)).to be_a_success
        expect(concurrent_request.errors).to include(MaintenanceError)
        expect(a_request(:post, login_url)).to have_been_made.once
      end
    end

    context 'when the passwords really expired' do
      let!(:primary_request) { stub_authentication(primary_username, status: 401) }
      let!(:fallback_request) { stub_authentication(fallback_username, status: 401) }

      it 'tries each account once per INPI RNE ping success' do
        ping_succeeded('inpi/rne', succeeded_at: outage_at + 1.minute)
        3.times { described_class.call(params:) }

        expect(primary_request).to have_been_requested.once
        expect(fallback_request).to have_been_requested.once

        ping_succeeded('inpi/rne', succeeded_at: 1.minute.from_now)
        3.times { described_class.call(params:) }

        expect(primary_request).to have_been_requested.twice
        expect(fallback_request).to have_been_requested.twice
      end

      it 'keeps rendering maintenance' do
        ping_succeeded('inpi/rne', succeeded_at: outage_at + 1.minute)

        expect(described_class.call(params:).errors).to include(MaintenanceError)
      end
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
