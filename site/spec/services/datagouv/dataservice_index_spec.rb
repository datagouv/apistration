require 'rails_helper'

RSpec.describe Datagouv::DataserviceIndex do
  subject(:index) { described_class.new(client: client) }

  let(:client) { instance_double(DatagouvAPIClient, list_dataservices: dataservices) }
  let(:endpoint) { APIEntreprise::Endpoint.find('dgfip/numero_tva') }

  context 'when a dataservice has the marker for the endpoint uid' do
    let(:dataservices) do
      [
        { 'id' => 'other-id', 'title' => 'Unrelated', 'description' => 'no marker here' },
        { 'id' => 'matched-id', 'title' => 'Something else entirely',
          'description' => "<!-- apistration-endpoint-uid: #{endpoint.uid} -->\nSome description." }
      ]
    end

    it 'finds it by marker, ignoring title' do
      expect(index.find(endpoint)).to eq(dataservices.last)
    end
  end

  context 'when no dataservice has the marker but one matches by title' do
    let(:title) { Datagouv::FichePayloadBuilder.new(endpoint).title }
    let(:dataservices) do
      [
        { 'id' => 'other-id', 'title' => 'Unrelated', 'description' => 'no marker here' },
        { 'id' => 'matched-id', 'title' => title, 'description' => 'A pre-existing dataservice with no marker yet.' }
      ]
    end

    it 'falls back to an exact title match' do
      expect(index.find(endpoint)).to eq(dataservices.last)
    end
  end

  context 'when neither the marker nor the title matches anything' do
    let(:dataservices) do
      [{ 'id' => 'other-id', 'title' => 'Unrelated', 'description' => 'no marker here' }]
    end

    it 'returns nil' do
      expect(index.find(endpoint)).to be_nil
    end
  end

  context 'when the description is nil' do
    let(:dataservices) { [{ 'id' => 'other-id', 'title' => 'Unrelated', 'description' => nil }] }

    it 'does not raise and returns nil' do
      expect(index.find(endpoint)).to be_nil
    end
  end

  describe '#marker_match' do
    context 'when a dataservice has the marker for the endpoint uid' do
      let(:dataservices) do
        [
          { 'id' => 'other-id', 'title' => 'Unrelated', 'description' => 'no marker here' },
          { 'id' => 'matched-id', 'title' => 'Something else entirely',
            'description' => "<!-- apistration-endpoint-uid: #{endpoint.uid} -->\nSome description." }
        ]
      end

      it 'finds it by marker' do
        expect(index.marker_match(endpoint)).to eq(dataservices.last)
      end
    end

    context 'when no dataservice has the marker, even if one matches by title' do
      let(:title) { Datagouv::FichePayloadBuilder.new(endpoint).title }
      let(:dataservices) do
        [{ 'id' => 'matched-id', 'title' => title, 'description' => 'A pre-existing dataservice with no marker yet.' }]
      end

      it 'does not fall back to a title match, and returns nil' do
        expect(index.marker_match(endpoint)).to be_nil
      end
    end
  end

  describe 'listing' do
    let(:dataservices) { [] }

    it 'lists dataservices for the DINUM organization' do
      index

      expect(client).to have_received(:list_dataservices).with(organization: Datagouv::FichePayloadBuilder::ORGANIZATION_ID)
    end
  end
end
