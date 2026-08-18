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
end
