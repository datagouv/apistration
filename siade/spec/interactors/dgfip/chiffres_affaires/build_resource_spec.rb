RSpec.describe DGFIP::ChiffresAffaires::BuildResource, type: :build_resource do
  subject(:call) { described_class.call(params: { siret: }, response:) }

  let(:siret) { valid_siret }
  let(:response) { instance_double(Net::HTTPOK, body:) }
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

  it { is_expected.to be_a_success }

  it 'builds valid resources' do
    expect(call.resource_collection).to all be_a(Resource)
  end

  it 'has valid number of items' do
    expect(call.resource_collection.count).to eq(2)
  end

  it 'has meta with count' do
    expect(call.meta).to eq({ count: 2 })
  end

  it 'has valid resource_collection' do
    expect(call.resource_collection.map(&:to_h)).to eq(valid_collection)
  end
end
