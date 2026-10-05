# frozen_string_literal: true

RSpec.describe BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote, type: :interactor do
  subject(:call) { described_class.call(bundled_data:, params:) }

  let(:bundled_data) { BanqueDeFrance::BilansEntreprise::BuildResourceCollectionWithoutDictionaries.call(response:).bundled_data }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { build_banque_de_france_response(json_body) }
  let(:json_body) do
    open_payload_file('banque_de_france/bilans_entreprise_valid_data.json').read
  end

  let(:params) do
    {
      user_id:,
      request_id:
    }
  end
  let(:user_id) { SecureRandom.uuid }
  let(:request_id) { SecureRandom.uuid }

  describe 'happy path' do
    before do
      allow(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call).and_call_original

      mock_valid_dgfip_dictionnaire(2021)
      mock_valid_dgfip_dictionnaire(2022)
    end

    it { is_expected.to be_success }

    it 'indexes dictionaries by bilan closing date' do
      expect(call.dictionaries.keys).to match_array(%w[2020-12 2021-12])
    end

    it 'calls DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote for each millesime year' do
      expect(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call).with(params: { year: '2021', user_id:, request_id: })
      expect(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call).with(params: { year: '2022', user_id:, request_id: })

      call
    end
  end

  describe 'when the dictionary of a millesime is not available' do
    let(:dictionary_2021) { ['dictionary 2021'] }

    before do
      allow(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call) do |params:|
        retrieved_dictionary(params[:year] == '2021' ? dictionary_2021 : nil)
      end
    end

    def retrieved_dictionary(dictionary)
      Interactor::Context.build(dictionary:, errors: [ProviderUnavailable.new('DGFIP - Adélie')]).tap do |context|
        context.fail! if dictionary.nil?
      rescue Interactor::Failure
        context
      end
    end

    it { is_expected.to be_success }

    it 'falls back on the dictionary of the closing year' do
      expect(call.dictionaries['2021-12']).to eq(dictionary_2021)
    end
  end

  describe 'millesime of a bilan' do
    let(:bundled_data) { BundledData.new(data: bilans, context: {}) }
    let(:bilans) { [Resource.new(annee: '2025', date_arrete_exercice:)] }

    before do
      allow(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call) do |params:|
        Interactor::Context.build(dictionary: ["dictionary #{params[:year]}"])
      end
    end

    context 'when the bilan is closed in december' do
      let(:date_arrete_exercice) { '2025-12' }

      it 'uses the dictionary of the following year' do
        expect(call.dictionaries).to eq('2025-12' => ['dictionary 2026'])
      end
    end

    context 'when the bilan is closed before december' do
      let(:date_arrete_exercice) { '2025-06' }

      it 'uses the dictionary of the closing year' do
        expect(call.dictionaries).to eq('2025-06' => ['dictionary 2025'])
      end
    end

    context 'when two bilans are closed the same year' do
      let(:bilans) do
        [
          Resource.new(annee: '2025', date_arrete_exercice: '2025-06'),
          Resource.new(annee: '2025', date_arrete_exercice: '2025-12')
        ]
      end

      it 'selects a dictionary for each of them' do
        expect(call.dictionaries).to eq('2025-06' => ['dictionary 2025'], '2025-12' => ['dictionary 2026'])
      end
    end
  end
end
