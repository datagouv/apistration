require 'rails_helper'

RSpec.describe Datagouv::SyncFiche do
  subject(:sync) { described_class.new(endpoint, client:).call }

  let(:client) { instance_double(DatagouvAPIClient) }

  context 'when sync_with_datagouv is false' do
    let(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements') }

    it 'does not call the client' do
      expect(client).not_to receive(:find_dataservice)
      expect(client).not_to receive(:create_dataservice)
      expect(client).not_to receive(:update_dataservice)
      expect(client).not_to receive(:delete_dataservice)

      sync
    end

    it 'returns a skipped result' do
      expect(sync.status).to eq(:skipped)
    end
  end

  context 'when the endpoint is deprecated and has a datagouv_uid' do
    let(:endpoint) { APIEntreprise::Endpoint.find('commission_europeenne/numero_tva') }

    before { allow(client).to receive(:delete_dataservice) }

    it 'deletes the dataservice' do
      sync

      expect(client).to have_received(:delete_dataservice).with('672cf6b61092eab5f92dfaac')
    end

    it 'returns a deleted result with no datagouv_uid' do
      expect(sync).to have_attributes(status: :deleted, datagouv_uid: nil)
    end

    context 'when the dataservice was already deleted' do
      before { allow(client).to receive(:delete_dataservice).and_raise(Faraday::ResourceNotFound) }

      it 'still returns a deleted result' do
        expect(sync.status).to eq(:deleted)
      end
    end
  end

  context 'when the endpoint is deprecated and never had a datagouv_uid' do
    let(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements_v3') }

    it 'does not call the client at all' do
      expect(client).not_to receive(:delete_dataservice)

      sync
    end

    it 'returns a skipped_deprecated result' do
      expect(sync.status).to eq(:skipped_deprecated)
    end
  end

  context 'when the endpoint has no datagouv_uid and is not deprecated' do
    let(:endpoint) { APIEntreprise::Endpoint.find('dgfip/numero_tva') }

    before { allow(client).to receive(:create_dataservice).and_return({ 'id' => 'brand-new-id' }) }

    it 'creates a dataservice with the organization set' do
      sync

      expect(client).to have_received(:create_dataservice) do |payload|
        expect(payload[:organization]).to eq('57fe2a35c751df21e179df72')
        expect(payload[:title]).to be_present
      end
    end

    it 'returns a created result with the new id' do
      expect(sync).to have_attributes(status: :created, datagouv_uid: 'brand-new-id')
    end
  end

  context 'when the endpoint has a datagouv_uid and the remote payload differs' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    before do
      allow(client).to receive(:find_dataservice).with('672cf6a701d8db401e4864be').and_return({ 'access_type' => 'open' })
      allow(client).to receive(:update_dataservice)
    end

    it 'updates the dataservice' do
      sync

      expect(client).to have_received(:update_dataservice).with('672cf6a701d8db401e4864be', hash_including(access_type: 'restricted'))
    end

    it 'returns an updated result' do
      expect(sync).to have_attributes(status: :updated, datagouv_uid: '672cf6a701d8db401e4864be')
    end
  end

  context 'when the endpoint has a datagouv_uid and the remote payload already matches' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }
    let(:matching_payload) { Datagouv::FichePayloadBuilder.new(endpoint).payload.transform_keys(&:to_s) }

    before do
      allow(client).to receive(:find_dataservice).with('672cf6a701d8db401e4864be').and_return(matching_payload)
      allow(client).to receive(:update_dataservice)
    end

    it 'does not call update_dataservice' do
      sync

      expect(client).not_to have_received(:update_dataservice)
    end

    it 'returns an unchanged result' do
      expect(sync.status).to eq(:unchanged)
    end
  end

  context 'when fetching the known datagouv_uid 404s' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    before do
      allow(client).to receive(:find_dataservice).and_raise(Faraday::ResourceNotFound)
      allow(client).to receive(:create_dataservice).and_return({ 'id' => 'healed-id' })
    end

    it 'self-heals by creating a new dataservice' do
      sync

      expect(client).to have_received(:create_dataservice)
    end

    it 'returns a created result with the new id' do
      expect(sync).to have_attributes(status: :created, datagouv_uid: 'healed-id')
    end
  end

  context 'when the client raises an unexpected error' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    before { allow(client).to receive(:find_dataservice).and_raise(Faraday::ServerError.new('boom')) }

    it 'returns a failed result' do
      expect(sync.status).to eq(:failed)
    end
  end
end
