RSpec.describe 'Editor delegation', api: :entreprise do
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  def expect_ip_denied
    expect(response).to have_http_status(:forbidden)
    expect(response_json.dig(:errors, 0, :code)).to eq('00107')
  end

  let(:editor_allowed_ips) { [] }
  let(:editor) { Editor.create!(name: 'Test Editor', allowed_ips: editor_allowed_ips) }
  let(:recipient_siret) { '13002526500013' }
  let(:authorization_request) { AuthorizationRequest.create!(siret: recipient_siret, scopes: Scope.all) }
  let(:editor_token_allowed_ips) { [] }
  let(:editor_token_record) do
    EditorToken.create!(
      editor:,
      iat: 1.day.ago.to_i,
      exp: 1.year.from_now.to_i,
      allowed_ips: editor_token_allowed_ips
    )
  end
  let(:jwt) { TokenFactory.new([]).editor_valid(uid: editor_token_record.id) }
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
  let(:params) { { recipient: recipient_siret, context: 'test', object: 'test' } }

  context 'with active delegation' do
    before do
      EditorDelegation.create!(editor:, authorization_request:)
    end

    it 'allows querying a third-party SIREN on behalf of the delegated recipient' do
      get url, params:, headers: headers_params

      expect(response).not_to have_http_status(:forbidden)
      expect(response).not_to have_http_status(:unauthorized)
    end
  end

  context 'when the editor token is broader than the delegated authorization request' do
    let(:authorization_request) { AuthorizationRequest.create!(siret: recipient_siret, scopes: []) }
    let(:editor_token_record) do
      EditorToken.create!(
        editor:,
        iat: 1.day.ago.to_i,
        exp: 1.year.from_now.to_i
      )
    end

    before do
      EditorDelegation.create!(editor:, authorization_request:)
    end

    it 'denies endpoints the delegated authorization request does not grant, even when the editor token is broader' do
      get url, params:, headers: headers_params

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'with active delegation and delegation_id' do
    let!(:delegation) { EditorDelegation.create!(editor:, authorization_request:) }

    it 'allows the request when delegation_id matches' do
      get url, params: params.merge(delegation_id: delegation.id), headers: headers_params

      expect(response).not_to have_http_status(:forbidden)
      expect(response).not_to have_http_status(:unauthorized)
    end
  end

  context 'with multiple active delegations for the same SIRET' do
    let(:authorization_request_2) { AuthorizationRequest.create!(siret: recipient_siret, scopes: Scope.all) }
    let!(:delegation_2) { EditorDelegation.create!(editor:, authorization_request: authorization_request_2) }

    before do
      EditorDelegation.create!(editor:, authorization_request:)
    end

    context 'without delegation_id' do
      it 'returns 422 with ambiguous delegation error' do
        get url, params:, headers: headers_params

        expect(response).to have_http_status(:unprocessable_content)
        body = response.parsed_body
        expect(body['errors'].first['code']).to eq('00212')
      end
    end

    context 'with correct delegation_id' do
      it 'allows the request' do
        get url, params: params.merge(delegation_id: delegation_2.id), headers: headers_params

        expect(response).not_to have_http_status(:forbidden)
        expect(response).not_to have_http_status(:unauthorized)
      end
    end

    context 'with incorrect delegation_id' do
      it 'returns 403' do
        get url, params: params.merge(delegation_id: SecureRandom.uuid), headers: headers_params

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'without delegation for the recipient SIRET' do
    let(:other_ar) { AuthorizationRequest.create!(siret: '99999999999999', scopes: Scope.all) }

    before do
      EditorDelegation.create!(editor:, authorization_request: other_ar)
    end

    it 'returns 403 with the delegation recipient mismatch error' do
      get url, params:, headers: headers_params

      expect(response).to have_http_status(:forbidden)
      expect(response.parsed_body['errors'].first['code']).to eq('00213')
    end
  end

  context 'without a recipient param' do
    before do
      EditorDelegation.create!(editor:, authorization_request:)
    end

    it 'is rejected by the recipient format validation before any delegation logic' do
      get url, params: params.except(:recipient), headers: headers_params

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body['errors'].first['code']).not_to eq('00213')
    end
  end

  context 'with revoked delegation' do
    before do
      EditorDelegation.create!(editor:, authorization_request:, revoked_at: 1.day.ago)
    end

    it 'returns 403 with the delegation recipient mismatch error' do
      get url, params:, headers: headers_params

      expect(response).to have_http_status(:forbidden)
      expect(response.parsed_body['errors'].first['code']).to eq('00213')
    end
  end

  context 'with a revoked authorization request' do
    before do
      EditorDelegation.create!(editor:, authorization_request:)
      authorization_request.update!(status: 'revoked')
    end

    it 'returns 403 with the delegation recipient mismatch error' do
      get url, params:, headers: headers_params

      expect(response).to have_http_status(:forbidden)
      expect(response.parsed_body['errors'].first['code']).to eq('00213')
    end
  end

  context 'with an archived authorization request' do
    let!(:delegation) { EditorDelegation.create!(editor:, authorization_request:) }

    before do
      authorization_request.update!(status: 'archived')
    end

    it 'returns 403 even when the delegation_id is explicitly provided' do
      get url, params: params.merge(delegation_id: delegation.id), headers: headers_params

      expect(response).to have_http_status(:forbidden)
      expect(response.parsed_body['errors'].first['code']).to eq('00213')
    end
  end

  context 'with a missing or malformed recipient' do
    before do
      EditorDelegation.create!(editor:, authorization_request:)
    end

    it 'returns 422 with the recipient validation error rather than 403' do
      get url, params: params.merge(recipient: 'not-a-siret'), headers: headers_params

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body['errors'].first['code']).not_to eq('00212')
    end
  end

  context 'when the editor token has allowed IPs' do
    let(:editor_token_allowed_ips) { ['192.168.1.0/24'] }

    before do
      EditorDelegation.create!(editor:, authorization_request:)
    end

    it 'allows a request coming from an allowed IP' do
      get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '192.168.1.50' }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'denies a request coming from another IP with error 00107' do
      get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '8.8.8.8' }

      expect_ip_denied
    end

    it 'denies a request from another IP even without a recipient to delegate to' do
      get url, params: params.except(:recipient), headers: headers_params, env: { 'REMOTE_ADDR' => '8.8.8.8' }

      expect_ip_denied
    end

    context 'when the delegated authorization request has its own allowed IPs' do
      before do
        AuthorizationRequestSecuritySettings.create!(
          authorization_request:,
          allowed_ips: ['192.168.1.0/25', '10.0.0.0/24']
        )
      end

      it 'allows a request coming from an IP allowed by both lists' do
        get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '192.168.1.50' }

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'denies a request coming from an IP allowed by the authorization request only' do
        get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '10.0.0.5' }

        expect_ip_denied
      end

      it 'denies a request coming from an IP allowed by the editor token only' do
        get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '192.168.1.200' }

        expect_ip_denied
      end
    end
  end

  context 'when the editor has a declared IP range' do
    let(:editor_allowed_ips) { ['192.168.1.0/24'] }

    before do
      EditorDelegation.create!(editor:, authorization_request:)
    end

    it 'allows a request coming from the editor range' do
      get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '192.168.1.50' }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'denies a request from outside the editor range even when the token has no allowed IPs' do
      get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '8.8.8.8' }

      expect_ip_denied
    end

    context 'when the editor token narrows the range' do
      let(:editor_token_allowed_ips) { ['192.168.1.0/25'] }

      it 'denies a request from the editor range but outside the token list' do
        get url, params:, headers: headers_params, env: { 'REMOTE_ADDR' => '192.168.1.200' }

        expect_ip_denied
      end
    end
  end

  context 'with a regular (non-editor) token' do
    let(:regular_ar) { AuthorizationRequest.create!(siret: recipient_siret, scopes: Scope.all) }
    let(:token_record) do
      Token.create!(
        iat: 1.day.ago.to_i,
        exp: 1.year.from_now.to_i,
        authorization_request_model_id: regular_ar.id
      )
    end
    let(:jwt) { TokenFactory.new(Scope.all).valid(uid: token_record.id) }

    it 'works without delegation (no regression)' do
      get url, params:, headers: headers_params

      expect(response).not_to have_http_status(:forbidden)
      expect(response).not_to have_http_status(:unauthorized)
    end
  end
end
