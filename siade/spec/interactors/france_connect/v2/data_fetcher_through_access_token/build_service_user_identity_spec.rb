RSpec.describe FranceConnect::V2::DataFetcherThroughAccessToken::BuildServiceUserIdentity, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:payload) { france_connect_v2_checktoken_payload }
    let(:body) { payload.to_json }

    its(:service_user_identity) { is_expected.to be_a(Resource) }

    it 'associates identite attributes to resource' do
      expect(call.service_user_identity.gender).to eq(payload[:token_introspection][:gender])
      expect(call.service_user_identity.given_name).to eq(payload[:token_introspection][:given_name])
      expect(call.service_user_identity.family_name).to eq(payload[:token_introspection][:family_name])
      expect(call.service_user_identity.given_name_array).to eq(payload[:token_introspection][:given_name_array])
      expect(call.service_user_identity.birthdate).to eq(payload[:token_introspection][:birthdate])
      expect(call.service_user_identity.birthplace).to eq(payload[:token_introspection][:birthplace])
      expect(call.service_user_identity.birthcountry).to eq(payload[:token_introspection][:birthcountry])
      expect(call.service_user_identity.preferred_username).to be_nil
    end
  end
end
