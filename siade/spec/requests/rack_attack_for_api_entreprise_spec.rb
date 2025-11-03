RSpec.describe 'Rack::Attack config', api: :entreprise do
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  RSpec.shared_examples 'returns a 401 error' do
    let(:endpoint) do
      {
        controller: 'api_entreprise/v3_and_more/opqibi/certifications_ingenierie',
        api_version: 3,
        action: 'show',
        siren: '123'
      }
    end
    let(:url) { extract_without_context_url_for(**endpoint, only_path: true) }

    it 'returns 401' do
      get url, headers: headers_params

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message' do
      get url, headers: headers_params

      expect(response_json).to have_json_error(detail: 'Votre token n\'est pas valide ou n\'est pas renseigné')
    end
  end

  context 'when the Authorization header format (Bearer) is not respected' do
    it_behaves_like 'returns a 401 error' do
      let(:headers_params) { { 'Authorization' => 'Beer hour' } }
    end
  end

  context 'when the Authorization header is absent' do
    it_behaves_like 'returns a 401 error' do
      let(:headers_params) { { 'Umad' => 'Beer hour' } }
    end
  end

  context 'when Authorization header format (Bearer) is valid' do
    context 'when the provided token is not a valid JWT' do
      it_behaves_like 'returns a 401 error' do
        let(:headers_params) { { 'Umad' => 'Bearer hour' } }
      end
    end

    context 'when the token is absent' do
      it_behaves_like 'returns a 401 error' do
        let(:headers_params) { { 'Umad' => 'Bearer ' } }
      end
    end
  end

  context 'with a blacklisted token' do
    let(:token) { TokenFactory.new([]).valid(uid: Seeds.new.blacklisted_jwt_id) }
    let(:headers_params) { { 'Authorization' => "Bearer #{token}" } }

    let(:endpoint) do
      {
        controller: 'api_entreprise/v3_and_more/opqibi/certifications_ingenierie',
        api_version: 3,
        action: 'show',
        siren: 123
      }
    end
    let(:url) { extract_without_context_url_for(**endpoint, only_path: true) }

    it 'returns 401' do
      get url, headers: headers_params

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message associated to blacklisted token' do
      get url, headers: headers_params

      expect(response_json).to have_json_error(detail: match(
        %r{Votre jeton est sur liste noire, celui-ci a certainement été divulgué sur un canal non-sécurisé\. Vous pouvez trouver un jeton valide sur votre espace personnel: https://(entreprise|particulier)\.api\.gouv\.fr/compte}
      ))
    end
  end
end
