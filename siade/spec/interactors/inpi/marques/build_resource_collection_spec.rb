RSpec.describe INPI::Marques::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'inpi/marques/with_valid_siren' } do
    subject(:call) { described_class.call(response: response, params: params) }

    let(:valid_collection_sample) do
      [
        {
          id: '4746787',
          marque: 'H',
          marque_status: 'Marque enregistrée',
          depositaire: 'PSA AUTOMOBILES SA',
          clef: 'FMARK|4746787'
        },
        {
          id: '4553017',
          marque: 'PSA GROUPE',
          marque_status: 'Marque enregistrée',
          depositaire: 'PSA AUTOMOBILES SA',
          clef: 'FMARK|4553017'
        }
      ]
    end

    let(:valid_meta) do
      {
        count: 20
      }
    end

    let(:response) do
      instance_double('Net::HTTPOK', body: body)
    end

    let(:body) do
      INPI::Marques::MakeRequest.call(params: params).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:inpi),
        limit: 2
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(call.resource_collection).to all be_a(Resource)
    end

    it 'Have limit amount of resources' do
      expect(call.resource_collection.count).to eq(2)
    end

    it 'has meta' do
      expect(call.meta).to eq(valid_meta)
    end

    it 'has valid resource_collection' do
      expect(call.resource_collection.map(&:to_h)).to eq(valid_collection_sample)
    end
  end
end
