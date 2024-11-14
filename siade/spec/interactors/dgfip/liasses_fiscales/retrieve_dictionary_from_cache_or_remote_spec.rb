RSpec.describe DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote, type: :interactor do
  subject { described_class.call(params:) }

  let(:params) do
    {
      year: 2019,
      user_id:,
      request_id:
    }
  end

  let(:key) { 'dgfip:dictionnaires:2019' }
  let(:user_id) { SecureRandom.uuid }
  let(:request_id) { SecureRandom.uuid }

  before do
    mock_valid_dgfip_dictionnaire(2019)
  end

  describe 'happy path' do
    context 'when data is available in cache' do
      let(:data) do
        {
          dictionnaire: 'anything'
        }
      end
      let(:cached_data) { BundledData.new(data: Resource.new(data)) }

      before do
        EncryptedCache.write(key, { bundled_data: cached_data })
      end

      it { is_expected.to be_a_success }
      its(:dictionary) { is_expected.to eq(data[:dictionnaire]) }
    end

    context 'when data is not available in cache' do
      let(:data) { JSON.parse(open_payload_file('dgfip/dictionary.json').read)['dictionnaire'] }

      before do
        EncryptedCache.write(key, nil)
      end

      it 'calls retriever with valid data' do
        expect(DGFIP::Dictionaries).to receive(:call).with({
          params:
        }).and_call_original

        subject
      end

      it { is_expected.to be_a_success }
      its(:dictionary) { is_expected.to eq(data) }
    end
  end

  describe 'when there is something wrong with the retriever' do
    before do
      # rubocop:disable RSpec/VerifiedDoubles
      allow(CacheResourceRetriever).to receive(:call).and_return(
        double('retriever', success?: false, errors: [DnsResolutionError.new(provider_name: 'DGFIP - Adélie', message: 'error')])
      )
      # rubocop:enable RSpec/VerifiedDoubles
    end

    it { is_expected.to be_a_failure }
    its(:dictionary) { is_expected.to be_nil }

    its(:errors) { is_expected.to include(instance_of(DnsResolutionError)) }
  end
end
