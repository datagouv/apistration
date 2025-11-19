RSpec.describe 'Rack::Attack config for API Particulier V2', api: :particulier do
  after { Rack::Attack.reset! }

  context 'with a blacklisted token' do
    subject(:make_call) do
      get '/api/v2/etudiants', headers: headers_params
    end

    let(:token) { TokenFactory.new([]).valid(uid: Seeds.new.blacklisted_jwt_id) }

    let(:headers_params) { { 'X-Api-key' => token } }

    it 'returns 401' do
      make_call

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a message associated to blacklist token' do
      make_call

      expect(response_json[:errors].first).to eq('Votre jeton est sur liste noire, celui-ci a certainement été divulgué sur un canal non-sécurisé. Vous pouvez trouver un jeton valide sur votre espace personnel: https://particulier.api.gouv.fr/compte')
    end

    it 'errors with flat format' do
      make_call

      expect(response_json).to have_flat_format_error
    end
  end

  describe 'API Particulier V2 throttle isolation', if: ENV['WITH_FLAKY_TESTS'] == 'true' do
    let(:v2_path) { '/api/v2/test_endpoint' }
    let(:v3_path) { '/api/v3/test_endpoint_v2' }
    let(:api_key) { 'test_api_key_12345' }
    let(:particulier_host) { 'particulier.api.gouv.fr' }
    let(:entreprise_host) { 'entreprise.api.gouv.fr' }

    before do
      Rack::Attack.cache.store.clear
    end

    it 'throttles V2 requests with API key on particulier host' do
      21.times do
        get v2_path, headers: { 'HTTP_X_API_KEY' => api_key, 'HTTP_HOST' => particulier_host }
      end

      expect(response).to have_http_status(:too_many_requests)
    end

    it 'does not throttle V3 requests with API key on particulier host' do
      21.times do
        get v3_path, headers: { 'HTTP_X_API_KEY' => api_key, 'HTTP_HOST' => particulier_host }
      end

      expect(response).not_to have_http_status(:too_many_requests)
    end

    it 'does not throttle V2 requests without API key' do
      21.times do
        get v2_path, headers: { 'HTTP_HOST' => particulier_host }
      end

      expect(response).not_to have_http_status(:too_many_requests)
    end

    it 'does not throttle V2 requests on non-particulier host' do
      21.times do
        get v2_path, headers: { 'HTTP_X_API_KEY' => api_key, 'HTTP_HOST' => entreprise_host }
      end

      expect(response).not_to have_http_status(:too_many_requests)
    end

    it 'prevents duplicate throttling on V3 endpoints with API key' do
      21.times do
        get v3_path, headers: { 'HTTP_X_API_KEY' => api_key, 'HTTP_HOST' => particulier_host }
      end

      throttle_match_type = response.request.env['rack.attack.match_type']
      throttle_discriminator = response.request.env['rack.attack.matched']

      expect(throttle_discriminator).not_to eq('API Particulier V2 global limit') if throttle_match_type == :throttle
    end
  end
end
