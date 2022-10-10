RSpec.describe DGFIP::Dictionaries::SaveInCacheFromRemote, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      year: 2019
    }
  end

  describe 'happy path', vcr: { cassette_name: 'dgfip/dictionaries/2019', decode_compressed_response: true } do
    let(:declarations_1) do
      [
        {
          'code_absolu' => '1234567',
          'code_EDI' => 'XX:X123:4567:0:XXX',
          'code' => 'XX',
          'intitule' => 'Intitulé 1',
          'code_type_donnee' => 'XXX',
          'code_nref' => '123456'
        },
        {
          'code_absolu' => '1234568',
          'code_EDI' => 'XX:X123:4568:2',
          'code' => 'YY',
          'intitule' => 'Intitulé 2',
          'code_type_donnee' => 'YYY',
          'code_nref' => '123457'
        }
      ]
    end

    let(:declarations_2) do
      [
        {
          'code_absolu' => '2345678',
          'code_EDI' => 'XX:X123:2222:2:XXX',
          'code' => 'ZZ',
          'intitule' => 'Déposé néant',
          'code_type_donnee' => 'XXY',
          'code_nref' => '123458'
        }
      ]
    end

    let(:redis_key_1) { 'dgfip:dictionnaires:year_2019:imprime_2050' }
    let(:redis_key_2) { 'dgfip:dictionnaires:year_2019:imprime_2051' }

    let(:expires_in) { 6.months.from_now.to_i }

    it { is_expected.to be_a_success }

    it 'caches all results in redis' do
      expect(RedisService.instance).to receive(:set).with(redis_key_1, declarations_1.to_json, { ex: expires_in })
      expect(RedisService.instance).to receive(:set).with(redis_key_2, declarations_2.to_json, { ex: expires_in })

      subject
    end
  end
end
