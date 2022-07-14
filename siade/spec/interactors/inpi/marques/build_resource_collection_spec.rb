RSpec.describe INPI::Marques::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'inpi/marques/with_valid_siren' } do
    subject(:call) { described_class.call(response:, params:) }

    let(:valid_collection_sample) do
      [
        {
          numero_application: '4746787',
          nom: 'H',
          status: 'Marque enregistrée',
          depositaire: 'PSA AUTOMOBILES SA',
          clef: 'FMARK|4746787',
          notice_url: 'https://opendata-pi.inpi.fr/inpi/marques/notice/FR4746787'
        },
        {
          numero_application: '4553017',
          nom: 'PSA GROUPE',
          status: 'Marque enregistrée',
          depositaire: 'PSA AUTOMOBILES SA',
          clef: 'FMARK|4553017',
          notice_url: 'https://opendata-pi.inpi.fr/inpi/marques/notice/FR4553017'
        }
      ]
    end

    let(:valid_meta) do
      {
        count: 20
      }
    end

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      INPI::Marques::MakeRequest.call(params:).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:inpi),
        limit: 2
      }
    end

    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'Has limit amount of resources' do
      expect(resource_collection.count).to eq(2)
    end

    it 'has meta' do
      meta = call.bundled_data.context

      expect(meta).to eq(valid_meta)
    end

    it 'has valid resource_collection' do
      expect(resource_collection.map(&:to_h)).to eq(valid_collection_sample)
    end
  end
end
