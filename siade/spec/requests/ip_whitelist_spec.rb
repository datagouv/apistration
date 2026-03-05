RSpec.describe 'IP Whitelist', api: :entreprise do
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234', scopes: Scope.all) }
  let(:token_record) do
    Token.create!(
      iat: 1.day.ago.to_i,
      exp: 1.year.from_now.to_i,
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

  context 'without IP whitelist configured' do
    it 'allows request from any IP' do
      get url, headers: headers_params

      expect(response).not_to have_http_status(:forbidden)
    end
  end

  context 'with IP whitelist configured' do
    before do
      AuthorizationRequestSecuritySettings.create!(
        authorization_request:,
        allowed_ips: ['192.168.1.0/24']
      )
    end

    context 'when request comes from whitelisted IP' do
      it 'allows the request' do
        get url, headers: headers_params, env: { 'REMOTE_ADDR' => '192.168.1.50' }

        expect(response).not_to have_http_status(:forbidden)
      end
    end

    context 'when request comes from non-whitelisted IP' do
      let(:non_whitelisted_ip) { '8.8.8.8' }

      it 'returns 403' do
        get url, headers: headers_params, env: { 'REMOTE_ADDR' => non_whitelisted_ip }

        expect(response).to have_http_status(:forbidden)
      end

      it 'returns error code 00107' do
        get url, headers: headers_params, env: { 'REMOTE_ADDR' => non_whitelisted_ip }

        expect(response_json.dig(:errors, 0, :code)).to eq('00107')
      end

      it 'returns error message about IP not allowed' do
        get url, headers: headers_params, env: { 'REMOTE_ADDR' => non_whitelisted_ip }

        expect(response_json).to have_json_error(
          detail: "Votre adresse IP n'est pas autorisée à utiliser ce jeton."
        )
      end
    end
  end
end
