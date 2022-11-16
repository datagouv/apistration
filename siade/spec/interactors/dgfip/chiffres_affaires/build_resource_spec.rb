RSpec.describe DGFIP::ChiffresAffaires::BuildResource, type: :build_resource do
  subject(:call) { described_class.call(params: { siret: }, response:) }

  let(:siret) { valid_siret }
  let(:response) { instance_double(Net::HTTPOK, body:) }

  describe 'when liste_ca is an array' do
    let(:body) do
      {
        'liste_ca' => [
          {
            'ca' => '9001',
            'dateFinExercice' => '2016-12-31T00:00:00+01:00'
          },
          {
            'ca' => '425169',
            'dateFinExercice' => '2015-12-31T00:00:00+01:00'
          }
        ]
      }.to_json
    end

    let(:valid_collection) do
      [
        {
          date_fin_exercice: '2016-12-31',
          chiffre_affaires: 9001
        },
        {
          date_fin_exercice: '2015-12-31',
          chiffre_affaires: 425_169
        }
      ]
    end

    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'has valid number of items' do
      expect(resource_collection.count).to eq(2)
    end

    it 'has meta with count' do
      meta = call.bundled_data.context

      expect(meta).to eq({ count: 2 })
    end

    it 'has valid resource_collection' do
      expect(resource_collection.map(&:to_h)).to eq(valid_collection)
    end
  end

  context 'when liste_ca is a single element' do
    let(:body) do
      {
        'liste_ca' => {
          'ca' => '9001',
          'dateFinExercice' => '2016-12-31T00:00:00+01:00'
        }
      }.to_json
    end

    let(:valid_collection) do
      [
        {
          date_fin_exercice: '2016-12-31',
          chiffre_affaires: 9001
        }
      ]
    end

    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'has valid number of items' do
      expect(resource_collection.count).to eq(1)
    end

    it 'has meta with count' do
      meta = call.bundled_data.context

      expect(meta).to eq({ count: 1 })
    end

    it 'has valid resource_collection' do
      expect(resource_collection.map(&:to_h)).to eq(valid_collection)
    end
  end
end
