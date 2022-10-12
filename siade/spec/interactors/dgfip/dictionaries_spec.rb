RSpec.describe DGFIP::Dictionaries, type: :interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren: valid_siren(:liasse_fiscale),
        user_id: valid_dgfip_user_id,
        year: 2019
      }
    end

    let(:key) { 'dgfip:dictionnaires:2019' }

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
      let(:data) { JSON.parse(open_payload_file('dgfip/dictionary.json').read)['dictionnaire'] }

      before do
        RedisService.instance.set(nil, key)
      end

      its(:dictionary) { is_expected.to eq(data) }
    end
  end
end
