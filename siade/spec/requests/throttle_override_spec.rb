RSpec.describe 'Throttle override', api: :entreprise do
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

  # json_resources_entreprise is limited to 2 requests per period in the test env
  context 'without override' do
    it 'gets throttled at the default group limit' do
      3.times { get url, headers: headers_params }

      expect(response).to have_http_status(:too_many_requests)
    end
  end

  context 'with an override raising the group limit' do
    before do
      AuthorizationRequestSecuritySettings.create!(
        authorization_request:,
        throttle_overrides: { 'json_resources_entreprise' => 5 }
      )
    end

    it 'allows requests up to the overridden limit' do
      5.times do
        get url, headers: headers_params
        expect(response).not_to have_http_status(:too_many_requests)
      end
    end

    it 'still throttles beyond the overridden limit' do
      6.times { get url, headers: headers_params }

      expect(response).to have_http_status(:too_many_requests)
    end
  end
end
