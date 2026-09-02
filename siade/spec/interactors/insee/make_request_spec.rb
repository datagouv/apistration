RSpec.describe INSEE::MakeRequest, type: :interactor do
  subject(:make_request) { INSEE::UniteLegale::MakeRequest.call(params:, token:) }

  let(:params) { { siren: '123456789' } }
  let(:token) { 'initial_token' }
  let(:new_token) { 'refreshed_token' }
  let(:insee_sirene_url) { Siade.credentials[:insee_sirene_url] }
  let(:insee_oauth_url) { Siade.credentials[:insee_oauth_url] }
  let(:renew_url) { %r{#{insee_sirene_url}/api-sirene/prive/3.11/renouvellement} }

  def stub_expired_token_response
    stub_request(:get, /#{insee_sirene_url}/)
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(status: 401, body: '{"header":{"statut":401,"message":"Jeton invalide ou jeton expiré"}}')
  end

  describe 'retry on 401 token expired' do
    before do
      EncryptedCache.write(INSEE::Authenticate::CACHE_KEY, token)
    end

    context 'when first request returns 401 and retry succeeds' do
      before do
        stub_expired_token_response

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

      it 'retries with the new token' do
        make_request

        expect(WebMock).to have_requested(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{new_token}" })
      end

      it 'authenticates only once' do
        make_request

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
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

    context 'when first request returns 401 and every password candidate is rejected' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_expired_token_response

        stub_request(:post, /#{insee_oauth_url}/)
          .to_return(
            status: 401,
            body: { error: 'invalid_grant', error_description: 'Invalid user credentials' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        allow(MonitoringService.instance).to receive(:track_with_added_context)
      end

      after { Timecop.return }

      it { is_expected.to be_a_failure }

      it 'tries each candidate exactly once' do
        make_request

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
      end

      it 'fails with a ProviderAuthenticationError' do
        expect(make_request.errors.first).to be_a(ProviderAuthenticationError)
      end

      it 'does not retry the API call after the authentication failure' do
        make_request

        expect(WebMock).to have_requested(:get, /#{insee_sirene_url}/).once
      end
    end

    context 'when first request returns 401 and the first password candidate is rejected' do
      before do
        Timecop.freeze(Date.new(2027, 1, 15))

        stub_expired_token_response

        stub_request(:post, /#{insee_oauth_url}/)
          .to_return(
            { status: 401, body: { error: 'invalid_grant' }.to_json, headers: { 'Content-Type' => 'application/json' } },
            { status: 200, body: { access_token: new_token, expires_in: 3600 }.to_json, headers: { 'Content-Type' => 'application/json' } }
          )

        stub_request(:get, /#{insee_sirene_url}/)
          .with(headers: { 'Authorization' => "Bearer #{new_token}" })
          .to_return(status: 200, body: '{"uniteLegale":{}}')
      end

      after { Timecop.return }

      it { is_expected.to be_a_success }

      it 'falls back on the second candidate' do
        make_request

        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).twice
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
        expect { make_request }.not_to(change { EncryptedCache.read(INSEE::Authenticate::CACHE_KEY) })
      end
    end

    context 'when 401 but another thread already refreshed the token' do
      let(:token_from_other_thread) { 'token_from_other_thread' }

      before do
        stub_expired_token_response

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
    before do
      Timecop.freeze(Date.new(2027, 1, 15))

      EncryptedCache.write(INSEE::Authenticate::CACHE_KEY, token)

      stub_request(:get, /#{insee_sirene_url}/)
        .to_return(status: 200, body: '{"uniteLegale":{}}')
    end

    after { Timecop.return }

    it 'never renews the password from the request path' do
      make_request

      expect(WebMock).not_to have_requested(:post, renew_url)
    end
  end
end
