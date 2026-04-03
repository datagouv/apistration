RSpec.describe INSEE::MakeRequest, type: :interactor do
  subject(:make_request) { INSEE::UniteLegale::MakeRequest.call(params:, token:) }

  let(:params) { { siren: '123456789' } }
  let(:token) { 'initial_token' }
  let(:new_token) { 'refreshed_token' }
  let(:insee_sirene_url) { Siade.credentials[:insee_sirene_url] }
  let(:insee_oauth_url) { Siade.credentials[:insee_oauth_url] }

  def jwt_token_with_pwd_changed_time(time_string)
    payload = { 'pwdChangedTime' => time_string }
    JWT.encode(payload, nil, 'none')
  end

  describe 'retry on 401 token expired' do
    before do
      EncryptedCache.write('insee/authenticate', token)
    end

    context 'when first request returns 401 and retry succeeds' do
      before do
        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 401, body: '{"header":{"statut":401,"message":"Jeton invalide ou jeton expiré"}}')

        stub_request(:post, /#{insee_oauth_url}/)
          .to_return(
            status: 200,
            body: { access_token: new_token, expires_in: 3600 }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{new_token}" })
          .to_return(status: 200, body: '{"uniteLegale":{}}')
      end

      it { is_expected.to be_a_success }

      it 'invalidates the cached token' do
        expect { make_request }.to change { EncryptedCache.read('insee/authenticate') }.from(token)
      end

      it 'retries with the new token' do
        make_request

        expect(WebMock).to have_requested(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{new_token}" })
      end

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end

    context 'when first request returns 401 and retry also returns 401' do
      before do
        stub_request(:get, /#{insee_sirene_url}/)
          .to_return(status: 401, body: '{"header":{"statut":401,"message":"Jeton invalide ou jeton expiré"}}')

        stub_request(:post, /#{insee_oauth_url}/)
          .to_return(
            status: 200,
            body: { access_token: new_token, expires_in: 3600 }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { is_expected.to be_a_failure }

      it 'only retries once' do
        make_request

        expect(WebMock).to have_requested(:get, /#{insee_sirene_url}/).twice
        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
      end

      it 'fails with a ProviderTemporaryError' do
        expect(make_request.errors.first).to be_a(ProviderTemporaryError)
      end

      it 'has a custom detail message' do
        expect(make_request.errors.first.detail).to eq(
          "Erreur d'authentification temporaire auprès de l'INSEE, merci de réessayer votre appel"
        )
      end

      it 'includes retry_in in meta' do
        expect(make_request.errors.first.meta).to include(retry_in: 10)
      end
    end

    context 'when first request returns 401 and OAuth authentication fails temporarily' do
      let(:created_instances) { [] }

      before do
        allow(INSEE::UniteLegale::MakeRequest).to receive(:new).and_wrap_original do |method, *args|
          method.call(*args).tap do |instance|
            allow(instance).to receive(:sleep)
            created_instances << instance
          end
        end

        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 401, body: '{"header":{"statut":401,"message":"Jeton invalide ou jeton expiré"}}')

        stub_request(:post, /#{insee_oauth_url}/)
          .to_return(
            status: 401,
            body: { error: 'invalid_grant', error_description: 'Invalid user credentials' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { is_expected.to be_a_failure }

      it 'retries authentication 5 times before giving up' do
        make_request

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).times(5)
      end

      it 'sleeps between auth retries' do
        make_request

        expect(created_instances.last).to have_received(:sleep).with(0.2).exactly(4).times
      end

      it 'fails with a ProviderTemporaryError' do
        expect(make_request.errors.first).to be_a(ProviderTemporaryError)
      end

      it 'does not retry the API call after auth failure' do
        make_request

        expect(WebMock).to have_requested(:get, /#{insee_sirene_url}/).once
      end
    end

    context 'when first request returns 401 and OAuth fails then succeeds' do
      let(:created_instances) { [] }

      before do
        allow(INSEE::UniteLegale::MakeRequest).to receive(:new).and_wrap_original do |method, *args|
          method.call(*args).tap do |instance|
            allow(instance).to receive(:sleep)
            created_instances << instance
          end
        end

        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 401, body: '{"header":{"statut":401,"message":"Jeton invalide ou jeton expiré"}}')

        stub_request(:post, /#{insee_oauth_url}/)
          .to_return(
            { status: 401, body: { error: 'invalid_grant' }.to_json, headers: { 'Content-Type' => 'application/json' } },
            { status: 401, body: { error: 'invalid_grant' }.to_json, headers: { 'Content-Type' => 'application/json' } },
            { status: 200, body: { access_token: new_token, expires_in: 3600 }.to_json, headers: { 'Content-Type' => 'application/json' } }
          )

        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{new_token}" })
          .to_return(status: 200, body: '{"uniteLegale":{}}')
      end

      it { is_expected.to be_a_success }

      it 'retries authentication until it succeeds' do
        make_request

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).times(3)
      end

      it 'sleeps between failed auth attempts' do
        make_request

        expect(created_instances.last).to have_received(:sleep).with(0.2).twice
      end
    end

    context 'when first request succeeds' do
      before do
        stub_request(:get, /#{insee_sirene_url}/)
          .to_return(status: 200, body: '{"uniteLegale":{}}')
      end

      it { is_expected.to be_a_success }

      it 'does not refresh the token' do
        make_request

        expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
      end

      it 'keeps the cached token' do
        expect { make_request }.not_to(change { EncryptedCache.read('insee/authenticate') })
      end
    end

    context 'when 401 but another thread already refreshed the token' do
      let(:token_from_other_thread) { 'token_from_other_thread' }

      before do
        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 401, body: '{"header":{"statut":401,"message":"Jeton invalide ou jeton expiré"}}')

        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{token_from_other_thread}" })
          .to_return(status: 200, body: '{"uniteLegale":{}}')

        EncryptedCache.write(INSEE::Authenticate::CACHE_KEY, token_from_other_thread)
      end

      it { is_expected.to be_a_success }

      it 'uses the fresh token from cache without OAuth call' do
        make_request

        expect(WebMock).not_to have_requested(:post, /#{insee_oauth_url}/)
      end

      it 'retries with the fresh cached token' do
        make_request

        expect(WebMock).to have_requested(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{token_from_other_thread}" })
      end
    end
  end

  describe 'password rotation' do
    let(:renew_url) { %r{#{insee_sirene_url}/api-sirene/prive/3.11/renouvellement} }

    before do
      EncryptedCache.write('insee/authenticate', token)
    end

    after do
      Timecop.return
      RedisService.new.del(INSEE::MakeRequest::ROTATION_LOCK_KEY)
    end

    context 'when pwdChangedTime is in a previous bimester' do
      let(:token) { jwt_token_with_pwd_changed_time('2026-08-15T10:00:00Z') }

      before do
        Timecop.freeze(Date.new(2026, 9, 15))

        stub_request(:get, /#{insee_sirene_url}/)
          .to_return(status: 200, body: '{"uniteLegale":{}}')

        stub_request(:post, renew_url)
          .to_return(status: 200, body: '{}')
      end

      it 'calls the renewal API' do
        make_request

        expect(WebMock).to have_requested(:post, renew_url)
      end

      it 'sends old and new passwords' do
        make_request

        expect(WebMock).to have_requested(:post, renew_url)
          .with(body: {
            oldPassword: INSEE::PasswordDerivation.previous_password,
            newPassword: INSEE::PasswordDerivation.current_password
          }.to_json)
      end

    end

    context 'when pwdChangedTime is in the current bimester' do
      let(:token) { jwt_token_with_pwd_changed_time('2026-09-10T10:00:00Z') }

      before do
        Timecop.freeze(Date.new(2026, 9, 15))

        stub_request(:get, /#{insee_sirene_url}/)
          .to_return(status: 200, body: '{"uniteLegale":{}}')
      end

      it 'does not call the renewal API' do
        make_request

        expect(WebMock).not_to have_requested(:post, renew_url)
      end
    end

    context 'when the token is not a valid JWT' do
      let(:token) { 'not-a-jwt' }

      before do
        stub_request(:get, /#{insee_sirene_url}/)
          .to_return(status: 200, body: '{"uniteLegale":{}}')
      end

      it 'does not attempt rotation' do
        make_request

        expect(WebMock).not_to have_requested(:post, renew_url)
      end
    end

    context 'when the rotation lock is already held' do
      let(:token) { jwt_token_with_pwd_changed_time('2026-08-15T10:00:00Z') }

      before do
        Timecop.freeze(Date.new(2026, 9, 15))

        RedisService.new.set(
          INSEE::MakeRequest::ROTATION_LOCK_KEY,
          true,
          nx: true,
          ex: INSEE::MakeRequest::ROTATION_LOCK_TTL
        )

        stub_request(:get, /#{insee_sirene_url}/)
          .to_return(status: 200, body: '{"uniteLegale":{}}')
      end

      after do
        RedisService.new.del(INSEE::MakeRequest::ROTATION_LOCK_KEY)
      end

      it 'does not call the renewal API' do
        make_request

        expect(WebMock).not_to have_requested(:post, renew_url)
      end
    end
  end
end
