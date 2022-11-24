RSpec.describe 'Rack::Attack config for API Entreprise', api: :particulier do
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
end
