RSpec.describe INPI::Brevets::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'inpi/brevets/with_valid_siren' } do
    subject(:call) { described_class.call(response: response, params: params) }

    let(:valid_collection_sample) do
      {
        id: 'FR3110115A1',
        titre: 'RENFORT LATÉRAL DE PLANCHER DE VÉHICULE AUTOMOBILE ÉQUIPÉ DE BATTERIES DE TRACTION',
        date_publication: '20211119',
        date_depot: '20200512',
        code_zone: 'FR',
        numero_brevet: '3110115',
        categorie_publication: 'A1'
      }
    end

    let(:valid_meta) do
      {
        count: 17_859
      }
    end

    let(:response) do
      instance_double('Net::HTTPOK', body: body)
    end

    let(:body) do
      INPI::Brevets::MakeRequest.call(params: params).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:inpi),
        limit: 3
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(call.resource_collection).to all be_a(Resource)
    end

    it 'Have limit amount of resources' do
      expect(call.resource_collection.count).to eq(3)
    end

    it 'has meta' do
      expect(call.meta).to eq(valid_meta)
    end

    it 'has valid resource_collection' do
      expect(call.resource_collection.first.to_h).to eq(valid_collection_sample)
    end
  end
end
