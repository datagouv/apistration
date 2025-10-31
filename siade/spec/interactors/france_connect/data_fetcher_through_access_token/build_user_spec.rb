RSpec.describe FranceConnect::DataFetcherThroughAccessToken::BuildUser, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(json_body:, params: { api_version: }) }

    let(:json_body) { france_connect_decrypted_payload(scopes:).deep_stringify_keys }
    let(:scopes) { 'mesri_identifiant openid identite_pivot api_name_identite' }
    let(:api_version) { '2' }

    its(:user) { is_expected.to be_a(JwtUser) }

    context 'when API version is 3 or more' do
      let(:api_version) { '42' }

      it 'gets scopes from access token payload without api_name_identite' do
        expect(call.user.scopes).to eq(%w[mesri_identifiant openid identite_pivot])
      end
    end

    context 'when API version is 2' do
      it 'gets scopes from access token payload' do
        expect(call.user.scopes).to eq(scopes.split)
      end
    end
  end
end
