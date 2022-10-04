RSpec.describe DGFIP::Dictionaries::CacheResponse do
  subject { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
  let(:body) { Rails.root.join('spec/fixtures/payloads/dgfip/dictionary.json').read }
  let(:params) do
    {
      year: 2018
    }
  end

  describe 'happy path' do
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
      ].to_json
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
      ].to_json
    end

    let(:redis_key_1) { 'dgfip:dictionnaires:year_2018:imprime_2050' }
    let(:redis_key_2) { 'dgfip:dictionnaires:year_2018:imprime_2051' }

    let(:expires_in) { 6.months.from_now.to_i }

    it { is_expected.to be_a_success }

    it 'caches all results in redis' do
      expect(RedisService.instance).to receive(:set).with(redis_key_1, declarations_1, { ex: expires_in })
      expect(RedisService.instance).to receive(:set).with(redis_key_2, declarations_2, { ex: expires_in })

      subject
    end
  end
end
