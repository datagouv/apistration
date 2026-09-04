RSpec.describe INSEE::Authenticate, type: :interactor do
  def guard_write(key, value, **)
    Rails.cache.write(key, value, namespace: described_class::GUARD_CACHE_NAMESPACE, **)
  end

  def guard_read(key)
    Rails.cache.read(key, namespace: described_class::GUARD_CACHE_NAMESPACE)
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

    it 'tries each candidate exactly once' do
      retrieve_token

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
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

      expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
    end

    it 'fails temporarily while the failure is remembered' do
      retrieve_token

      expect(described_class.call(provider_name: 'INSEE').errors.first).to be_a(ProviderTemporaryError)
    end
  end

  describe 'single flight' do
    before do
      guard_write(described_class::LOCK_CACHE_KEY, true, expires_in: described_class::LOCK_TTL)

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

      expect(guard_read(described_class::LOCK_CACHE_KEY)).to be_nil
    end

    context 'when the authentication fails' do
      before { stub_oauth(status: 503, body: '') }

      it 'releases the lock too' do
        retrieve_token

        expect(guard_read(described_class::LOCK_CACHE_KEY)).to be_nil
      end
    end

    context 'when the lock was taken over while authenticating' do
      before do
        stub_request(:post, /#{insee_oauth_url}/).to_return do
          guard_write(described_class::LOCK_CACHE_KEY, 'the-successor', expires_in: described_class::LOCK_TTL)

          granted_response
        end
      end

      it 'leaves the successor lock alone' do
        retrieve_token

        expect(guard_read(described_class::LOCK_CACHE_KEY)).to eq('the-successor')
      end
    end
  end
end
