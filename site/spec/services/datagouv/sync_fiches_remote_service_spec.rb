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

    it 'locks under a namespace that does not depend on the cache store default' do
      allow(Rails.cache).to receive(:write).and_call_original

      perform

      expect(Rails.cache).to have_received(:write).with(
        'datagouv_sync_in_progress', true, hash_including(namespace: described_class::LOCK_NAMESPACE)
      )
    end

    it 'releases the lock after the sync completes' do
      perform

      expect(Rails.cache.exist?('datagouv_sync_in_progress', namespace: described_class::LOCK_NAMESPACE)).to be false
    end

    context 'when the lock is already held' do
      before { Rails.cache.write('datagouv_sync_in_progress', true, namespace: described_class::LOCK_NAMESPACE) }

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

    context 'when the sync raises an unexpected error' do
      before { allow(Datagouv::SyncRunner).to receive(:new).and_raise(KeyError, 'key not found: :datagouv_host') }

      it 'reports the error to Sentry instead of raising' do
        expect(Sentry).to receive(:capture_exception).with(instance_of(KeyError))

        expect { perform }.not_to raise_error
      end

      it 'still releases the lock' do
        allow(Sentry).to receive(:capture_exception)

        perform

        expect(Rails.cache.exist?('datagouv_sync_in_progress', namespace: described_class::LOCK_NAMESPACE)).to be false
      end
    end
  end
end
