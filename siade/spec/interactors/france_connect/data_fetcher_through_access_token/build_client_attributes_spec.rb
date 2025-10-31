RSpec.describe FranceConnect::DataFetcherThroughAccessToken::BuildClientAttributes, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(json_body:) }

    let(:json_body) { france_connect_decrypted_payload.deep_stringify_keys }

    its(:client_attributes) { is_expected.to be_a(Resource) }

    it 'associates client attributes to resource' do
      expect(call.client_attributes.to_h[:client_id]).to eq('6925fb8143c76eded44d32b40c0cb1006065f7f003de52712b78985704f39950')
      expect(call.client_attributes.to_h[:sub]).to eq('2fa48e3542c8645567f983efc96305808ae7d3f0d9cc4016ef40c3cde44844cfv1')
      expect(call.client_attributes.to_h[:client_name]).to eq('no_data_from_fc_v2')
    end
  end
end
