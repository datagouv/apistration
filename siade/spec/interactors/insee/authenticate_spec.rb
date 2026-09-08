RSpec.describe INSEE::Authenticate, type: :interactor do
  def guard_write(key, value, **)
    Rails.cache.write(key, value, namespace: described_class::GUARD_CACHE_NAMESPACE, **)
  end

  def guard_read(key)
    Rails.cache.read(key, namespace: described_class::GUARD_CACHE_NAMESPACE)
  end

  def lock_write(value, **)
    Rails.cache.write(described_class::LOCK_CACHE_KEY, value, **)
  end

  def lock_read
    Rails.cache.read(described_class::LOCK_CACHE_KEY)
  end

  def arm_the_failure_guard
    guard_write(described_class::FAILURE_CACHE_KEY, true, expires_in: described_class::FAILURE_TTL)
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

  def granted_response(access_token: 'a-fresh-insee-token', expires_in: 598_077)
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

      expect(guard_read(described_class::FAILURE_CACHE_KEY)).to be_nil
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

      expect(guard_read(described_class::FAILURE_CACHE_KEY)).to be_nil
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

      expect(guard_read(described_class::FAILURE_CACHE_KEY)).to be_nil
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

    it 'remembers the failure for 30 minutes' do
      retrieve_token

      expect(guard_read(described_class::FAILURE_CACHE_KEY)).to be(true)
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

      expect(guard_read(described_class::FAILURE_CACHE_KEY)).to be_nil
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

      expect(guard_read(described_class::FAILURE_CACHE_KEY)).to be(true)
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
