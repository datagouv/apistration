require 'rails_helper'

RSpec.describe Datagouv::SyncRunner do
  subject(:run) { described_class.new(endpoints).call }

  let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }
  let(:endpoints) { [endpoint] }
  let(:index) { instance_double(Datagouv::DataserviceIndex, size: 1) }
  let(:sync_fiche) { instance_double(Datagouv::SyncFiche) }

  before do
    allow(Datagouv::DataserviceIndex).to receive(:new).and_return(index)
    allow(Datagouv::SyncFiche).to receive(:new).with(endpoint, index: index, logger: Rails.logger).and_return(sync_fiche)
  end

  context 'when the fiche is created' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :created, uid: endpoint.uid, remote_id: 'new-id') }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'returns true' do
      expect(run).to be true
    end

    it 'logs the outcome including the remote_id' do
      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).with("SyncRunner: #{endpoint.uid} -> created (new-id)")

      run
    end

    it 'logs how many existing remote dataservices the index matched against' do
      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).with('SyncRunner: matched against 1 existing remote dataservices')

      run
    end

    it 'logs a summary of results by status' do
      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).with('SyncRunner: 1 endpoints processed - created: 1')

      run
    end
  end

  context 'when the fiche is deleted' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :deleted, uid: endpoint.uid, remote_id: nil) }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'returns true' do
      expect(run).to be true
    end

    it 'logs the outcome without a remote_id suffix' do
      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).with("SyncRunner: #{endpoint.uid} -> deleted")

      run
    end
  end

  context 'when the fiche sync fails' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :failed, uid: endpoint.uid, remote_id: nil) }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'returns false' do
      expect(run).to be false
    end
  end

  context 'when the fiche is unchanged' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :unchanged, uid: endpoint.uid, remote_id: 'existing-id') }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'returns true' do
      expect(run).to be true
    end
  end

  context 'when the fiche is skipped as deprecated' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :skipped_deprecated, uid: endpoint.uid, remote_id: nil) }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'returns true' do
      expect(run).to be true
    end
  end

  context 'with multiple endpoints, one failing' do
    let(:other_endpoint) { APIEntreprise::Endpoint.find('dgfip/numero_tva') }
    let(:endpoints) { [endpoint, other_endpoint] }
    let(:other_sync_fiche) { instance_double(Datagouv::SyncFiche) }
    let(:result) { Datagouv::SyncFiche::Result.new(status: :created, uid: endpoint.uid, remote_id: 'new-id') }
    let(:other_result) { Datagouv::SyncFiche::Result.new(status: :failed, uid: other_endpoint.uid, remote_id: nil) }

    before do
      allow(Datagouv::SyncFiche).to receive(:new).with(other_endpoint, index: index, logger: Rails.logger).and_return(other_sync_fiche)
      allow(sync_fiche).to receive(:call).and_return(result)
      allow(other_sync_fiche).to receive(:call).and_return(other_result)
    end

    it 'builds the index only once and shares it across endpoints' do
      run

      expect(Datagouv::DataserviceIndex).to have_received(:new).once
    end

    it 'returns false because one endpoint failed' do
      expect(run).to be false
    end
  end

  context 'when listing dataservices fails' do
    before { allow(Datagouv::DataserviceIndex).to receive(:new).and_raise(Faraday::ServerError.new('boom')) }

    it 'does not raise and returns false' do
      expect { run }.not_to raise_error
      expect(run).to be false
    end

    it 'does not attempt to sync any endpoint' do
      expect(Datagouv::SyncFiche).not_to receive(:new)

      run
    end

    it 'logs the failure' do
      expect(Rails.logger).to receive(:error).with(a_string_including('boom'))

      run
    end
  end
end
