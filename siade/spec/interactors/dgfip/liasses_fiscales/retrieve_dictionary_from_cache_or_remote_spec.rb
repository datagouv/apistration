RSpec.describe DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote, type: :interactor do
  subject { described_class.call(params:) }

  let(:params) do
    {
      year:,
      user_id:,
      request_id:
    }
  end

  let(:year) { 2019 }
  let(:key) { 'dgfip:dictionnaires:2019' }
  let(:user_id) { SecureRandom.uuid }
  let(:request_id) { SecureRandom.uuid }

  before do
    mock_valid_dgfip_dictionnaire(2019)
    described_class.instance_variable_set(:@features_config, nil)
  end

  after do
    described_class.instance_variable_set(:@features_config, nil)
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

    it { is_expected.to be_a_success }

    context 'when year exists in local' do
      let(:year) { 2019 }

      it 'renders valid dictionary' do
        expect(subject.dictionary).to be_an(Array)
        expect(subject.dictionary.first).to have_key('numero_imprime')
      end

      it 'tracks the fetch from local data' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'info',
          'Fail to fetch DGFIP dictionnary',
          {
            year: 2019
          }
        )

        subject
      end
    end

    context 'when year does not exist in local' do
      let(:year) { 1990 }

      it { is_expected.to be_a_failure }
      its(:dictionary) { is_expected.to be_nil }
    end
  end

  describe 'when load_local_dgfip_dictionnaries feature flag is enabled' do
    before do
      allow(Rails.application).to receive(:config_for).and_call_original
      allow(Rails.application).to receive(:config_for).with(:features).and_return(load_local_dgfip_dictionnaries: true)
    end

    it { is_expected.to be_a_success }

    it 'does not call DGFIP remote' do
      expect(CacheResourceRetriever).not_to receive(:call)

      subject
    end

    it 'loads dictionary from local file' do
      expect(subject.dictionary).to be_an(Array)
      expect(subject.dictionary.first).to have_key('numero_imprime')
    end

    context 'when local file does not exist' do
      let(:year) { 1990 }

      it { is_expected.to be_a_failure }
    end
  end
end
