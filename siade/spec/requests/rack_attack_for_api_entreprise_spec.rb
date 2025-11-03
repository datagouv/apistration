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

  describe 'all throttled endpoints' do
    let(:all_routes) do
      Rails.application.routes.routes.each_with_object([]) do |route, res|
        next if route.defaults == {}
        next if route.defaults[:controller] =~ %r{api_particulier/v2/}

        route_conf = {
          controller: route.defaults[:controller],
          action: route.defaults[:action]
        }
        res.push(route_conf) unless non_throttled_endpoints.include?(route_conf)
      end
    end

    let(:non_throttled_endpoints) do
      [
        {
          controller: 'api_entreprise/privileges',
          action: 'show'
        },
        {
          controller: 'ping',
          action: 'show'
        },
        {
          controller: 'errors',
          action: 'not_found'
        },
        {
          controller: 'errors',
          action: 'gone'
        },
        {
          controller: 'reload_mock_backend',
          action: 'create'
        },
        {
          controller: 'api_entreprise/ping_providers',
          action: 'show'
        },
        {
          controller: 'api_entreprise/ping_providers',
          action: 'index'
        },
        {
          controller: 'api_entreprise/privileges',
          action: 'index'
        },
        {
          controller: 'api_particulier/france_connect_jwks',
          action: 'show'
        },
        {
          controller: 'api_particulier/ping_providers',
          action: 'show'
        },
        {
          controller: 'api_particulier/ping_providers',
          action: 'index'
        }
      ]
    end

    let(:throttle_config) { Rails.application.config_for(:throttle) }

    let(:throttled_endpoints) do
      config = throttle_config.values.pluck(:endpoints).flatten

      config.map { |conf| conf.slice(:controller, :action) }.uniq
    end

    it 'throttles the resources' do
      expect(all_routes.uniq).to match_array(throttled_endpoints)
    end
  end
end
