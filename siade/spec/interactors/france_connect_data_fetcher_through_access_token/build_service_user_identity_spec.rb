RSpec.describe FranceConnectDataFetcherThroughAccessToken::BuildServiceUserIdentity, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:payload) { france_connect_checktoken_payload }
    let(:body) { payload.to_json }

    its(:service_user_identity) { is_expected.to be_a(Resource) }

    it 'associates identite attributes to resource' do
      expect(call.service_user_identity.to_h).to eq(payload[:identity])
    end
  end
end
