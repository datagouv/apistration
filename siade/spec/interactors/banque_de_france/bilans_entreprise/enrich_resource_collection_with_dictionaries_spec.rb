require 'rails_helper'

RSpec.describe BanqueDeFrance::BilansEntreprise::EnrichResourceCollectionWithDictionaries, type: :interactor do
  subject(:call) { described_class.call(bundled_data:, dictionaries:) }

  let(:bundled_data) { BanqueDeFrance::BilansEntreprise::BuildResourceCollectionWithoutDictionaries.call(response:).bundled_data }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { build_banque_de_france_response(json_body) }
  let(:json_body) do
    open_payload_file('banque_de_france/bilans_entreprise_valid_data.json').read
  end

  let(:dictionaries) do
    VCR.use_cassette('dgfip/dictionaries/2020_and_2021', decode_compressed_response: true) do
      BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote.call(bundled_data:).dictionaries
    end
  end

  describe 'happy path' do
    it { is_expected.to be_success }
  end
end
