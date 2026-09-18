RSpec.describe 'Introspection v3' do
  after { Rack::Attack.reset! }

  let(:path) { '/v3/token/introspect' }
  let(:recipient_siret) { '13002526500013' }
  let(:scopes) { %w[attestations_fiscales] }
  let(:datapass_id) { '12345' }
  let(:authorization_request) { AuthorizationRequest.create!(siret: recipient_siret, scopes:, external_id: datapass_id) }
  let(:token_record) do
    Token.create!(
      authorization_request:,
      iat: 1.day.ago.to_i,
      exp: 1.year.from_now.to_i,
      version: '1.0',
      extra_info: {}
    )
  end
  let(:jwt) { TokenFactory.new(scopes).valid(uid: token_record.id) }
  let(:headers) { { 'Authorization' => "Bearer #{jwt}" } }
  let(:body) { response.parsed_body }
  let(:data) { body.fetch('data') }

  shared_examples 'an introspection endpoint' do
    it 'describes the token bound to the request' do
      get(path, headers:)

      expect(response).to have_http_status(:ok)
      expect(data['id']).to eq(token_record.id)
      expect(data['type']).to eq('standard')
      expect(data['scopes']).to eq(scopes)
      expect(data['demande_acces_id']).to eq(datapass_id)
      expect(data['siret_souscripteur']).to eq(recipient_siret)
      expect(data['date_expiration']).to eq(Time.zone.at(token_record.exp).iso8601)
      expect(data['duree_validite_restante_en_secondes']).to be_within(60).of(token_record.exp - Time.zone.now.to_i)
      expect(data['rate_limit_par_minute']).to be_nil
      expect(data['delegation']).to be_nil
      expect(body).to include('links' => {}, 'meta' => {})
    end

    it 'does not leak the security settings of the authorization request' do
      AuthorizationRequestSecuritySettings.create!(
        authorization_request:,
        rate_limit_per_minute: 200,
        allowed_ips: ['127.0.0.1'],
        throttle_overrides: { 'insee' => 10 }
      )

      get(path, headers:)

      expect(data['rate_limit_par_minute']).to eq(200)
      expect(data.keys).not_to include('allowed_ips', 'throttle_overrides', 'mcp', 'blacklisted')
    end

    it 'answers with a json_api error when the token is missing' do
      get path

      expect(response).to have_http_status(:unauthorized)
      expect(body.fetch('errors').first).to include('code', 'title', 'detail')
    end

    it 'answers with a json_api error when the token is expired' do
      token_record.update!(exp: 1.day.ago.to_i)

      get(path, headers:)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'refuses an unsupported version' do
      get(path.sub('/v3/', '/v42/'), headers:)

      expect(response).to have_http_status(:not_found)
    end

    it 'does not require any scope' do
      authorization_request.update!(scopes: [])

      get(path, headers:)

      expect(response).to have_http_status(:ok)
      expect(data['scopes']).to eq([])
    end

    context 'with an editor token' do
      let(:editor) { Editor.create!(name: 'Test Editor') }
      let(:editor_token_record) do
        EditorToken.create!(editor:, iat: 1.day.ago.to_i, exp: 1.year.from_now.to_i)
      end
      let(:jwt) { TokenFactory.new([]).editor_valid(uid: editor_token_record.id) }
      let!(:delegation) { EditorDelegation.create!(editor:, authorization_request:) }

      it 'describes the raw editor token when no recipient is given' do
        get(path, headers:)

        expect(response).to have_http_status(:ok)
        expect(data['type']).to eq('editeur')
        expect(data['scopes']).to eq([])
        expect(data['demande_acces_id']).to be_nil
        expect(data['siret_souscripteur']).to be_nil
        expect(data['delegation']).to be_nil
      end

      it 'describes the resolved delegation when a recipient is given' do
        get(path, params: { recipient: recipient_siret }, headers:)

        expect(response).to have_http_status(:ok)
        expect(data['type']).to eq('editeur')
        expect(data['scopes']).to eq(scopes)
        expect(data['demande_acces_id']).to eq(datapass_id)
        expect(data['siret_souscripteur']).to eq(recipient_siret)
        expect(data['delegation']).to eq(
          'id' => delegation.id,
          'siret_delegant' => recipient_siret
        )
      end

      it 'refuses a recipient which has not delegated to the editor' do
        get(path, params: { recipient: '21920023500014' }, headers:)

        expect(response).to have_http_status(:forbidden)
        expect(body.fetch('errors').first).to include('code' => '00213')
      end

      context 'when the recipient has delegated several authorization requests' do
        let(:other_authorization_request) do
          AuthorizationRequest.create!(siret: recipient_siret, scopes: %w[attestations_sociales], external_id: '67890')
        end
        let!(:other_delegation) { EditorDelegation.create!(editor:, authorization_request: other_authorization_request) }

        it 'asks for a delegation_id' do
          get(path, params: { recipient: recipient_siret }, headers:)

          expect(response).to have_http_status(:unprocessable_content)
          expect(body.fetch('errors').first).to include('code' => '00212')
        end

        it 'describes the delegation selected by delegation_id' do
          get(path, params: { recipient: recipient_siret, delegation_id: other_delegation.id }, headers:)

          expect(response).to have_http_status(:ok)
          expect(data['demande_acces_id']).to eq('67890')
          expect(data['delegation']).to include('id' => other_delegation.id)
        end
      end
    end
  end

  describe 'API Entreprise', api: :entreprise do
    it_behaves_like 'an introspection endpoint'
  end

  describe 'API Particulier', api: :particulier do
    it_behaves_like 'an introspection endpoint'
  end
end
