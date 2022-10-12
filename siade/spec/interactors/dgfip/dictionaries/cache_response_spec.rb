RSpec.describe DGFIP::Dictionaries::CacheResponse do
  subject { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, code: '200', body: dictionnaire_raw_data) }
  let(:dictionnaire_raw_data) { open_payload_file('dgfip/dictionary.json').read }
  let(:params) do
    {
      year: 2018
    }
  end

  describe 'happy path' do
    let(:dictionnaire) { JSON.parse(dictionnaire_raw_data)['dictionnaire'].to_json }

    let(:redis_key) { 'dgfip:dictionnaires:2018' }

    let(:expires_in) { 6.months.from_now.to_i }

    it { is_expected.to be_a_success }

    it 'caches all results in redis' do
      expect(RedisService.instance).to receive(:set).with(redis_key, dictionnaire, { ex: expires_in })

      subject
    end
  end
end
