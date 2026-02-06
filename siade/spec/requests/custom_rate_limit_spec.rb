RSpec.describe 'Custom Rate Limit', api: :entreprise do
  before { Rack::Attack.reset! }
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234') }
  let(:token_record) do
    Token.create!(
      iat: 1.day.ago.to_i,
      exp: 1.year.from_now.to_i,
      scopes: Scope.all,
      authorization_request_model_id: authorization_request.id
    )
  end
  let(:jwt) { TokenFactory.new(Scope.all).valid(uid: token_record.id) }
  let(:headers_params) { { 'Authorization' => "Bearer #{jwt}" } }

  let(:endpoint) do
    {
      controller: 'api_entreprise/v3_and_more/opqibi/certifications_ingenierie',
      api_version: 3,
      action: 'show',
      siren: '123456789'
    }
  end
  let(:url) { extract_without_context_url_for(**endpoint, only_path: true) }

  context 'with custom rate limit configured' do
    before do
      AuthorizationRequestSecuritySettings.create!(
        authorization_request:,
        rate_limit_per_minute: 2
      )
    end

    it 'allows requests within rate limit' do
      2.times do
        get url, headers: headers_params
        expect(response).not_to have_http_status(:too_many_requests)
      end
    end

    it 'blocks requests exceeding rate limit with 429' do
      3.times { get url, headers: headers_params }

      expect(response).to have_http_status(:too_many_requests)
    end

    it 'resets rate limit after period' do
      2.times { get url, headers: headers_params }

      Timecop.travel(61.seconds.from_now) do
        get url, headers: headers_params
        expect(response).not_to have_http_status(:too_many_requests)
      end
    end
  end

  context 'without custom rate limit configured' do
    let(:other_authorization_request) { AuthorizationRequest.create!(siret: '98765432109876') }
    let(:other_token_record) do
      Token.create!(
        iat: 1.day.ago.to_i,
        exp: 1.year.from_now.to_i,
        scopes: Scope.all,
        authorization_request_model_id: other_authorization_request.id
      )
    end
    let(:other_jwt) { TokenFactory.new(Scope.all).valid(uid: other_token_record.id) }
    let(:other_headers) { { 'Authorization' => "Bearer #{other_jwt}" } }

    it 'does not get throttled by custom rate limit' do
      3.times { get url, headers: other_headers }

      expect(response.headers['X-RateLimit-Name']).not_to eq('custom_rate_limit')
    end
  end
end
