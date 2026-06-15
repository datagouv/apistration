RSpec.describe DGFIP::TVA::FetchRefreshDate, type: :interactor do
  subject(:result) { described_class.call }

  let(:resource_url) do
    "https://www.data.gouv.fr/api/2/datasets/resources/#{DGFIP::TVA::MakeRequest::RESOURCE_ID}/"
  end

  before { Rails.cache.clear }

  context 'when the API returns a last_modified date' do
    before do
      stub_request(:get, resource_url)
        .to_return(status: 200, body: { resource: { last_modified: '2026-06-11T11:00:00+00:00' } }.to_json)
    end

    it { is_expected.to be_a_success }

    its(:date_derniere_mise_a_jour) { is_expected.to eq('2026-06-11') }

    it 'caches the result' do
      memory_cache = ActiveSupport::Cache::MemoryStore.new
      allow(Rails).to receive(:cache).and_return(memory_cache)

      2.times { described_class.call }

      expect(WebMock).to have_requested(:get, resource_url).once
    end
  end

  context 'when the API is unavailable' do
    before do
      stub_request(:get, resource_url).to_return(status: 503)
    end

    it { is_expected.to be_a_success }

    its(:date_derniere_mise_a_jour) { is_expected.to be_nil }
  end

  context 'when the API raises a network error' do
    before do
      stub_request(:get, resource_url).to_raise(StandardError)
    end

    it { is_expected.to be_a_success }

    its(:date_derniere_mise_a_jour) { is_expected.to be_nil }
  end
end
