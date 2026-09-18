RSpec.describe APIParticulier::V2::BaseController, 'authentication' do
  controller(described_class) do
    def show
      head :ok
    end
  end

  subject(:body) { JSON.parse(response.body, symbolize_names: true) }

  before do
    routes.draw { get 'show' => 'api_particulier/v2/base#show' }
  end

  context 'without any token' do
    before { get :show }

    it { expect(response).to have_http_status(:unauthorized) }

    it 'states the token is missing' do
      expect(body).to eq(
        error: 'access_denied',
        reason: "Votre token n'est pas renseigné",
        message: "Votre token n'est pas renseigné"
      )
    end
  end

  context 'with an invalid token given through X-Api-key' do
    before do
      request.headers['X-Api-key'] = 'bad_token'
      get :show
    end

    it { expect(response).to have_http_status(:unauthorized) }

    it 'states the token is invalid' do
      expect(body).to eq(
        error: 'access_denied',
        reason: "Votre token n'est pas valide",
        message: "Votre token n'est pas valide"
      )
    end
  end

  context 'with an invalid token given as a param' do
    before { get :show, params: { token: 'bad_token' } }

    it 'states the token is invalid' do
      expect(body).to eq(
        error: 'access_denied',
        reason: "Votre token n'est pas valide",
        message: "Votre token n'est pas valide"
      )
    end
  end
end
