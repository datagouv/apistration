RSpec.describe 'Rack::Attack config for API Entreprise', api: :particulier do
  after { Rack::Attack.reset! }

  context 'with a blacklisted token' do
    subject(:make_call) do
      get '/api/v2/etudiants', headers: headers_params
    end

    let(:token) { Rails.configuration.jwt_blacklist.sample }
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

  context 'with a valid token' do
    def call!
      get('/api/v2/etudiants-boursiers', params:)
    end

    let(:scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

    let(:token) { TokenFactory.new(scopes).valid }
    let(:ine) { '1234567890G' }
    let(:params) { { ine:, token: } }

    let(:rate_limit_subkeys) do
      %w[
        Limit
        Remaining
        Reset
      ]
    end

    before do
      mock_cnous_authenticate
      mock_cnous_valid_call('ine')
    end

    it 'accepts incoming requests up to the limit' do
      2.times do
        call!

        expect(response).to have_http_status(:ok)
        expect(response).not_to have_http_status(:too_many_requests)
      end
    end

    it 'has rate limit headers defined' do
      call!

      rate_limit_subkeys.each do |subkey|
        expect(response.headers).to have_key("RateLimit-#{subkey}")
      end
    end

    context 'when the limit has been reached' do
      before { 2.times { call! } }

      it 'rejects incoming requests after the limit' do
        call!

        expect(response).to have_http_status(:too_many_requests)
      end
    end
  end
end
