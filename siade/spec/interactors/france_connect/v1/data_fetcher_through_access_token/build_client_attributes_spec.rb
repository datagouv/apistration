RSpec.describe FranceConnect::V1::DataFetcherThroughAccessToken::BuildClientAttributes, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:payload) { france_connect_v1_checktoken_payload }
    let(:body) { payload.to_json }

    its(:client_attributes) { is_expected.to be_a(Resource) }

    it 'associates client attributes to resource' do
      expect(call.client_attributes.to_h[:client_id]).to eq('france_connect_client_id')
      expect(call.client_attributes.to_h[:client_name]).to eq('france_connect_client_name')
      expect(call.client_attributes.to_h[:sub]).to be_nil
    end
  end
end
