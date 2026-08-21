require 'rails_helper'

RSpec.describe Datagouv::DataserviceIndex do
  subject(:index) { described_class.new(client: client) }

  let(:client) { instance_double(DatagouvAPIClient, list_dataservices: dataservices) }
  let(:endpoint) { APIEntreprise::Endpoint.find('dgfip/numero_tva') }
  let(:business_url) { Datagouv::FichePayloadBuilder.new(endpoint).business_documentation_url }

  context 'when a dataservice has the matching business_documentation_url' do
    let(:dataservices) do
      [
        { 'id' => 'other-id', 'title' => 'Unrelated', 'business_documentation_url' => 'https://entreprise.api.gouv.fr/catalogue/other/uid' },
        { 'id' => 'matched-id', 'title' => 'Something else entirely', 'business_documentation_url' => business_url }
      ]
    end

    it 'finds it' do
      expect(index.find(endpoint)).to eq(dataservices.last)
    end
  end

  context 'when no dataservice matches the business_documentation_url' do
    let(:dataservices) do
      [{ 'id' => 'other-id', 'title' => 'Unrelated', 'business_documentation_url' => 'https://entreprise.api.gouv.fr/catalogue/other/uid' }]
    end

    it 'returns nil' do
      expect(index.find(endpoint)).to be_nil
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
