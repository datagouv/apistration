RSpec.describe FranceConnect::V2::DataFetcherThroughAccessToken::BuildClientAttributes, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:payload) { france_connect_v2_checktoken_payload }
    let(:body) { payload.to_json }

    its(:client_attributes) { is_expected.to be_a(Resource) }

    it 'associates client attributes to resource' do
      expect(call.client_attributes.to_h[:client_id]).to eq('6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950')
      expect(call.client_attributes.to_h[:client_name]).to eq('no_data_from_fc_v2')
    end
  end
end
