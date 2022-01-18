RSpec.describe INPI::Modeles::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'inpi/modeles/with_valid_siren' } do
    subject(:call) { described_class.call(response: response, params: params) }

    let(:valid_collection_sample) do
      [
        {
          id: 'FR20203928-001',
          numero_depot: '20203928',
          titre: 'FEUX AVANT DIURNE',
          total_representations: 7,
          deposant: 'PSA AUTOMOBILES, SA',
          date_depot: '2020-09-02',
          date_publication: '2020-10-16',
          classe: '2606',
          reference: '001',
          notice_url: 'https://opendata-pi.inpi.fr/inpi/modeles/notice/FR20203928?ref=001'
        },
        {
          id: 'FR20203928-002',
          numero_depot: '20203928',
          titre: 'FEUX AVANT DIURNE',
          total_representations: 7,
          deposant: 'PSA AUTOMOBILES, SA',
          date_depot: '2020-09-02',
          date_publication: '2020-10-16',
          classe: '2606',
          reference: '002',
          notice_url: 'https://opendata-pi.inpi.fr/inpi/modeles/notice/FR20203928?ref=002'
        }
      ]
    end

    let(:valid_meta) do
      {
        count: 403
      }
    end

    let(:response) do
      instance_double('Net::HTTPOK', body: body)
    end

    let(:body) do
      INPI::Modeles::MakeRequest.call(params: params).response.body
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

    it 'has limit amount of resources' do
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
