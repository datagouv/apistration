RSpec.describe 'Token and recipient resolution consistency across layers', api: :entreprise do
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  let(:url) do
    extract_without_context_url_for(
      controller: 'api_entreprise/v3_and_more/opqibi/certifications_ingenierie',
      api_version: 3,
      action: 'show',
      siren: '123456789',
      only_path: true
    )
  end
  let(:outside_ip) { '8.8.8.8' }
  let(:first_error_code) { response.parsed_body['errors'].first['code'] }

  def body_env(body)
    { 'rack.input' => StringIO.new(body), 'CONTENT_LENGTH' => body.bytesize.to_s }
  end

  describe 'an undecodable Authorization header next to a valid token query param' do
    let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234', scopes: Scope.all) }
    let(:token_record) do
      Token.create!(
        iat: 1.day.ago.to_i,
        exp: 1.year.from_now.to_i,
        authorization_request_model_id: authorization_request.id
      )
    end
    let(:jwt) { TokenFactory.new(Scope.all).valid(uid: token_record.id) }

    def make_request
      get url,
        params: { token: jwt, context: 'test', object: 'test', recipient: '13002526500013' },
        headers: { 'Authorization' => 'Bearer not-a-jwt' },
        env: { 'REMOTE_ADDR' => outside_ip }
    end

    context 'when the authorization request restricts IPs' do
      before do
        AuthorizationRequestSecuritySettings.create!(authorization_request:, allowed_ips: ['192.168.1.0/24'])
      end

      it 'enforces the IP allowlist' do
        make_request

        expect(response).to have_http_status(:forbidden)
        expect(first_error_code).to eq(ForbiddenIpError.new('entreprise').code)
      end
    end

    context 'when the token is blacklisted' do
      before { token_record.update!(blacklisted_at: 1.day.ago) }

      it 'rejects the revoked token' do
        make_request

        expect(response).to have_http_status(:unauthorized)
        expect(first_error_code).to eq(BlacklistedTokenError.new('entreprise').code)
      end
    end
  end

  describe 'a token sent in a JSON body' do
    let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234', scopes: Scope.all) }
    let(:token_record) do
      Token.create!(
        iat: 1.day.ago.to_i,
        exp: 1.year.from_now.to_i,
        authorization_request_model_id: authorization_request.id
      )
    end
    let(:jwt) { TokenFactory.new(Scope.all).valid(uid: token_record.id) }

    before do
      AuthorizationRequestSecuritySettings.create!(authorization_request:, allowed_ips: ['192.168.1.0/24'])
    end

    def introspect_from(remote_ip)
      get '/v3/token/introspect',
        headers: { 'CONTENT_TYPE' => 'application/json' },
        env: body_env({ token: jwt }.to_json).merge('REMOTE_ADDR' => remote_ip)
    end

    it 'enforces the IP allowlist of its authorization request' do
      introspect_from(outside_ip)

      expect(response).to have_http_status(:forbidden)
      expect(first_error_code).to eq(ForbiddenIpError.new('entreprise').code)
    end

    it 'authenticates the request from an allowed IP' do
      introspect_from('192.168.1.50')

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'an MCP call carrying its token in the JSON body' do
    it 'authenticates the request' do
      post '/mcp',
        params: { method: 'notifications/initialized', token: TokenFactory.new([]).valid(mcp: true) }.to_json,
        headers: { 'CONTENT_TYPE' => 'application/json' }

      expect(response).to have_http_status(:accepted)
    end
  end

  describe 'a FranceConnect access token next to an API key', api: :particulier do
    let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234', scopes: Scope.all) }
    let(:token_record) do
      Token.create!(
        iat: 1.day.ago.to_i,
        exp: 1.year.from_now.to_i,
        authorization_request_model_id: authorization_request.id
      )
    end
    let(:jwt) { TokenFactory.new(Scope.all).valid(uid: token_record.id) }

    before do
      mock_valid_france_connect_checktoken
      AuthorizationRequestSecuritySettings.create!(authorization_request:, allowed_ips: ['192.168.1.0/24'])
    end

    it 'enforces the IP allowlist of the API key' do
      get '/api/v2/composition-familiale-v2',
        headers: { 'Authorization' => 'Bearer opaque-france-connect-token', 'X-Api-Key' => jwt },
        env: { 'REMOTE_ADDR' => outside_ip }

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'a whitelisted token in query param next to an editor token in X-Api-Key' do
    let(:editor) { Editor.create!(name: 'Test Editor') }
    let(:recipient_siret) { '13002526500013' }
    let(:authorization_request) { AuthorizationRequest.create!(siret: recipient_siret, scopes: Scope.all) }
    let(:editor_token_record) { EditorToken.create!(editor:, iat: 1.day.ago.to_i, exp: 1.year.from_now.to_i) }
    let(:editor_jwt) { TokenFactory.new([]).editor_valid(uid: editor_token_record.id) }
    let(:whitelisted_jwt) { Rails.configuration.jwt_whitelist.first }

    before do
      EditorDelegation.create!(editor:, authorization_request:)
      AuthorizationRequestSecuritySettings.create!(authorization_request:, allowed_ips: ['192.168.1.0/24'])
    end

    it 'does not safelist the request on a token other than the authenticated one' do
      get url,
        params: { token: whitelisted_jwt, recipient: recipient_siret, context: 'test', object: 'test' },
        headers: { 'Authorization' => 'Basic whatever', 'X-Api-Key' => editor_jwt },
        env: { 'REMOTE_ADDR' => outside_ip }

      expect(response).to have_http_status(:forbidden)
      expect(first_error_code).to eq(ForbiddenIpError.new('entreprise').code)
    end
  end

  describe 'an editor recipient differing between query string and body' do
    let(:editor) { Editor.create!(name: 'Test Editor') }
    let(:delegated_siret) { '13002526500013' }
    let(:other_siret) { '41816609600069' }
    let(:authorization_request) { AuthorizationRequest.create!(siret: delegated_siret, scopes: Scope.all) }
    let(:editor_token_record) { EditorToken.create!(editor:, iat: 1.day.ago.to_i, exp: 1.year.from_now.to_i) }
    let(:editor_jwt) { TokenFactory.new([]).editor_valid(uid: editor_token_record.id) }

    before { EditorDelegation.create!(editor:, authorization_request:) }

    def get_with(query_recipient:, body_recipient:)
      get "#{url}?#{{ recipient: query_recipient, context: 'test', object: 'test' }.to_query}",
        headers: { 'Authorization' => "Bearer #{editor_jwt}", 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' },
        env: body_env("recipient=#{body_recipient}")
    end

    it 'refuses the request instead of acting for the query string recipient' do
      get_with(query_recipient: other_siret, body_recipient: delegated_siret)

      expect(response).to have_http_status(:forbidden)
      expect(first_error_code).to eq(DelegationSiretMismatchError.new.code)
    end

    it 'accepts the request when both recipients are the delegated one' do
      get_with(query_recipient: delegated_siret, body_recipient: delegated_siret)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('"code":"00301"')
    end
  end

  describe 'an editor recipient differing between query string and body on API Particulier V2', api: :particulier do
    let(:editor) { Editor.create!(name: 'Test Editor') }
    let(:delegated_siret) { '13002526500013' }
    let(:other_siret) { '41816609600069' }
    let(:authorization_request) { AuthorizationRequest.create!(siret: delegated_siret, scopes: Scope.all) }
    let(:editor_token_record) { EditorToken.create!(editor:, iat: 1.day.ago.to_i, exp: 1.year.from_now.to_i) }
    let(:editor_jwt) { TokenFactory.new([]).editor_valid(uid: editor_token_record.id) }

    before { EditorDelegation.create!(editor:, authorization_request:) }

    it 'does not authorize the request under the body recipient delegation' do
      get "/api/v2/composition-familiale-v2?#{{ recipient: other_siret }.to_query}",
        headers: { 'X-Api-Key' => editor_jwt, 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' },
        env: body_env("recipient=#{delegated_siret}")

      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body['reason']).to eq(InsufficientPrivilegesError.new('api_particulier').detail)
    end
  end
end
