RSpec.describe 'Editor delegation', api: :entreprise do
  after { Rack::Attack.reset! }

  def extract_without_context_url_for(options)
    url_for(options.merge(_recall: {}))
  end

  let(:editor) { Editor.create!(name: 'Test Editor') }
  let(:recipient_siret) { '13002526500013' }
  let(:authorization_request) { AuthorizationRequest.create!(siret: recipient_siret, scopes: Scope.all) }
  let(:editor_token_record) do
    EditorToken.create!(
      editor:,
      iat: 1.day.ago.to_i,
      exp: 1.year.from_now.to_i
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

    it 'allows the request' do
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

    it 'returns 403' do
      get url, params:, headers: headers_params

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'with revoked delegation' do
    before do
      EditorDelegation.create!(editor:, authorization_request:, revoked_at: 1.day.ago)
    end

    it 'returns 403' do
      get url, params:, headers: headers_params

      expect(response).to have_http_status(:forbidden)
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
