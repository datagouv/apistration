RSpec.describe DGFIP::Dictionaries, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      year: 2019
    }
  end

  describe 'happy path', vcr: { cassette_name: 'dgfip/dictionaries/2019', decode_compressed_response: true } do
    let(:dictionnaire_raw) { open_payload_file('dgfip/dictionary.json').read }
    let(:dictionnaire) { JSON.parse(dictionnaire_raw)['dictionnaire'] }

    let(:redis_key) { 'dgfip:dictionnaires:2019' }

    let(:expires_in) { 6.months.from_now.to_i }

    it { is_expected.to be_a_success }

    it 'bundles a dictionnaire' do
      expect(subject.bundled_data.data.dictionnaire).to eq(dictionnaire)
    end
  end
end
