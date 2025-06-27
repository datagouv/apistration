RSpec.describe 'Rack::Attack config', api: :particulier do
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  RSpec.shared_examples 'returns a 401 error' do
    let(:endpoint) do
      {
        controller: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_ine',
        api_version: 3,
        action: 'show',
        ine: '1234567890G'
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
          controller: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_ine',
          api_version: 3,
          action: 'show',
          ine: '1234567890G'
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
      let(:throttle_config) { Rails.configuration.throttle }

      describe 'JSON resources throttling Particulier' do
        it_behaves_like 'throttling group of endpoints' do
          let(:limit) { throttle_config.dig(:json_resources_particulier, :limit) }
          let(:period) { throttle_config.dig(:json_resources_particulier, :period) }
          let(:endpoint) do
            {
              controller: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_ine',
              action: 'show',
              api_version: 3,
              ine: '1234567890G'
            }
          end
        end
      end
    end
  end
end