require 'rails_helper'

RSpec.describe ScopeCatalog do
  include ActiveSupport::Testing::TimeHelpers

  describe '#lookup' do
    subject(:lookup) { described_class.for('api_entreprise').lookup('unites_legales_etablissements_insee') }

    let(:data_pass_api_client) { instance_double(DataPassAPIClient, definitions: definitions_payload) }
    let(:definitions_payload) do
      {
        'scopes' => [
          {
            'value' => 'unites_legales_etablissements_insee',
            'name' => 'Data',
            'group' => 'Informations générales',
            'provider' => 'INSEE'
          }
        ]
      }
    end

    before do
      allow(DataPassAPIClient).to receive(:new).and_return(data_pass_api_client)
    end

    it 'returns the provider/group/name for a known scope' do
      expect(lookup).to eq(provider: 'INSEE', group: 'Informations générales', name: 'Data')
    end

    it 'returns nil for an unknown scope' do
      expect(described_class.for('api_entreprise').lookup('totally_unknown')).to be_nil
    end

    it 'caches the fetched catalog so a second lookup does not call the client again' do
      described_class.for('api_entreprise').lookup('unites_legales_etablissements_insee')
      described_class.for('api_entreprise').lookup('unites_legales_etablissements_insee')

      expect(data_pass_api_client).to have_received(:definitions).once
    end

    it 'writes the stale cache entry without an expiration so it never expires on its own' do
      allow(Rails.cache).to receive(:write).and_call_original

      lookup

      expect(Rails.cache).to have_received(:write).with(anything, anything, expires_in: nil)
    end

    context 'when DataPass is unreachable and no cache exists yet' do
      before do
        allow(data_pass_api_client).to receive(:definitions).and_raise(Faraday::TimeoutError)
      end

      it 'returns nil instead of raising' do
        expect(lookup).to be_nil
      end
    end

    context 'when DataPass returns an unexpected payload shape and no cache exists yet' do
      it 'returns nil instead of raising when the payload is not a Hash' do
        allow(data_pass_api_client).to receive(:definitions).and_return([])

        expect(lookup).to be_nil
      end

      it 'returns nil instead of raising when definitions returns nil' do
        allow(data_pass_api_client).to receive(:definitions).and_return(nil)

        expect(lookup).to be_nil
      end
    end

    context 'when DataPass is unreachable but a previous successful fetch was cached' do
      before do
        described_class.for('api_entreprise').lookup('unites_legales_etablissements_insee')
        travel(described_class::CACHE_TTL + 1.minute)
        allow(data_pass_api_client).to receive(:definitions).and_raise(Faraday::TimeoutError)
      end

      it 'serves the stale cached value instead of raising' do
        expect(lookup).to eq(provider: 'INSEE', group: 'Informations générales', name: 'Data')
      end
    end
  end
end
