RSpec.describe DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote, type: :interactor do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren: valid_siren(:liasse_fiscale),
      user_id: valid_dgfip_user_id,
      year: 2019
    }
  end

  let(:key) { 'dgfip:dictionnaires:2019' }

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

    context 'when data is not available in cache', vcr: { cassette_name: 'dgfip/dictionaries/2019', decode_compressed_response: true } do
      let(:data) { JSON.parse(open_payload_file('dgfip/dictionary.json').read)['dictionnaire'] }

      before do
        EncryptedCache.write(key, nil)
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
