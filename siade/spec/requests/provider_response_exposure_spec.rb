require 'rails_helper'

RSpec.describe 'Provider response exposure', api: :entreprise do
  subject(:payload) do
    get "/v3/insee/sirene/unites_legales/#{siren}",
      params: { context: 'Admin', recipient: '13002526500013', object: 'Debug requête' },
      headers: request_headers

    response_json
  end

  after { Rack::Attack.reset! }

  let(:siren) { sirens_insee_v3[:active_GE] }
  let(:jwt) { back_office_jwt }
  let(:debug_header) { { ProviderResponseDebuggingService::HEADER_NAME => 'true' } }
  let(:request_headers) { { 'Authorization' => "Bearer #{jwt}", 'Cache-Control' => 'no-cache' }.merge(debug_header) }

  def provider_response
    payload.dig(:meta, :provider_response)
  end

  describe 'the IP-restricted back-office token asking with the header', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
    it 'receives the raw provider response next to the serialized payload' do
      expect(payload.dig(:data, :siren)).to eq(siren)
      expect(response).to have_http_status(:ok)
      expect(provider_response[:status]).to eq(200)
      expect(JSON.parse(provider_response[:body]).dig('uniteLegale', 'siren')).to eq(siren)
    end

    it 'receives the provider data our serialization leaves out' do
      raw_unite_legale = JSON.parse(provider_response[:body])['uniteLegale']

      expect(raw_unite_legale).to have_key('periodesUniteLegale')
      expect(payload[:data].to_json).not_to include('periodesUniteLegale')
    end
  end

  describe 'the back-office token without IP restriction', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
    let(:jwt) { back_office_jwt(allowed_ips: []) }

    it 'never receives the raw provider response' do
      expect(payload[:data]).to be_present
      expect(provider_response).to be_nil
    end
  end

  describe 'any other token, whatever its scopes and headers', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
    context 'with an IP-restricted token of another authorization request holding every scope' do
      let(:jwt) { authorization_request_jwt(external_id: '4242', allowed_ips: ['127.0.0.1']) }

      it 'never receives the raw provider response' do
        expect(payload[:data]).to be_present
        expect(provider_response).to be_nil
      end
    end

    context 'with an IP-restricted editor token delegated on the back-office authorization request' do
      let(:jwt) do
        authorization_request = AuthorizationRequest.create!(siret: '13002526500013', scopes: Scope.all, external_id: BackOfficeAuthorizationRequests.datapass_ids.first)
        AuthorizationRequestSecuritySettings.create!(authorization_request:, allowed_ips: ['127.0.0.1'])
        editor = Editor.create!(name: 'Editeur', allowed_ips: ['127.0.0.1'])
        EditorDelegation.create!(editor:, authorization_request:)
        editor_token = EditorToken.create!(editor:, iat: 1.day.ago.to_i, exp: 1.year.from_now.to_i, allowed_ips: ['127.0.0.1'])

        TokenFactory.new([]).editor_valid(uid: editor_token.id)
      end

      it 'never receives the raw provider response' do
        expect(payload[:data]).to be_present
        expect(provider_response).to be_nil
      end
    end

    context 'with the internal debugger token' do
      let(:jwt) { yes_jwt }

      it 'never receives the raw provider response' do
        expect(payload[:data]).to be_present
        expect(provider_response).to be_nil
      end
    end
  end

  describe 'the back-office token without the header', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
    let(:debug_header) { {} }

    it 'keeps the payload untouched' do
      expect(payload[:data]).to be_present
      expect(payload[:meta]).not_to have_key(:provider_response)
    end
  end
end
