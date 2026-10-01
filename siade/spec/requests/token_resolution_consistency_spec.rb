RSpec.describe 'Token resolution consistency across layers', api: :entreprise do
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
end
