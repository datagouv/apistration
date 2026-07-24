require 'rails_helper'

RSpec.describe Datagouv::SyncFiche do
  subject(:sync) { described_class.new(endpoint, index: index, client: client).call }

  let(:client) { instance_double(DatagouvAPIClient) }
  let(:index) { instance_double(Datagouv::DataserviceIndex) }

  context 'when sync_with_datagouv is false' do
    let(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements') }

    it 'does not call the index or the client' do
      expect(index).not_to receive(:find)
      expect(index).not_to receive(:marker_match)
      expect(client).not_to receive(:create_dataservice)
      expect(client).not_to receive(:update_dataservice)
      expect(client).not_to receive(:delete_dataservice)

      sync
    end

    it 'returns a skipped result' do
      expect(sync.status).to eq(:skipped)
    end
  end

  context 'when the endpoint is deprecated and the index finds a marker match' do
    let(:endpoint) { APIEntreprise::Endpoint.find('commission_europeenne/numero_tva') }

    before do
      allow(index).to receive(:marker_match).with(endpoint).and_return({ 'id' => 'remote-id' })
      allow(client).to receive(:delete_dataservice)
    end

    it 'deletes the dataservice' do
      sync

      expect(client).to have_received(:delete_dataservice).with('remote-id')
    end

    it 'returns a deleted result with the deleted remote_id' do
      expect(sync).to have_attributes(status: :deleted, remote_id: 'remote-id')
    end

    context 'when the dataservice was already deleted' do
      before { allow(client).to receive(:delete_dataservice).and_raise(Faraday::ResourceNotFound) }

      it 'still returns a deleted result' do
        expect(sync.status).to eq(:deleted)
      end
    end
  end

  context 'when the endpoint is deprecated and the index finds no marker match' do
    let(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements_v3') }

    before { allow(index).to receive(:marker_match).with(endpoint).and_return(nil) }

    it 'does not call the client at all' do
      expect(client).not_to receive(:delete_dataservice)

      sync
    end

    it 'returns a skipped_deprecated result' do
      expect(sync.status).to eq(:skipped_deprecated)
    end
  end

  context 'when the endpoint is deprecated, has no marker match, but would collide by title with a live sibling' do
    let(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements_v3') }

    before do
      allow(index).to receive(:marker_match).with(endpoint).and_return(nil)
      allow(index).to receive(:find).with(endpoint).and_return({ 'id' => 'live-siblings-dataservice' })
    end

    it 'does not delete the live sibling\'s dataservice via a title-fallback match' do
      expect(client).not_to receive(:delete_dataservice)

      sync
    end

    it 'returns a skipped_deprecated result rather than a deleted one' do
      expect(sync.status).to eq(:skipped_deprecated)
    end
  end

  context 'when the index finds no match and the endpoint is not deprecated' do
    let(:endpoint) { APIEntreprise::Endpoint.find('dgfip/numero_tva') }

    before do
      allow(index).to receive(:find).with(endpoint).and_return(nil)
      allow(client).to receive(:create_dataservice).and_return({ 'id' => 'brand-new-id' })
    end

    it 'creates a dataservice with the organization set' do
      sync

      expect(client).to have_received(:create_dataservice) do |payload|
        expect(payload[:organization]).to eq('57fe2a35c751df21e179df72')
        expect(payload[:title]).to be_present
      end
    end

    it 'returns a created result with the new id' do
      expect(sync).to have_attributes(status: :created, remote_id: 'brand-new-id')
    end
  end

  context 'when the index finds a match and the remote payload differs' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    before do
      allow(index).to receive(:find).with(endpoint).and_return({ 'id' => 'matched-id', 'access_type' => 'open' })
      allow(client).to receive(:update_dataservice)
    end

    it 'updates the dataservice' do
      sync

      expect(client).to have_received(:update_dataservice).with('matched-id', hash_including(access_type: 'restricted'))
    end

    it 'returns an updated result' do
      expect(sync).to have_attributes(status: :updated, remote_id: 'matched-id')
    end
  end

  context 'when the index finds a match and the remote payload already matches' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }
    let(:matching_payload) do
      Datagouv::FichePayloadBuilder.new(endpoint).payload.transform_keys(&:to_s).merge('id' => 'matched-id')
    end

    before do
      allow(index).to receive(:find).with(endpoint).and_return(matching_payload)
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

  context 'when updating a matched dataservice 404s (deleted between listing and updating)' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    before do
      allow(index).to receive(:find).with(endpoint).and_return({ 'id' => 'matched-id', 'access_type' => 'open' })
      allow(client).to receive(:update_dataservice).and_raise(Faraday::ResourceNotFound)
      allow(client).to receive(:create_dataservice).and_return({ 'id' => 'healed-id' })
    end

    it 'self-heals by creating a new dataservice' do
      sync

      expect(client).to have_received(:create_dataservice)
    end

    it 'returns a created result with the new id' do
      expect(sync).to have_attributes(status: :created, remote_id: 'healed-id')
    end
  end

  context 'when the client raises an unexpected error' do
    let(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

    before do
      allow(index).to receive(:find).with(endpoint).and_return({ 'id' => 'matched-id', 'access_type' => 'open' })
      allow(client).to receive(:update_dataservice).and_raise(Faraday::ServerError.new('boom'))
    end

    it 'returns a failed result' do
      expect(sync.status).to eq(:failed)
    end
  end
end
