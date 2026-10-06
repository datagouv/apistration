RSpec.describe INSEE::Authenticate, type: :interactor do
  def guard_write(key, value, **)
    Rails.cache.write(key, value, namespace: INSEE::AuthenticationBackoff::CACHE_NAMESPACE, **)
  end

  def guard_read(key)
    Rails.cache.read(key, namespace: INSEE::AuthenticationBackoff::CACHE_NAMESPACE)
  end

  def lock_write(value, **)
    Rails.cache.write(described_class::LOCK_CACHE_KEY, value, **)
  end

  def lock_read
    Rails.cache.read(described_class::LOCK_CACHE_KEY)
  end

  def arm_the_failure_guard
    guard_write(INSEE::AuthenticationBackoff::HOLD_CACHE_KEY, true, expires_in: INSEE::AuthenticationBackoff::OAUTH_REJECTION_HOLD)
  end

  def from_another_process(&)
    Rails.cache.with_local_cache(&)
  end

  def publish_the_other_thread_token
    EncryptedCache.write(described_class::CACHE_KEY, 'token-from-the-other-thread', expires_in: 1.hour)
  end

  subject(:retrieve_token) { described_class.call(provider_name: 'INSEE') }

  let(:insee_oauth_url) { Siade.credentials[:insee_oauth_url] }
  let(:token) { 'a-fresh-insee-token' }

  def stub_oauth(*responses)
    stub_request(:post, /#{insee_oauth_url}/).to_return(*responses)
  end

  def granted_response(access_token: 'a-fresh-insee-token', expires_in: 300)
    {
      status: 200,
      body: { access_token:, expires_in: }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
  end

  def invalid_grant_response
    {
      status: 401,
      body: { error: 'invalid_grant', error_description: 'Invalid user credentials' }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
  end

  context 'when the token is not stored in cache', vcr: { cassette_name: 'insee/token' } do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_blank }
    its(:token) { is_expected.to eq 'anonymized-insee-token-12345678-abcd-efgh-ijkl-9876543210fe' }

    it 'calls INSEE API' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/)
    end

    it 'stores the new token retrieved from INSEE API in cache' do
      expect {
        retrieve_token
      }.to change { EncryptedCache.read(described_class::CACHE_KEY) }
        .to('anonymized-insee-token-12345678-abcd-efgh-ijkl-9876543210fe')
    end
  end

  context 'when the token is stored in cache' do
    before { EncryptedCache.write(described_class::CACHE_KEY, 'cached-token') }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq 'cached-token' }

    it 'does not call INSEE API' do
      retrieve_token

      expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
    end
  end

  describe 'renewal ahead of expiry' do
    let(:authenticated_at) { Time.zone.local(2026, 10, 15, 12) }

    def authenticate_at(time)
      Timecop.freeze(time) { described_class.call(provider_name: 'INSEE') }
    end

    before do
      stub_oauth(granted_response(access_token: 'current-token'), granted_response(access_token: 'renewed-token'))
      authenticate_at(authenticated_at)
    end

    after { Timecop.return }

    context 'when the token is far from its expiry' do
      it 'keeps the current token without calling INSEE' do
        expect(authenticate_at(authenticated_at + 200.seconds).token).to eq('current-token')
        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
      end
    end

    context 'when the token nears its expiry' do
      let(:renewal_time) { authenticated_at + 220.seconds }

      it 'hands out a renewed token' do
        expect(authenticate_at(renewal_time).token).to eq('renewed-token')
      end

      it 'publishes the renewed token' do
        authenticate_at(renewal_time)

        expect(described_class.published_token).to eq('renewed-token')
      end

      it 'renews only once' do
        authenticate_at(renewal_time)
        authenticate_at(renewal_time + 1.second)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
      end

      it 'releases the lock' do
        authenticate_at(renewal_time)

        expect(lock_read).to be_nil
      end
    end

    context 'when INSEE refuses the renewal' do
      before do
        stub_oauth(invalid_grant_response)
        allow(MonitoringService.instance).to receive(:track_with_added_context)
      end

      it 'tries to renew' do
        authenticate_at(authenticated_at + 220.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).at_least_times(2)
      end

      it 'keeps serving the current token' do
        renewal = authenticate_at(authenticated_at + 220.seconds)

        expect(renewal).to be_a_success
        expect(renewal.token).to eq('current-token')
      end

      it 'keeps the current token published' do
        authenticate_at(authenticated_at + 220.seconds)

        expect(described_class.published_token).to eq('current-token')
      end
    end

    context 'when INSEE is unavailable during the renewal' do
      before do
        stub_oauth(status: 503, body: '')
        authenticate_at(authenticated_at + 220.seconds)
      end

      it 'keeps serving the current token' do
        renewal = authenticate_at(authenticated_at + 221.seconds)

        expect(renewal).to be_a_success
        expect(renewal.token).to eq('current-token')
      end

      it 'waits before trying to renew again' do
        authenticate_at(authenticated_at + 249.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
      end

      it 'tries to renew again 30 seconds later' do
        authenticate_at(authenticated_at + 251.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).times(3)
      end

      it 'stops renewing once no retry fits before the deadline' do
        authenticate_at(authenticated_at + 251.seconds)
        authenticate_at(authenticated_at + 252.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).times(3)
      end
    end

    context 'when a renewal may walk several password candidates' do
      let(:authenticated_at) { Time.zone.local(2027, 1, 15, 12) }

      before { stub_oauth(status: 503, body: '') }

      it 'stops renewing early enough for the whole walk to complete' do
        authenticate_at(authenticated_at + 211.seconds)
        authenticate_at(authenticated_at + 241.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
      end
    end

    context 'when the token is too close to its expiry for an OAuth exchange to complete' do
      before { stub_oauth(status: 503, body: '') }

      it 'no longer starts a renewal' do
        authenticate_at(authenticated_at + 220.seconds)
        authenticate_at(authenticated_at + 271.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
      end
    end

    context 'when another request is already renewing' do
      before { lock_write('another-request', expires_in: described_class::LOCK_TTL) }

      it 'keeps serving the current token without calling INSEE' do
        expect(authenticate_at(authenticated_at + 220.seconds).token).to eq('current-token')
        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
      end
    end

    context 'when the token lives too short for a renewal window' do
      before do
        Rails.cache.clear
        stub_oauth(granted_response(access_token: 'short-token', expires_in: 60), granted_response(access_token: 'renewed-token'))
        authenticate_at(authenticated_at)
      end

      it 'keeps it until its expiry' do
        authenticate_at(authenticated_at + 1.second)
        authenticate_at(authenticated_at + 49.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
      end
    end

    context 'when the renewed token could not be published' do
      before do
        allow(EncryptedCache).to receive(:write).and_return(false)
        authenticate_at(authenticated_at + 220.seconds)
      end

      it 'keeps renewing the current token' do
        authenticate_at(authenticated_at + 251.seconds)

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).times(3)
      end
    end
  end

  context 'when the first candidate is rejected with invalid_grant' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(invalid_grant_response, granted_response)
    end

    after { Timecop.return }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq token }

    it 'tries each candidate exactly once' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
    end

    it 'sends the previous password as second candidate' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/)
        .with(body: hash_including('password' => INSEE::PasswordDerivation.previous_password))
    end

    it 'remembers the password INSEE accepted' do
      retrieve_token

      expect(INSEE::AcceptedPassword.last?(INSEE::PasswordDerivation.previous_password)).to be(true)
    end
  end

  context 'when INSEE is unavailable' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(status: 503, body: '')
    end

    after { Timecop.return }

    it { is_expected.to be_a_failure }

    it 'does not try the second candidate' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
    end

    it 'does not remember the failure' do
      retrieve_token

      expect(guard_read(INSEE::AuthenticationBackoff::HOLD_CACHE_KEY)).to be_nil
    end
  end

  context 'when INSEE rate limits the OAuth exchange' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(status: 429, body: '', headers: { 'Retry-After' => '2' })
    end

    after { Timecop.return }

    it { is_expected.to be_a_failure }

    it 'fails with a temporary error' do
      expect(retrieve_token.errors.first).to be_a(ProviderTemporaryError)
    end

    it 'does not try the second candidate' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
    end

    it 'does not remember the failure' do
      retrieve_token

      expect(guard_read(INSEE::AuthenticationBackoff::HOLD_CACHE_KEY)).to be_nil
    end
  end

  context 'when INSEE answers with a request timeout' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(status: 408, body: '')
    end

    after { Timecop.return }

    it 'fails with a temporary error' do
      expect(retrieve_token.errors.first).to be_a(ProviderTemporaryError)
    end

    it 'does not remember the failure' do
      retrieve_token

      expect(guard_read(INSEE::AuthenticationBackoff::HOLD_CACHE_KEY)).to be_nil
    end
  end

  context 'when INSEE answers with a non JSON body' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(status: 200, body: '<html>gateway</html>')
    end

    after { Timecop.return }

    it { is_expected.to be_a_failure }

    it 'fails with a temporary error' do
      expect(retrieve_token.errors.first).to be_a(ProviderTemporaryError)
    end

    it 'does not try the second candidate' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
    end
  end

  context 'when INSEE times out' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_request(:post, /#{insee_oauth_url}/).to_timeout
    end

    after { Timecop.return }

    it { is_expected.to be_a_failure }

    it 'does not try the second candidate' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
    end
  end

  context 'when every candidate is rejected with invalid_grant' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(invalid_grant_response)
      allow(MonitoringService.instance).to receive(:track_with_added_context)
    end

    after { Timecop.return }

    it { is_expected.to be_a_failure }

    it 'fails with a ProviderAuthenticationError' do
      expect(retrieve_token.errors.first).to be_a(ProviderAuthenticationError)
    end

    it 'tries each candidate then the current password once more' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).times(3)
    end

    it 'alerts on both hypotheses' do
      retrieve_token

      expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
        'error',
        'INSEE authentication failed on every candidate: password desynchronized or account locked',
        hash_including(period: '2027-01')
      )
    end

    it 'reports what INSEE answered' do
      retrieve_token

      expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
        'error',
        'INSEE authentication failed on every candidate: password desynchronized or account locked',
        hash_including(
          http_response_code: 401,
          provider_error: 'invalid_grant',
          provider_error_description: 'Invalid user credentials'
        )
      )
    end

    it 'names the refusal with words the Sentry scrubber lets through' do
      retrieve_token

      expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
        'error',
        anything,
        hash_including(refusal_reason: 'refused_login')
      )
    end

    it 'remembers the failure' do
      retrieve_token

      expect(guard_read(INSEE::AuthenticationBackoff::HOLD_CACHE_KEY)).to be(true)
    end

    it 'does not call INSEE again while the failure is remembered' do
      retrieve_token
      described_class.call(provider_name: 'INSEE')

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).times(3)
    end

    it 'fails temporarily while the failure is remembered' do
      retrieve_token

      expect(described_class.call(provider_name: 'INSEE').errors.first).to be_a(ProviderTemporaryError)
    end
  end

  describe 'backoff' do
    let(:first_refusal_at) { Time.zone.local(2026, 10, 15, 12) }

    def authenticate_at(time)
      Timecop.freeze(time) { described_class.call(provider_name: 'INSEE') }
    end

    def oauth_calls
      WebMock::RequestRegistry.instance.times_executed(WebMock::RequestPattern.new(:post, /#{insee_oauth_url}/))
    end

    def refused_response(description)
      {
        status: 400,
        body: { error: 'invalid_grant', error_description: description }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      }
    end

    before { allow(MonitoringService.instance).to receive(:track_with_added_context) }

    after { Timecop.return }

    context 'when INSEE refuses the login once' do
      before do
        stub_oauth(refused_response('Invalid user credentials'), granted_response)
        authenticate_at(first_refusal_at)
      end

      it 'holds back the next authentication for 30 seconds' do
        authenticate_at(first_refusal_at + 29.seconds)

        expect(oauth_calls).to eq(1)
      end

      it 'tries again after 30 seconds' do
        expect(authenticate_at(first_refusal_at + 31.seconds).token).to eq(token)
      end
    end

    context 'when INSEE keeps refusing the login' do
      before { stub_oauth(refused_response('Invalid user credentials')) }

      def refuse_successively(count)
        time = first_refusal_at

        count.times do
          authenticate_at(time)
          time += INSEE::AuthenticationBackoff::STEPS.last + 1.second
        end

        time - INSEE::AuthenticationBackoff::STEPS.last - 1.second
      end

      it 'doubles the wait after each refusal' do
        last_refusal_at = refuse_successively(2)

        authenticate_at(last_refusal_at + 59.seconds)
        expect(oauth_calls).to eq(2)

        authenticate_at(last_refusal_at + 61.seconds)
        expect(oauth_calls).to eq(3)
      end

      it 'waits five minutes at most' do
        last_refusal_at = refuse_successively(8)

        authenticate_at(last_refusal_at + 299.seconds)
        expect(oauth_calls).to eq(8)

        authenticate_at(last_refusal_at + 301.seconds)
        expect(oauth_calls).to eq(9)
      end
    end

    context 'when INSEE grants a token after refusals' do
      before do
        stub_oauth(
          refused_response('Invalid user credentials'),
          refused_response('Invalid user credentials'),
          granted_response(access_token: 'granted-token', expires_in: 1),
          refused_response('Invalid user credentials')
        )
      end

      it 'starts over from the shortest wait' do
        authenticate_at(first_refusal_at)
        authenticate_at(first_refusal_at + 31.seconds)
        authenticate_at(first_refusal_at + 92.seconds)
        authenticate_at(first_refusal_at + 100.seconds)

        authenticate_at(first_refusal_at + 131.seconds)

        expect(oauth_calls).to eq(5)
      end
    end

    context 'when Keycloak reports the account as not fully set up' do
      before do
        stub_oauth(refused_response('Account is not fully set up'), granted_response)
        authenticate_at(first_refusal_at)
      end

      it 'tries again after 30 seconds, since that refusal follows an accepted password' do
        expect(authenticate_at(first_refusal_at + 31.seconds).token).to eq(token)
      end
    end

    context 'when INSEE refuses the login several times in a row' do
      before do
        stub_oauth(refused_response('Invalid user credentials'), refused_response('Invalid user credentials'), granted_response)
        authenticate_at(first_refusal_at)
        authenticate_at(first_refusal_at + 31.seconds)
      end

      it 'alerts once for the whole episode' do
        expect(MonitoringService.instance).to have_received(:track_with_added_context)
          .with('error', anything, anything).once
      end

      it 'reports the recovery with the length of the episode' do
        authenticate_at(first_refusal_at + 92.seconds)

        expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
          'warning',
          'INSEE authentication recovered',
          hash_including(refusals: 2, outage_seconds: 92)
        )
      end
    end

    context 'when INSEE keeps reporting the account as disabled' do
      before do
        stub_oauth(refused_response('Account disabled'))
        authenticate_at(first_refusal_at)
        authenticate_at(first_refusal_at + 31.seconds)
      end

      it 'alerts once for the whole episode' do
        expect(MonitoringService.instance).to have_received(:track_with_added_context)
          .with('error', anything, anything).once
      end
    end

    context 'when refusals keep coming for more than an hour' do
      before do
        stub_oauth(refused_response('Invalid user credentials'))
        13.times { |index| authenticate_at(first_refusal_at + (index * 301).seconds) }
      end

      it 'still alerts once' do
        expect(MonitoringService.instance).to have_received(:track_with_added_context)
          .with('error', anything, anything).once
      end

      it 'still holds back for five minutes' do
        authenticate_at(first_refusal_at + (12 * 301).seconds + 299.seconds)

        expect(oauth_calls).to eq(13)
      end
    end

    context 'when a refusal comes more than an hour after the previous one' do
      before do
        stub_oauth(refused_response('Invalid user credentials'), refused_response('Invalid user credentials'), granted_response)
        authenticate_at(first_refusal_at)
        authenticate_at(first_refusal_at + 2.hours)
      end

      it 'alerts again' do
        expect(MonitoringService.instance).to have_received(:track_with_added_context)
          .with('error', anything, anything).twice
      end

      it 'starts over from the shortest wait' do
        authenticate_at(first_refusal_at + 2.hours + 31.seconds)

        expect(oauth_calls).to eq(3)
      end
    end

    context 'when INSEE grants a token outside of any episode' do
      before do
        stub_oauth(granted_response)
        authenticate_at(first_refusal_at)
      end

      it 'reports nothing' do
        expect(MonitoringService.instance).not_to have_received(:track_with_added_context)
      end
    end

    context 'when INSEE refuses the OAuth exchange itself' do
      before do
        stub_oauth({ status: 400, body: { error: 'invalid_client' }.to_json }, granted_response)
        authenticate_at(first_refusal_at)
      end

      it 'holds back the next authentications for 30 minutes' do
        authenticate_at(first_refusal_at + 29.minutes)

        expect(oauth_calls).to eq(1)
      end
    end

    context 'when a renewal ahead of expiry is refused' do
      before do
        stub_oauth(granted_response(access_token: 'current-token'), refused_response('Invalid user credentials'), granted_response(access_token: 'renewed-token'))
        authenticate_at(first_refusal_at)
        authenticate_at(first_refusal_at + 220.seconds)
      end

      it 'keeps the current token while holding back' do
        expect(authenticate_at(first_refusal_at + 240.seconds).token).to eq('current-token')
        expect(oauth_calls).to eq(2)
      end

      it 'renews on the next try before the current token expires' do
        expect(authenticate_at(first_refusal_at + 251.seconds).token).to eq('renewed-token')
      end
    end
  end

  describe 'refusal reason' do
    before { Timecop.freeze(Date.new(2026, 10, 31)) }

    after { Timecop.return }

    def refusal_reason_for(description)
      reported = {}
      allow(MonitoringService.instance).to receive(:track_with_added_context) { |*, context| reported.merge!(context) }

      stub_oauth(
        status: 400,
        body: { error: 'invalid_grant', error_description: description }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      retrieve_token

      reported[:refusal_reason]
    end

    it 'tells a temporarily disabled account' do
      expect(refusal_reason_for('Account temporarily disabled')).to eq('account_temporarily_disabled')
    end

    it 'tells a disabled account' do
      expect(refusal_reason_for('Account disabled')).to eq('account_disabled')
    end

    it 'tells an account with pending required actions' do
      expect(refusal_reason_for('Account is not fully set up')).to eq('account_not_fully_set_up')
    end

    it 'tells a refused login' do
      expect(refusal_reason_for('Invalid user credentials')).to eq('refused_login')
    end

    it 'flags any other description as unknown' do
      expect(refusal_reason_for('Something else')).to eq('unknown')
    end
  end

  context 'when a rotation renewed the password while the candidates were tried' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(invalid_grant_response, invalid_grant_response, granted_response)
      allow(MonitoringService.instance).to receive(:track_with_added_context)
    end

    after { Timecop.return }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq token }

    it 'does not remember a failure' do
      retrieve_token

      expect(guard_read(INSEE::AuthenticationBackoff::HOLD_CACHE_KEY)).to be_nil
    end

    it 'does not alert' do
      retrieve_token

      expect(MonitoringService.instance).not_to have_received(:track_with_added_context)
    end
  end

  context 'when the static password is rejected before derivation starts' do
    before do
      Timecop.freeze(Date.new(2026, 10, 31))
      stub_oauth(invalid_grant_response)
      allow(MonitoringService.instance).to receive(:track_with_added_context)
    end

    after { Timecop.return }

    it 'stops after one attempt' do
      expect(retrieve_token).to be_a_failure
      expect(retrieve_token.errors.first).to be_a(ProviderAuthenticationError)

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
    end

    it 'does not blame a desynchronization it cannot detect' do
      retrieve_token

      expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
        'error',
        'INSEE refused the only password candidate: intermittent refusal or account locked',
        hash_including(candidates_count: 1, refusals: 1)
      )
    end
  end

  context 'when the bypass and current passwords are both rejected' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))
      Siade.credentials[INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY] = 'ByPass#Password1'
      stub_oauth(invalid_grant_response)
      allow(MonitoringService.instance).to receive(:track_with_added_context)
    end

    after do
      Siade.credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
      Timecop.return
    end

    it 'does not retry the current password it just rejected' do
      expect(retrieve_token).to be_a_failure
      expect(retrieve_token.errors.first).to be_a(ProviderAuthenticationError)

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/)
        .with(body: hash_including('password' => INSEE::PasswordDerivation.current_password)).once
    end
  end

  context 'when another authentication armed the failure guard before the lock was free' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(granted_response)

      allow(Rails.cache).to receive(:write).and_wrap_original do |original, *args, **options|
        arm_the_failure_guard if args.first == described_class::LOCK_CACHE_KEY

        original.call(*args, **options)
      end
    end

    after { Timecop.return }

    it 'fails with a temporary error' do
      expect(retrieve_token.errors.first).to be_a(ProviderTemporaryError)
    end

    it 'spends none of the attempts the guard was meant to save' do
      retrieve_token

      expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
    end

    it 'releases the single flight lock' do
      retrieve_token

      expect(lock_read).to be_nil
    end
  end

  describe 'within a request local cache' do
    around { |example| Rails.cache.with_local_cache { example.run } }

    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(granted_response)
    end

    after { Timecop.return }

    context 'when another process published the token this request already missed' do
      before do
        EncryptedCache.read(described_class::CACHE_KEY)

        from_another_process do
          EncryptedCache.write(described_class::CACHE_KEY, 'token-from-another-process', expires_in: 1.hour)
        end

        lock_write('another-request', expires_in: described_class::LOCK_TTL)
        stub_const("#{described_class}::LOCK_WAIT", 0)
      end

      it { is_expected.to be_a_success }

      its(:token) { is_expected.to eq 'token-from-another-process' }

      it 'does not call INSEE API' do
        retrieve_token

        expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
      end
    end

    context 'when another process armed the failure guard this request already missed' do
      before do
        allow(Rails.cache).to receive(:write).and_wrap_original do |original, *args, **options|
          from_another_process { arm_the_failure_guard } if args.first == described_class::LOCK_CACHE_KEY

          original.call(*args, **options)
        end
      end

      it 'fails with a temporary error' do
        expect(retrieve_token.errors.first).to be_a(ProviderTemporaryError)
      end

      it 'spends none of the attempts the guard was meant to save' do
        retrieve_token

        expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
      end
    end

    context 'when the lock was taken over while authenticating' do
      before do
        stub_request(:post, /#{insee_oauth_url}/).to_return do
          from_another_process { lock_write('the-successor', expires_in: described_class::LOCK_TTL) }

          granted_response
        end
      end

      it 'leaves the successor lock alone' do
        retrieve_token

        expect(from_another_process { lock_read }).to eq('the-successor')
      end
    end

    context 'when another process invalidated the token this request already read' do
      before do
        EncryptedCache.write(described_class::CACHE_KEY, 'rejected-token', expires_in: 1.hour)
        EncryptedCache.read(described_class::CACHE_KEY)

        from_another_process { EncryptedCache.write(described_class::CACHE_KEY, nil) }

        described_class.invalidate_token_cache!('rejected-token')
      end

      its(:token) { is_expected.to eq token }

      it 'does not hand back the token it just tried to invalidate' do
        expect(retrieve_token.token).not_to eq('rejected-token')
      end

      it 'authenticates again' do
        retrieve_token

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/)
      end
    end

    describe '.invalidate_token_cache!' do
      it 'keeps the token another process published after this request read the one it rejects' do
        EncryptedCache.write(described_class::CACHE_KEY, 'rejected-token', expires_in: 1.hour)
        EncryptedCache.read(described_class::CACHE_KEY)

        from_another_process do
          EncryptedCache.write(described_class::CACHE_KEY, 'refreshed-token', expires_in: 1.hour)
        end

        described_class.invalidate_token_cache!('rejected-token')

        expect(described_class.published_token).to eq('refreshed-token')
      end
    end
  end

  describe 'single flight' do
    before do
      lock_write(true, expires_in: described_class::LOCK_TTL)

      stub_const("#{described_class}::LOCK_WAIT", 0)

      stub_oauth(granted_response)
    end

    context 'when another thread published its token meanwhile' do
      before { EncryptedCache.write(described_class::CACHE_KEY, 'token-from-the-other-thread') }

      it { is_expected.to be_a_success }

      its(:token) { is_expected.to eq 'token-from-the-other-thread' }

      it 'does not call INSEE API' do
        retrieve_token

        expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
      end
    end

    context 'when another thread publishes its token while this one waits' do
      before do
        allow(Rails.cache).to receive(:write).and_wrap_original do |original, *args, **options|
          publish_the_other_thread_token if args.first == described_class::LOCK_CACHE_KEY

          original.call(*args, **options)
        end
      end

      it { is_expected.to be_a_success }

      its(:token) { is_expected.to eq 'token-from-the-other-thread' }

      it 'does not call INSEE API' do
        retrieve_token

        expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
      end
    end

    context 'when the other thread published nothing' do
      it { is_expected.to be_a_failure }

      it 'fails temporarily instead of burning an attempt' do
        expect(retrieve_token.errors.first).to be_a(ProviderTemporaryError)
      end

      it 'does not call INSEE API' do
        retrieve_token

        expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
      end
    end
  end

  describe 'lock release' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(granted_response)
    end

    after { Timecop.return }

    it 'releases the lock on success' do
      retrieve_token

      expect(lock_read).to be_nil
    end

    context 'when the authentication fails' do
      before { stub_oauth(status: 503, body: '') }

      it 'releases the lock too' do
        retrieve_token

        expect(lock_read).to be_nil
      end
    end

    context 'when the OAuth exchange is in flight' do
      let(:observed) { {} }

      before do
        stub_request(:post, /#{insee_oauth_url}/).to_return do
          observed[:beside_token] = lock_read
          observed[:in_guard_namespace] = guard_read(described_class::LOCK_CACHE_KEY)

          granted_response
        end
      end

      it 'holds the lock where the token lives' do
        retrieve_token

        expect(observed[:beside_token]).to be_present
      end

      it 'keeps it out of the namespace the failure guard shares' do
        retrieve_token

        expect(observed[:in_guard_namespace]).to be_nil
      end
    end

    context 'when the lock was taken over while authenticating' do
      before do
        stub_request(:post, /#{insee_oauth_url}/).to_return do
          lock_write('the-successor', expires_in: described_class::LOCK_TTL)

          granted_response
        end
      end

      it 'leaves the successor lock alone' do
        retrieve_token

        expect(lock_read).to eq('the-successor')
      end
    end
  end

  context 'when INSEE refuses the OAuth exchange itself' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      stub_oauth(
        status: 400,
        body: { error: 'invalid_client' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    after { Timecop.return }

    it { is_expected.to be_a_failure }

    it 'stops after the first candidate' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
    end

    it 'holds back the next authentications' do
      retrieve_token

      expect(guard_read(INSEE::AuthenticationBackoff::HOLD_CACHE_KEY)).to be(true)
    end
  end

  context 'when the cache is unavailable' do
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      allow(Rails.cache).to receive_messages(read: nil, write: nil, delete: false)

      stub_oauth(granted_response)
    end

    after { Timecop.return }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq token }

    it 'costs a single OAuth call' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
    end
  end

  describe '.invalidate_token_cache!' do
    it 'drops the token the provider rejected' do
      EncryptedCache.write(described_class::CACHE_KEY, 'rejected-token')

      described_class.invalidate_token_cache!('rejected-token')

      expect(EncryptedCache.read(described_class::CACHE_KEY)).to be_nil
    end

    it 'keeps a token a sibling thread published in the meantime' do
      EncryptedCache.write(described_class::CACHE_KEY, 'refreshed-token')

      described_class.invalidate_token_cache!('rejected-token')

      expect(EncryptedCache.read(described_class::CACHE_KEY)).to eq('refreshed-token')
    end
  end
end
