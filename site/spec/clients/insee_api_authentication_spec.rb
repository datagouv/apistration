RSpec.describe INSEEAPIAuthentication do
  subject(:authentication) { described_class.new }

  let(:token) { 'a-fresh-insee-token' }

  def insee_cache_write(key, value, **)
    Rails.cache.write(key, value, namespace: described_class::CACHE_NAMESPACE, **)
  end

  def insee_cache_read(key)
    Rails.cache.read(key, namespace: described_class::CACHE_NAMESPACE)
  end

  def arm_the_failure_guard
    insee_cache_write(described_class::FAILURE_CACHE_KEY, true, expires_in: described_class::FAILURE_TTL)
  end

  def stub_oauth(*responses)
    stub_request(:post, INSEEOAuthExchange::OAUTH_URL).to_return(*responses)
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

  describe '#access_token' do
    context 'when a token is cached' do
      before do
        insee_cache_write(described_class::TOKEN_CACHE_KEY, 'cached-token')
        stub_oauth(granted_response)
      end

      it 'returns it' do
        expect(authentication.access_token).to eq('cached-token')
      end

      it 'does not call INSEE' do
        authentication.access_token

        expect(WebMock).not_to have_requested(:post, INSEEOAuthExchange::OAUTH_URL)
      end
    end

    context 'when the first candidate is granted' do
      before { stub_oauth(granted_response) }

      it 'returns the token' do
        expect(authentication.access_token).to eq(token)
      end

      it 'caches it until it expires' do
        authentication.access_token

        expect(insee_cache_read(described_class::TOKEN_CACHE_KEY)).to eq(token)
      end

      it 'calls INSEE once' do
        authentication.access_token

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end

      it 'releases the single flight lock' do
        authentication.access_token

        expect(insee_cache_read(described_class::LOCK_CACHE_KEY)).to be_nil
      end
    end

    context 'when the first candidate is rejected with invalid_grant' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_oauth(invalid_grant_response, granted_response)
      end

      after { Timecop.return }

      it 'falls back on the second candidate' do
        expect(authentication.access_token).to eq(token)
      end

      it 'tries each candidate exactly once' do
        authentication.access_token

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).twice
      end

      it 'sends the previous password as second candidate' do
        authentication.access_token

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL)
          .with(body: hash_including('password' => INSEE::PasswordDerivation.previous_password))
      end
    end

    context 'when INSEE is unavailable' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_oauth(status: 503, body: '')
      end

      after { Timecop.return }

      it 'raises a temporary error' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
      end

      it 'does not try the second candidate' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end

      it 'does not remember the failure' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(insee_cache_read(described_class::FAILURE_CACHE_KEY)).to be_nil
      end

      it 'releases the single flight lock' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(insee_cache_read(described_class::LOCK_CACHE_KEY)).to be_nil
      end
    end

    context 'when INSEE rate limits the OAuth exchange' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_oauth(status: 429, body: '', headers: { 'Retry-After' => '2' })
      end

      after { Timecop.return }

      it 'raises a temporary error' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
      end

      it 'does not try the second candidate' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end

      it 'does not remember the failure' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(insee_cache_read(described_class::FAILURE_CACHE_KEY)).to be_nil
      end
    end

    context 'when INSEE answers with a request timeout' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_oauth(status: 408, body: '')
      end

      after { Timecop.return }

      it 'raises a temporary error' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
      end

      it 'does not remember the failure' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(insee_cache_read(described_class::FAILURE_CACHE_KEY)).to be_nil
      end
    end

    context 'when INSEE answers with a non JSON body' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_oauth(status: 200, body: '<html>gateway</html>')
      end

      after { Timecop.return }

      it 'raises a temporary error' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
      end

      it 'does not try the second candidate' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end
    end

    context 'when INSEE times out' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_request(:post, INSEEOAuthExchange::OAUTH_URL).to_timeout
      end

      after { Timecop.return }

      it 'raises a temporary error' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
      end

      it 'does not try the second candidate' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end
    end

    context 'when every candidate is rejected with invalid_grant' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_oauth(invalid_grant_response)
        allow(MonitoringService.instance).to receive(:track)
      end

      after { Timecop.return }

      it 'raises an authentication error' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)
      end

      it 'tries each candidate then the current password once more' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).times(3)
      end

      it 'alerts on both hypotheses' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(MonitoringService.instance).to have_received(:track).with(
          'INSEE authentication failed on every candidate: password desynchronized or account locked',
          level: :error,
          context: hash_including(period: '2027-01')
        )
      end

      it 'remembers the failure' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(authentication).to be_recently_failed
      end

      it 'does not call INSEE again while the failure is remembered' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)
        expect { described_class.new.access_token }.to raise_error(described_class::TemporaryError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).times(3)
      end
    end

    context 'when a rotation renewed the password while the candidates were tried' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_oauth(invalid_grant_response, invalid_grant_response, granted_response)
        allow(MonitoringService.instance).to receive(:track)
      end

      after { Timecop.return }

      it 'authenticates with the password INSEE now holds' do
        expect(authentication.access_token).to eq(token)
      end

      it 'does not remember a failure' do
        authentication.access_token

        expect(authentication).not_to be_recently_failed
      end

      it 'does not alert' do
        authentication.access_token

        expect(MonitoringService.instance).not_to have_received(:track)
      end
    end

    context 'when the static password is rejected before derivation starts' do
      before do
        Timecop.freeze(Date.new(2026, 10, 31))
        stub_oauth(invalid_grant_response)
        allow(MonitoringService.instance).to receive(:track)
      end

      after { Timecop.return }

      it 'stops after one attempt' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end
    end

    context 'when the bypass and current passwords are both rejected' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))
        AdminApientreprise.credentials[INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY] = 'ByPass#Password1'
        stub_oauth(invalid_grant_response)
        allow(MonitoringService.instance).to receive(:track)
      end

      after do
        AdminApientreprise.credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
        Timecop.return
      end

      it 'does not retry the current password it just rejected' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).twice
        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL)
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

      it 'raises a temporary error' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
      end

      it 'spends none of the attempts the guard was meant to save' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(WebMock).not_to have_requested(:post, INSEEOAuthExchange::OAUTH_URL)
      end

      it 'releases the single flight lock' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(insee_cache_read(described_class::LOCK_CACHE_KEY)).to be_nil
      end
    end

    describe 'single flight' do
      before do
        insee_cache_write(described_class::LOCK_CACHE_KEY, true, expires_in: described_class::LOCK_TTL)

        stub_const("#{described_class}::LOCK_WAIT", 0)

        stub_oauth(granted_response)
      end

      context 'when another thread published its token meanwhile' do
        before { insee_cache_write(described_class::TOKEN_CACHE_KEY, 'token-from-the-other-thread') }

        it 'returns that token' do
          expect(authentication.access_token).to eq('token-from-the-other-thread')
        end

        it 'does not call INSEE' do
          authentication.access_token

          expect(WebMock).not_to have_requested(:post, INSEEOAuthExchange::OAUTH_URL)
        end
      end

      context 'when another thread publishes its token while this one waits' do
        before do
          allow(Rails.cache).to receive(:write).and_wrap_original do |original, *args, **options|
            insee_cache_write(described_class::TOKEN_CACHE_KEY, 'token-from-the-other-thread') if args.first == described_class::LOCK_CACHE_KEY

            original.call(*args, **options)
          end
        end

        it 'returns that token' do
          expect(authentication.access_token).to eq('token-from-the-other-thread')
        end

        it 'does not call INSEE' do
          authentication.access_token

          expect(WebMock).not_to have_requested(:post, INSEEOAuthExchange::OAUTH_URL)
        end
      end

      context 'when the other thread published nothing' do
        it 'raises a temporary error instead of burning an attempt' do
          expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
        end

        it 'does not call INSEE' do
          expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

          expect(WebMock).not_to have_requested(:post, INSEEOAuthExchange::OAUTH_URL)
        end
      end
    end

    context 'when INSEE refuses the OAuth exchange itself' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        allow(MonitoringService.instance).to receive(:track)

        stub_oauth(status: 400, body: { error: 'invalid_client' }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      after { Timecop.return }

      it 'raises an authentication error' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)
      end

      it 'stops after the first candidate' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end

      it 'holds back the next authentications' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(insee_cache_read(described_class::FAILURE_CACHE_KEY)).to be(true)
      end
    end

    describe 'when the cache is unavailable' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        allow(Rails.cache).to receive_messages(read: nil, write: nil, delete: false)

        stub_oauth(granted_response)
      end

      after { Timecop.return }

      it 'authenticates instead of waiting on a lock nobody holds' do
        expect(authentication.access_token).to eq(token)
      end

      it 'costs a single OAuth call' do
        authentication.access_token

        expect(WebMock).to have_requested(:post, INSEEOAuthExchange::OAUTH_URL).once
      end
    end

    describe 'lock acquisition' do
      it 'tells a taken lock from an unreachable cache' do
        expect(authentication.send(:acquire_lock!)).to be(true)
        expect(authentication.send(:acquire_lock!)).to be(false)
      end
    end

    describe 'lock ownership' do
      before do
        stub_request(:post, INSEEOAuthExchange::OAUTH_URL).to_return do
          insee_cache_write(described_class::LOCK_CACHE_KEY, 'the-successor', expires_in: described_class::LOCK_TTL)

          granted_response
        end
      end

      it 'leaves alone a lock taken over while it was authenticating' do
        authentication.access_token

        expect(insee_cache_read(described_class::LOCK_CACHE_KEY)).to eq('the-successor')
      end
    end
  end

  describe '.invalidate_token_cache!' do
    it 'drops the token the provider rejected' do
      insee_cache_write(described_class::TOKEN_CACHE_KEY, 'cached-token')

      described_class.invalidate_token_cache!('cached-token')

      expect(insee_cache_read(described_class::TOKEN_CACHE_KEY)).to be_nil
    end

    it 'keeps a token another request refreshed in the meantime' do
      insee_cache_write(described_class::TOKEN_CACHE_KEY, 'refreshed-token')

      described_class.invalidate_token_cache!('revoked-token')

      expect(insee_cache_read(described_class::TOKEN_CACHE_KEY)).to eq('refreshed-token')
    end
  end

  describe '.clear_guards!' do
    it 'releases the held back authentications' do
      insee_cache_write(described_class::FAILURE_CACHE_KEY, true, expires_in: described_class::FAILURE_TTL)

      described_class.clear_guards!

      expect(authentication).not_to be_recently_failed
    end

    it 'releases a lock left behind by a process that died mid authentication' do
      insee_cache_write(described_class::LOCK_CACHE_KEY, 'the-departed', expires_in: described_class::LOCK_TTL)

      described_class.clear_guards!

      expect(insee_cache_read(described_class::LOCK_CACHE_KEY)).to be_nil
    end
  end

  describe '#record_authentication_failure!' do
    before { allow(MonitoringService.instance).to receive(:track) }

    it 'holds back the next authentications' do
      authentication.record_authentication_failure!('desynchronized')

      expect(authentication).to be_recently_failed
    end

    it 'alerts' do
      authentication.record_authentication_failure!('desynchronized')

      expect(MonitoringService.instance).to have_received(:track).with('desynchronized', level: :error, context: hash_including(:period))
    end
  end

  describe '#attempt' do
    it 'ignores the cached token' do
      insee_cache_write(described_class::TOKEN_CACHE_KEY, 'cached-token')
      stub_oauth(granted_response)

      expect(authentication.attempt('SomeP4ssword!').token).to eq(token)
    end

    it 'does not cache the token it obtains' do
      stub_oauth(granted_response)

      authentication.attempt('SomeP4ssword!')

      expect(insee_cache_read(described_class::TOKEN_CACHE_KEY)).to be_nil
    end

    it 'reports a rejected password' do
      stub_oauth(invalid_grant_response)

      expect(authentication.attempt('SomeP4ssword!').status).to eq(:invalid_grant)
    end
  end
end
