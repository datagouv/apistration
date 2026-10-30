require 'rails_helper'

RSpec.describe ProviderPings do
  describe '#checks' do
    let(:ping_urls) { %w[a b c].map { |id| "#{APIEntreprise::BASE_URL}/ping/#{id}" } }
    let(:probes_in_flight) { Queue.new }
    let(:release_probes) { Queue.new }
    let!(:pings) do
      ping_urls.map do |url|
        stub_request(:get, url).to_return(lambda { |_request|
          probes_in_flight << url
          release_probes.pop(timeout: 10)
          { status: 200, body: { status: 'ok' }.to_json }
        })
      end
    end

    before do
      stub_request(:get, APIEntreprise::PINGS_URL).to_return(status: 200, body: ping_urls.map { |url| { name: url, url: } }.to_json)
      described_class.new('api_entreprise').all
    end

    def checks_from_visitors_arriving_during_probes(count)
      visitors = Array.new(count) { Thread.new { described_class.new('api_entreprise').checks } }
      Timeout.timeout(5) { sleep 0.01 until only_probing_visitors_left?(visitors) }
      release_every_probe_of(visitors)
      visitors.map(&:value)
    ensure
      release_every_probe_of(visitors.to_a)
      visitors.to_a.each { |visitor| visitor.join(10) }
    end

    def release_every_probe_of(visitors)
      (visitors.size * ping_urls.size).times { release_probes << true }
    end

    def only_probing_visitors_left?(visitors)
      probes_in_flight.size == ping_urls.size && visitors.count(&:alive?) <= ping_urls.size
    end

    it 'probes each provider once when visitors arrive together on a cold cache' do
      checks_from_visitors_arriving_during_probes(5)

      expect(pings).to all(have_been_requested.once)
    end

    it 'serves the stored statuses to the visitors coming right after' do
      checks_from_visitors_arriving_during_probes(5)

      checks = Array.new(3) { Thread.new { described_class.new('api_entreprise').checks } }.map(&:value)

      expect(checks).to all(match(ping_urls.index_with { have_attributes(status: :ok) }))
      expect(pings).to all(have_been_requested.once)
    end
  end
end
