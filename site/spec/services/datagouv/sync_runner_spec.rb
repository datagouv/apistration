require 'rails_helper'

RSpec.describe Datagouv::SyncRunner do
  subject(:run) { described_class.new(endpoints).call }

  let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }
  let(:endpoints) { [endpoint] }
  let(:sync_fiche) { instance_double(Datagouv::SyncFiche) }

  before do
    allow(Datagouv::SyncFiche).to receive(:new).with(endpoint).and_return(sync_fiche)
  end

  context 'when the fiche is created' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :created, uid: endpoint.uid, datagouv_uid: 'new-id') }
    let(:writer) { instance_double(Datagouv::YmlUidWriter, write: true) }

    before do
      allow(sync_fiche).to receive(:call).and_return(result)
      allow(Datagouv::YmlUidWriter).to receive(:new).with(api: endpoint.api, uid: endpoint.uid).and_return(writer)
    end

    it 'writes the new datagouv_uid back to the yml' do
      run

      expect(writer).to have_received(:write).with('new-id')
    end

    it 'returns true' do
      expect(run).to be true
    end
  end

  context 'when the fiche is deleted' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :deleted, uid: endpoint.uid, datagouv_uid: nil) }
    let(:writer) { instance_double(Datagouv::YmlUidWriter, remove: true) }

    before do
      allow(sync_fiche).to receive(:call).and_return(result)
      allow(Datagouv::YmlUidWriter).to receive(:new).with(api: endpoint.api, uid: endpoint.uid).and_return(writer)
    end

    it 'removes the datagouv_uid from the yml' do
      run

      expect(writer).to have_received(:remove)
    end
  end

  context 'when the fiche sync fails' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :failed, uid: endpoint.uid, datagouv_uid: endpoint.datagouv_uid) }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'returns false' do
      expect(run).to be false
    end
  end

  context 'when the fiche is unchanged' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :unchanged, uid: endpoint.uid, datagouv_uid: endpoint.datagouv_uid) }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'does not touch the yml and returns true' do
      expect(Datagouv::YmlUidWriter).not_to receive(:new)

      expect(run).to be true
    end
  end

  context 'when the fiche is skipped as deprecated' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :skipped_deprecated, uid: endpoint.uid, datagouv_uid: nil) }

    before { allow(sync_fiche).to receive(:call).and_return(result) }

    it 'does not touch the yml and returns true' do
      expect(Datagouv::YmlUidWriter).not_to receive(:new)

      expect(run).to be true
    end
  end

  context 'when the yml write-back raises for a created fiche' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :created, uid: endpoint.uid, datagouv_uid: 'new-id') }
    let(:writer) { instance_double(Datagouv::YmlUidWriter) }

    before do
      allow(sync_fiche).to receive(:call).and_return(result)
      allow(Datagouv::YmlUidWriter).to receive(:new).with(api: endpoint.api, uid: endpoint.uid).and_return(writer)
      allow(writer).to receive(:write).and_raise(Datagouv::YmlUidWriter::UidNotFoundError.new('boom'))
    end

    it 'does not raise and treats the endpoint as failed' do
      expect { run }.not_to raise_error
      expect(run).to be false
    end

    it 'logs the orphaned datagouv_uid so it can be manually reconciled' do
      expect(Rails.logger).to receive(:error).with(a_string_including('new-id'))

      run
    end
  end

  context 'when the yml write-back raises for a deleted fiche' do
    let(:result) { Datagouv::SyncFiche::Result.new(status: :deleted, uid: endpoint.uid, datagouv_uid: nil) }
    let(:writer) { instance_double(Datagouv::YmlUidWriter) }

    before do
      allow(sync_fiche).to receive(:call).and_return(result)
      allow(Datagouv::YmlUidWriter).to receive(:new).with(api: endpoint.api, uid: endpoint.uid).and_return(writer)
      allow(writer).to receive(:remove).and_raise(Datagouv::YmlUidWriter::UidNotFoundError.new('boom'))
    end

    it 'does not raise and treats the endpoint as failed' do
      expect { run }.not_to raise_error
      expect(run).to be false
    end
  end
end
