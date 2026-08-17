require 'rails_helper'

RSpec.describe Datagouv::SyncFichesRemoteService do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    let(:runner) { instance_double(Datagouv::SyncRunner, call: true) }

    before { allow(Datagouv::SyncRunner).to receive(:new).and_return(runner) }

    it 'builds SyncRunner with every endpoint from both catalogs' do
      perform

      expect(Datagouv::SyncRunner).to have_received(:new) do |endpoints|
        expect(endpoints.size).to eq(APIEntreprise::Endpoint.all.size + APIParticulier::Endpoint.all.size)
      end
    end

    it 'releases the lock after the sync completes' do
      perform

      expect(Rails.cache.exist?('datagouv_sync_in_progress')).to be false
    end

    context 'when the lock is already held' do
      before { Rails.cache.write('datagouv_sync_in_progress', true) }

      it 'does not run the sync' do
        perform

        expect(Datagouv::SyncRunner).not_to have_received(:new)
      end
    end

    context 'when the sync runs' do
      before { FileUtils.touch(Rails.root.join('log/datagouv.log').to_s) }

      it 'logs the start and end of the sync to a dedicated file' do
        expect {
          perform
        }.to(change { File.read(Rails.root.join('log/datagouv.log').to_s) })
      end
    end
  end
end
