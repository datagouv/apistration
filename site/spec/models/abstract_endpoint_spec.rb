require 'rails_helper'

RSpec.describe AbstractEndpoint do
  describe '#sync_with_datagouv?' do
    context 'when sync_with_datagouv is not set in the yml' do
      subject(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

      it 'defaults to true' do
        expect(endpoint.sync_with_datagouv?).to be true
      end
    end

    context 'when sync_with_datagouv is explicitly false' do
      subject(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements') }

      it 'is false' do
        expect(endpoint.sync_with_datagouv?).to be false
      end
    end
  end

  describe '#description_plain_text' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    it 'strips HTML tags while keeping their text content' do
      allow(endpoint).to receive(:description).and_return('Une <b>description</b> avec des <a href="url">liens</a>.')

      expect(endpoint.description_plain_text).to eq('Une description avec des liens.')
    end

    it 'returns an empty string when description is nil' do
      allow(endpoint).to receive(:description).and_return(nil)

      expect(endpoint.description_plain_text).to eq('')
    end
  end
end
