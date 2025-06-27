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

  RSpec.shared_examples 'throttling group of endpoints' do
    let(:token_sample) { yes_jwt }
    let(:another_token_sample) { TokenFactory.new([]).valid }

    before { Rails.cache.clear }

    def call!(token)
      url = extract_without_context_url_for(**endpoint, only_path: true)

      get(url, headers: { 'Authorization' => "Bearer #{token}" })
    end

    it 'accepts incoming requests up to the limit' do
      limit.times do
        call!(token_sample)

        expect(response).not_to have_http_status(:too_many_requests)
      end
    end

    context 'when the limit has been reached' do
      before do
        limit.times { call!(token_sample) }
      end

      it 'rejects incoming requests after the limit' do
        call!(token_sample)

        expect(response).to have_http_status(:too_many_requests)
      end

      it 'replies with the correct error message format' do
        call!(token_sample)

        expect(response_json).to have_json_error(
          code: '00429',
          title: 'Trop de requêtes',
          detail: 'Vous avez effectué trop de requêtes'
        )
      end

      it 'limits requests on a per token basis' do
        call!(another_token_sample)

        expect(response).not_to have_http_status(:too_many_requests)
      end

      it 'responds with the Retry-After header when off limit' do
        call!(token_sample)

        expect(response.headers).to include('Retry-After')
      end

      describe 'after period duration (seconds)' do
        before { Timecop.freeze(period.seconds.from_now) }
        after { Timecop.return }

        it 'resets the counter' do
          call!(token_sample)

          expect(response).not_to have_http_status(:too_many_requests)
        end
      end
    end

    context 'with a whitelisted token' do
      let(:token) { Rails.configuration.jwt_whitelist.sample }

      it 'has no limit' do
        limit.times { call!(token) }
        call!(token)

        expect(response).not_to have_http_status(:too_many_requests)
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

    context 'when the token is a valid JWT' do
      def limit_value_for_production(endpoints_list)
        config = YAML.safe_load(File.open(Rails.root.join('config/throttle.yml')))
        config.dig('production', endpoints_list, 'limit')
      end

      let(:throttle_config) { Rails.configuration.throttle }

      describe 'low latency document resources throttling' do
        it_behaves_like 'throttling group of endpoints' do
          let(:limit) { throttle_config.dig(:low_latency_documents, :limit) }
          let(:period) { throttle_config.dig(:low_latency_documents, :period) }

          let(:endpoint) do
            {
              controller: 'api_entreprise/v3_and_more/probtp/attestations_cotisation_retraite',
              action: 'show',
              api_version: 3,
              siret: '123'
            }
          end
        end
      end

      describe 'proxied files resources throttling' do
        it_behaves_like 'throttling group of endpoints' do
          let(:limit) { throttle_config.dig(:proxied_files, :limit) }
          let(:period) { throttle_config.dig(:proxied_files, :period) }

          let(:endpoint) do
            {
              controller: 'api_entreprise/proxied_files',
              action: 'show',
              api_version: 3,
              uuid: '123'
            }
          end
        end
      end

      describe 'JSON resources throttling Entreprise' do
        it_behaves_like 'throttling group of endpoints' do
          let(:limit) { throttle_config.dig(:json_resources_entreprise, :limit) }
          let(:period) { throttle_config.dig(:json_resources_entreprise, :period) }
          let(:endpoint) do
            {
              controller: 'api_entreprise/v3_and_more/insee/etablissements',
              action: 'show',
              api_version: 3,
              siret: '123'
            }
          end
        end
      end


      describe 'endpoints exceptions' do
        describe 'very high latency endpoints' do
          let(:limit) { throttle_config.dig(:high_latency_documents, :limit) }
          let(:period) { throttle_config.dig(:high_latency_documents, :period) }

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoint) do
              {
                controller: 'api_entreprise/v3_and_more/dgfip/attestations_fiscales',
                action: 'show',
                api_version: 3,
                siren: 123
              }
            end
          end
        end
      end
    end
  end

  describe 'RateLimit headers' do
    subject(:headers) do
      get endpoint, headers: { 'Authorization' => "Bearer #{token}" }
      response.headers
    end

    let(:token) { yes_jwt }
    let(:rate_limit_subkeys) do
      %w[
        Limit
        Remaining
        Reset
      ]
    end

    context 'with token in query params, with an endpoint which has a throttle config (non-regression test)' do
      subject(:headers) do
        get endpoint, params: { 'token' => token }
        response.headers
      end

      let(:endpoint) { '/v3/opqibi/unites_legales/0/certification_ingenierie' }
      let(:throttle_config) { Rails.configuration.throttle[:low_latency_documents] }

      it 'has rate limit headers defined' do
        rate_limit_subkeys.each do |subkey|
          expect(headers).to have_key("RateLimit-#{subkey}")
        end
      end
    end

    context 'with and endpoint which has no throttle config' do
      let(:endpoint) { '/privileges' }

      it 'has no rate limit headers defined' do
        rate_limit_subkeys.each do |subkey|
          expect(headers).not_to have_key("RateLimit-#{subkey}")
        end
      end
    end

    context 'with and endpoint which has a throttle config' do
      let(:endpoint) { '/v3/opqibi/unites_legales/0/certification_ingenierie' }
      let(:throttle_config) { Rails.configuration.throttle[:low_latency_documents] }

      context 'when the limit has not been reached' do
        it 'has rate limit headers defined' do
          rate_limit_subkeys.each do |subkey|
            expect(headers).to have_key("RateLimit-#{subkey}")
          end
        end

        it 'has a valid Limit value' do
          expect(headers['RateLimit-Limit']).to eq(throttle_config[:limit].to_s)
        end

        it 'has a valid Remaining value' do
          expect(headers['RateLimit-Remaining']).to eq((throttle_config[:limit] - 1).to_s)
        end

        it 'has a valid Reset value, which starts at the first call on this throttle' do
          Timecop.freeze(Time.zone.local(2021, 5, 3, 2))

          subject

          Timecop.travel(20.seconds.from_now)
          Timecop.freeze

          expect(headers['RateLimit-Reset']).to eq((Time.now.to_i + (throttle_config[:period] - 20)).to_s)

          Timecop.return
        end
      end

      context 'when the limit has been reached' do
        subject do
          get endpoint, headers: { 'Authorization' => "Bearer #{token}" }
          response
        end

        before do
          get endpoint, headers: { 'Authorization' => "Bearer #{token}" }
          get endpoint, headers: { 'Authorization' => "Bearer #{token}" }
        end

        it { expect(subject.status).to eq(429) }

        it 'has rate limit headers defined' do
          rate_limit_subkeys.each do |subkey|
            expect(subject.headers).to have_key("RateLimit-#{subkey}")
          end
        end

        it 'has a RateLimit-Remaining equals to 0' do
          expect(subject.headers['RateLimit-Remaining']).to eq('0')
        end
      end
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
