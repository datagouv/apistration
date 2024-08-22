RSpec.describe FranceConnect::V2::DataFetcherThroughAccessToken::BuildUser, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(json_body:) }

    let(:json_body) { france_connect_v2_decrypted_payload(scopes:).deep_stringify_keys }
    let(:scopes) { 'mesri_identifiant openid identite_pivot' }

    its(:user) { is_expected.to be_a(JwtUser) }

    it 'gets scopes from access token payload' do
      expect(call.user.scopes).to eq(scopes.split)
    end
  end
end
