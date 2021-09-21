RSpec.describe Rack::Attack, type: :request do
  after { described_class.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  RSpec.shared_examples 'returns a 401 error' do
    let(:random_endpoint) do
      {
        controller: 'api/v2/certificats_opqibi',
        action: 'show',
        siren: 123
      }
    end
    let(:url) { extract_without_context_url_for(**random_endpoint, only_path: true) }

    it 'returns 401' do
      get url, params: headers_params

      expect(response.status).to eq(401)
    end

    it 'returns an error message' do
      get url, params: headers_params

      expect(response_json).to have_json_error(detail: 'Votre token n\'est pas valide ou n\'est pas renseigné')
    end
  end

  RSpec.shared_examples 'throttling group of endpoints' do
    let(:token_sample_1) { yes_jwt }
    let(:token_sample_2) { uptime_jwt }

    def call!(token)
      random_endpoint = endpoints.sample
      url = extract_without_context_url_for(**random_endpoint, only_path: true)

      get(url, headers: { 'Authorization' => "Bearer #{token}" })
    end

    it 'accepts incoming requests up to the limit' do
      limit.times do
        call!(token_sample_1)

        expect(response.status).not_to eq(429)
      end
    end

    context 'after the limit has been reached' do
      before { limit.times { call!(token_sample_1) } }

      it 'rejects incoming requests after the limit' do
        call!(token_sample_1)

        expect(response.status).to eq(429)
      end

      it 'resets the counter after 60 seconds' do
        Timecop.freeze(60.seconds.from_now) do
          call!(token_sample_1)

          expect(response.status).not_to eq(429)
        end
      end

      it 'limits requests on a per token basis' do
        call!(token_sample_2)

        expect(response.status).not_to eq(429)
      end

      it 'responds with the Retry-After header when off limit' do
        call!(token_sample_1)

        expect(response.headers).to include('Retry-After')
      end
    end

    context 'with a whitelisted token' do
      let(:token) { Rails.configuration.jwt_whitelist.sample }

      it 'has no limit' do
        limit.times { call!(token) }
        call!(token)

        expect(response.status).not_to eq(429)
      end
    end

    context 'with a blacklisted token' do
      let(:token) { Rails.configuration.jwt_blacklist.sample }

      it_behaves_like 'returns a 401 error' do
        let(:headers_params) { { headers: { 'Authorization' => "Bearer #{token}" } } }
        let(:random_endpoint) { endpoints.sample }
      end
    end
  end

  context 'when the Authorization header format (Bearer) is not respected' do
    it_behaves_like 'returns a 401 error' do
      let(:headers_params) { { headers: { 'Authorization' => 'Beer hour' } } }
    end
  end

  context 'when the Authorization header is absent' do
    it_behaves_like 'returns a 401 error' do
      let(:headers_params) { { headers: { 'Umad' => 'Beer hour' } } }
    end
  end

  context 'when Authorization header format (Bearer) is valid' do
    context 'when the provided token is not a valid JWT' do
      it_behaves_like 'returns a 401 error' do
        let(:headers_params) { { headers: { 'Umad' => 'Bearer hour' } } }
      end
    end

    context 'when the token is absent' do
      it_behaves_like 'returns a 401 error' do
        let(:headers_params) { { headers: { 'Umad' => 'Bearer ' } } }
      end
    end

    context 'when the token is a valid JWT' do
      def limit_value_for_production(endpoints_list)
        config = YAML.safe_load(File.open("#{Rails.root}/config/throttle.yml"))
        config.dig('production', endpoints_list, 'limit')
      end

      let(:throttle_config) { Rails.configuration.throttle }

      describe 'low latency document resources throttling' do
        it_behaves_like 'throttling group of endpoints' do
          let(:limit) { throttle_config.dig(:low_latency_documents, :limit) }
          let(:endpoints) { throttle_config.dig(:low_latency_documents, :endpoints) }
        end
      end

      describe 'JSON resources throttling' do
        it_behaves_like 'throttling group of endpoints' do
          let(:limit) { throttle_config.dig(:json_resources, :limit) }
          let(:endpoints) { throttle_config.dig(:json_resources, :endpoints) }
        end
      end

      describe 'endpoints exceptions' do
        describe 'very high latency endpoints' do
          let(:limit) { throttle_config.dig(:high_latency_documents, :limit) }

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoints) do
              [{
                controller: 'api/v2/attestations_fiscales_dgfip',
                action: 'show',
                siren: 123
              }]
            end
          end

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoints) do
              [{
                controller: 'api/v2/documents_inpi',
                action: 'actes',
                siren: 123
              }]
            end
          end

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoints) do
              [{
                controller: 'api/v2/documents_inpi',
                action: 'bilans',
                siren: 123
              }]
            end
          end
        end

        describe 'self hosted endpoints' do
          let(:limit) { throttle_config.dig(:very_low_latency_json_resources, :limit) }

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoints) do
              [{
                controller: 'api/v2/effectifs_annuels_entreprise_acoss_covid',
                action: 'show',
                siren: 123
              }]
            end
          end

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoints) do
              [{
                controller: 'api/v2/effectifs_mensuels_etablissement_acoss_covid',
                action: 'show',
                siret: 123,
                annee: 2020,
                mois: 0o1
              }]
            end
          end

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoints) do
              [{
                controller: 'api/v2/effectifs_mensuels_entreprise_acoss_covid',
                action: 'show',
                siren: 123,
                annee: 2020,
                mois: 0o1
              }]
            end
          end

          it_behaves_like 'throttling group of endpoints' do
            let(:endpoints) do
              [{
                controller: 'api/v2/attestations_agefiph',
                action: 'show',
                siret: 123
              }]
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

    context 'with and endpoint which has no throttle config' do
      let(:endpoint) { '/v2/uptime' }

      it 'has no rate limit headers defined' do
        rate_limit_subkeys.each do |subkey|
          expect(headers).not_to have_key("RateLimit-#{subkey}")
        end
      end
    end

    context 'with and endpoint which has a throttle config' do
      let(:endpoint) { '/v2/certificats_opqibi/siren' }
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

          Timecop.travel(Time.zone.now + 20.seconds)
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

        its(:status) { is_expected.to eq(429) }

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
          controller: 'api/v2/uptime',
          action: 'show'
        },
        {
          controller: 'api/v2/privileges',
          action: 'show'
        }
      ]
    end

    let(:throttle_config) { Rails.configuration.throttle }

    let(:throttled_endpoints) do
      config = throttle_config.dig(:low_latency_documents, :endpoints)
        .concat(throttle_config.dig(:json_resources, :endpoints))
        .concat(throttle_config.dig(:high_latency_documents, :endpoints))
        .concat(throttle_config.dig(:very_low_latency_json_resources, :endpoints))
      config.map { |conf| conf.slice(:controller, :action) }
    end

    it 'throttles the resources' do
      expect(all_routes).to contain_exactly(*throttled_endpoints)
    end
  end
end
