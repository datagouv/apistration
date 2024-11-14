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

      mock_valid_dgfip_dictionnaire(2020)
      mock_valid_dgfip_dictionnaire(2021)
    end

    it { is_expected.to be_success }

    it 'retrieves all dictionaries for each year' do
      expect(call.dictionaries.keys).to match_array(%w[2020 2021])
    end

    it 'calls DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote for each year' do
      expect(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call).with(params: { year: '2020', user_id:, request_id: })
      expect(DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote).to receive(:call).with(params: { year: '2021', user_id:, request_id: })

      call
    end
  end
end
