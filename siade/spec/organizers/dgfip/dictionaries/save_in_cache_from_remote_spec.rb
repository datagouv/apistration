RSpec.describe DGFIP::Dictionaries::SaveInCacheFromRemote, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      year: 2019
    }
  end

  describe 'happy path', vcr: { cassette_name: 'dgfip/dictionaries/2019', decode_compressed_response: true } do
    let(:dictionnaire) do
      JSON.parse(open_payload_file('dgfip/dictionary.json').read)['dictionnaire'].to_json
    end

    let(:redis_key) { 'dgfip:dictionnaires:2019' }

    let(:expires_in) { 6.months.from_now.to_i }

    it { is_expected.to be_a_success }

    it 'caches all results in redis' do
      expect(RedisService.instance).to receive(:set).with(redis_key, dictionnaire, { ex: expires_in })

      subject
    end
  end
end
