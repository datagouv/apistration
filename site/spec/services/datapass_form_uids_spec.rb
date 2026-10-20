RSpec.describe DatapassFormUids do
  describe '.all' do
    subject(:all) { described_class.all }

    let(:client) { instance_double(DatapassAPIClient) }

    before do
      allow(DatapassAPIClient).to receive(:new).and_return(client)
      allow(client).to receive(:list_formulaires).with('api_entreprise').and_return([{ 'uid' => 'api-entreprise' }, { 'uid' => 'shared' }])
      allow(client).to receive(:list_formulaires).with('api_particulier').and_return([{ 'uid' => 'api-particulier' }, { 'uid' => 'shared' }])
    end

    it 'returns the unique formulaire uids of both definitions' do
      expect(all).to contain_exactly('api-entreprise', 'api-particulier', 'shared')
    end
  end
end
