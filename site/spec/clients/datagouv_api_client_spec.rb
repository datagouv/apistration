require 'rails_helper'

RSpec.describe DatagouvAPIClient do
  subject(:client) { described_class.new }

  let(:host) { 'https://datagouv.example.test' }
  let(:token) { 'test-token' }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('DATAGOUV_HOST').and_return(host)
    allow(ENV).to receive(:fetch).with('DATAGOUV_API_TOKEN').and_return(token)
  end

  describe '#list_dataservices' do
    subject(:list_dataservices) { client.list_dataservices(organization: 'org-id') }

    context 'when there is a single page of results' do
      before do
        stub_request(:get, "#{host}/api/1/dataservices/")
          .with(query: { organization: 'org-id', page: 1, page_size: 100 }, headers: { 'X-API-KEY' => token })
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: { 'data' => [{ 'id' => 'a' }, { 'id' => 'b' }], 'next_page' => nil }.to_json
          )
      end

      it 'returns every dataservice from the response' do
        expect(list_dataservices).to eq([{ 'id' => 'a' }, { 'id' => 'b' }])
      end
    end

    context 'when there are multiple pages of results' do
      before do
        stub_request(:get, "#{host}/api/1/dataservices/")
          .with(query: { organization: 'org-id', page: 1, page_size: 100 })
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: { 'data' => [{ 'id' => 'a' }], 'next_page' => "#{host}/api/1/dataservices/?organization=org-id&page=2&page_size=100" }.to_json
          )
        stub_request(:get, "#{host}/api/1/dataservices/")
          .with(query: { organization: 'org-id', page: 2, page_size: 100 })
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: { 'data' => [{ 'id' => 'b' }], 'next_page' => nil }.to_json
          )
      end

      it 'follows next_page and concatenates every page' do
        expect(list_dataservices).to eq([{ 'id' => 'a' }, { 'id' => 'b' }])
      end
    end
  end

  describe '#create_dataservice' do
    subject(:create_dataservice) { client.create_dataservice({ title: 'New fiche' }) }

    context 'when the API accepts the payload' do
      before do
        stub_request(:post, "#{host}/api/1/dataservices/")
          .with(body: { title: 'New fiche' }.to_json, headers: { 'X-API-KEY' => token })
          .to_return(status: 201, headers: { 'Content-Type' => 'application/json' }, body: { 'id' => 'new-id', 'title' => 'New fiche' }.to_json)
      end

      it 'returns the created dataservice' do
        expect(create_dataservice).to eq({ 'id' => 'new-id', 'title' => 'New fiche' })
      end
    end

    context 'when the payload is invalid' do
      before do
        stub_request(:post, "#{host}/api/1/dataservices/").to_return(status: 400, body: '{}')
      end

      it 'raises Faraday::BadRequestError' do
        expect { create_dataservice }.to raise_error(Faraday::BadRequestError)
      end
    end
  end

  describe '#update_dataservice' do
    subject(:update_dataservice) { client.update_dataservice('abc123', { title: 'Updated' }) }

    before do
      stub_request(:patch, "#{host}/api/1/dataservices/abc123/")
        .with(body: { title: 'Updated' }.to_json)
        .to_return(status: 200, headers: { 'Content-Type' => 'application/json' }, body: { 'id' => 'abc123', 'title' => 'Updated' }.to_json)
    end

    it 'returns the updated dataservice' do
      expect(update_dataservice).to eq({ 'id' => 'abc123', 'title' => 'Updated' })
    end
  end

  describe '#delete_dataservice' do
    subject(:delete_dataservice) { client.delete_dataservice('abc123') }

    context 'when the dataservice exists' do
      before do
        stub_request(:delete, "#{host}/api/1/dataservices/abc123/").to_return(status: 204)
      end

      it 'does not raise' do
        expect { delete_dataservice }.not_to raise_error
      end
    end

    context 'when the dataservice is already gone' do
      before do
        stub_request(:delete, "#{host}/api/1/dataservices/abc123/").to_return(status: 404, body: '{}')
      end

      it 'raises Faraday::ResourceNotFound' do
        expect { delete_dataservice }.to raise_error(Faraday::ResourceNotFound)
      end
    end
  end

  describe 'network failure' do
    subject(:list_dataservices) { client.list_dataservices(organization: 'org-id') }

    before do
      stub_request(:get, "#{host}/api/1/dataservices/")
        .with(query: { organization: 'org-id', page: 1, page_size: 100 })
        .to_timeout
    end

    it 'raises a Faraday error' do
      expect { list_dataservices }.to raise_error(Faraday::Error)
    end
  end
end
