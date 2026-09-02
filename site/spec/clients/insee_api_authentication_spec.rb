RSpec.describe INSEEAPIAuthentication do
  subject(:authentication) { described_class.new }

  let(:token) { 'a-fresh-insee-token' }

  def insee_cache_write(key, value, **)
    Rails.cache.write(key, value, namespace: described_class::CACHE_NAMESPACE, **)
  end

  def insee_cache_read(key)
    Rails.cache.read(key, namespace: described_class::CACHE_NAMESPACE)
  end

  def stub_oauth(*responses)
    stub_request(:post, described_class::OAUTH_URL).to_return(*responses)
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

        expect(WebMock).not_to have_requested(:post, described_class::OAUTH_URL)
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

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).once
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

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).twice
      end

      it 'sends the previous password as second candidate' do
        authentication.access_token

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL)
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

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).once
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

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).once
      end
    end

    context 'when INSEE times out' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_request(:post, described_class::OAUTH_URL).to_timeout
      end

      after { Timecop.return }

      it 'raises a temporary error' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
      end

      it 'does not try the second candidate' do
        expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).once
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

      it 'tries each candidate exactly once' do
        expect { authentication.access_token }.to raise_error(described_class::AuthenticationError)

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).twice
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

        expect(WebMock).to have_requested(:post, described_class::OAUTH_URL).twice
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

          expect(WebMock).not_to have_requested(:post, described_class::OAUTH_URL)
        end
      end

      context 'when the other thread published nothing' do
        it 'raises a temporary error instead of burning an attempt' do
          expect { authentication.access_token }.to raise_error(described_class::TemporaryError)
        end

        it 'does not call INSEE' do
          expect { authentication.access_token }.to raise_error(described_class::TemporaryError)

          expect(WebMock).not_to have_requested(:post, described_class::OAUTH_URL)
        end
      end
    end

    describe 'lock ownership' do
      before do
        stub_request(:post, described_class::OAUTH_URL).to_return do
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

    it 'reports an unavailable OAuth' do
      stub_oauth(status: 500, body: '')

      expect(authentication.attempt('SomeP4ssword!').status).to eq(:unavailable)
    end

    it 'reports a timeout as unavailable' do
      stub_request(:post, described_class::OAUTH_URL).to_timeout

      expect(authentication.attempt('SomeP4ssword!').status).to eq(:unavailable)
    end
  end
end
