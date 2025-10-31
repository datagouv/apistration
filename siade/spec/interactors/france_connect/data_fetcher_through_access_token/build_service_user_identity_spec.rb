RSpec.describe FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(json_body:) }

    let(:json_body) { france_connect_decrypted_payload.deep_stringify_keys }

    its(:service_user_identity) { is_expected.to be_a(Resource) }

    it 'associates identite attributes to resource' do
      expect(call.service_user_identity.gender).to eq(json_body['token_introspection']['gender'])
      expect(call.service_user_identity.given_name).to eq(json_body['token_introspection']['given_name'])
      expect(call.service_user_identity.family_name).to eq(json_body['token_introspection']['family_name'])
      expect(call.service_user_identity.given_name_array).to eq(json_body['token_introspection']['given_name_array'])
      expect(call.service_user_identity.birthdate).to eq(json_body['token_introspection']['birthdate'])
      expect(call.service_user_identity.birthplace).to eq(json_body['token_introspection']['birthplace'])
      expect(call.service_user_identity.birthcountry).to eq(json_body['token_introspection']['birthcountry'])
      expect(call.service_user_identity.preferred_username).to be_nil
    end
  end
end
