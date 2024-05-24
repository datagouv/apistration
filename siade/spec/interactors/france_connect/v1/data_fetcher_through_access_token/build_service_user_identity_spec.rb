RSpec.describe FranceConnect::V1::DataFetcherThroughAccessToken::BuildServiceUserIdentity, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:payload) { france_connect_checktoken_payload }
    let(:body) { payload.to_json }

    its(:service_user_identity) { is_expected.to be_a(Resource) }

    context 'when france connect returns a preferred username' do
      it 'associates identite attributes to resource' do
        expect(call.service_user_identity.to_h).to eq(payload[:identity])
      end
    end

    context 'when france connect does not return a preferred username' do
      let(:payload) do
        {
          scope: nil,
          identity: default_france_connect_v1_identity_attributes.except(:preferred_username),
          client: france_connect_v1_client_attributes
        }
      end

      it 'sets preferred_username to nil' do
        expect(call.service_user_identity.preferred_username).to be_nil
      end
    end
  end
end
