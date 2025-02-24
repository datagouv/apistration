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

      expect(response_json).to have_json_error(detail: 'Votre jeton est sur liste noire, celui-ci a certainement été divulgué sur un canal non-sécurisé. Vous pouvez trouver un jeton valide sur votre espace personnel: https://particulier.api.gouv.fr/compte')
    end
  end

  context 'with valid api calls' do
    def call!
      get('/api/v2/etudiants-boursiers', headers: headers_params)
    end
    let(:headers_params) { { 'X-Api-key' => 'tumtumdulu' } }

    let(:rate_limit_subkeys) do
      %w[
        Limit
        Remaining
        Reset
      ]
    end

    it 'has rate limit headers defined' do
      call!

      rate_limit_subkeys.each do |subkey|
        expect(response.headers).to have_key("RateLimit-#{subkey}")
      end
    end

    context 'when the limit has not been reached' do
      before { 19.times { call! } }

      it 'accepts incoming requests' do
        call!
        expect(response).not_to have_http_status(:too_many_requests)
      end
    end

    context 'when the limit has been reached' do
      it 'rejects incoming requests after the limit' do
        Timecop.freeze do
          20.times { call! }
          call!

          expect(response).to have_http_status(:too_many_requests)
        end
      end
    end
  end
end
