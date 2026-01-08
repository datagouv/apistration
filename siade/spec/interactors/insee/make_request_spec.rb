RSpec.describe INSEE::MakeRequest, type: :interactor do
  subject(:make_request) { INSEE::UniteLegale::MakeRequest.call(params:, token:) }

  let(:params) { { siren: '123456789' } }
  let(:token) { 'initial_token' }
  let(:new_token) { 'refreshed_token' }
  let(:insee_sirene_url) { Siade.credentials[:insee_sirene_url] }
  let(:insee_oauth_url) { Siade.credentials[:insee_oauth_url] }

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

      it { is_expected.to be_a_success }

      it 'only retries once' do
        make_request

        expect(WebMock).to have_requested(:get, /#{insee_sirene_url}/).twice
        expect(WebMock).to have_requested(:post, /#{insee_oauth_url}/).once
      end

      its(:response) { is_expected.to be_a(Net::HTTPUnauthorized) }
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
end
