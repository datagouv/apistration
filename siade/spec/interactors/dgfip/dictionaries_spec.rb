RSpec.describe DGFIP::Dictionaries, type: :interactor do
  describe '.call' do
    subject { described_class.call(key:) }

    let(:key) { 'dgfip:dictionnaires:year_2019:imprime_2051:millesime_201501' }

    context 'when data is available in Redis' do
      let(:data) do
        {
          'local data' => 'anything'
        }
      end

      before do
        RedisService.instance.set(key, data.to_json)
      end

      its(:dictionary) { is_expected.to eq(data) }
    end

    context 'when data is not available in Redis', vcr: { cassette_name: 'dgfip/dictionaries/2019', decode_compressed_response: true } do
      let(:data) do
        [
          {
            'code' => 'ZZ',
            'code_EDI' => 'XX:X123:2222:2:XXX',
            'code_absolu' => '2345678',
            'code_nref' => '123458',
            'code_type_donnee' => 'XXY',
            'intitule' => 'Déposé néant'
          }
        ]
      end

      before do
        RedisService.instance.set(nil, key)
      end

      its(:dictionary) { is_expected.to eq(data) }
    end
  end
end
