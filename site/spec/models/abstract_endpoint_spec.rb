require 'rails_helper'

RSpec.describe AbstractEndpoint do
  describe '#sync_with_datagouv?' do
    context 'when sync_with_datagouv is not set in the yml' do
      subject(:endpoint) { APIEntreprise::Endpoint.find('inpi/rne/beneficiaires_effectifs') }

      it 'defaults to true' do
        expect(endpoint.sync_with_datagouv?).to be true
      end
    end

    context 'when sync_with_datagouv is explicitly false' do
      subject(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements') }

      it 'is false' do
        expect(endpoint.sync_with_datagouv?).to be false
      end
    end
  end

  describe '#api_status' do
    subject(:endpoint) { APIEntreprise::Endpoint.find('insee/etablissements') }

    let(:ping_url) { endpoint.ping_url }

    it 'is nil without ping_url' do
      endpoint.ping_url = nil

      expect(endpoint.api_status).to be_nil
    end

    it 'is ok when the ping answers ok' do
      stub_request(:get, ping_url).to_return(status: 200, body: { status: 'ok' }.to_json)

      expect(endpoint.api_status).to eq(:ok)
    end

    it 'is under maintenance when the ping answers 200 with a maintenance status' do
      stub_request(:get, ping_url).to_return(status: 200, body: { status: 'maintenance' }.to_json)

      expect(endpoint.api_status).to eq(:maintenance)
    end

    it 'is unknown when the ping answers 200 without a known status' do
      stub_request(:get, ping_url).to_return(status: 200, body: { status: 'unknown' }.to_json)

      expect(endpoint.api_status).to eq(:unknown)
    end

    it 'is ko when the ping answers an error' do
      stub_request(:get, ping_url).to_return(status: 502)

      expect(endpoint.api_status).to eq(:ko)
    end

    it 'is ko when the ping times out' do
      stub_request(:get, ping_url).to_timeout

      expect(endpoint.api_status).to eq(:ko)
    end

    it 'is ko when the connection fails' do
      stub_request(:get, ping_url).to_raise(Errno::ECONNREFUSED)

      expect(endpoint.api_status).to eq(:ko)
    end

    it 'gives the verdict of the provider pings page for the same ping' do
      ping = stub_request(:get, ping_url).to_return(status: 200, body: { status: 'maintenance' }.to_json)

      provider_check = ProviderPings.new('api_entreprise').check(ping_url)

      expect(endpoint.api_status).to eq(provider_check.status)
      expect(ping).to have_been_requested.once
    end

    it 'shares the status between instances, down included' do
      ping = stub_request(:get, ping_url).to_return(status: 502)

      2.times { APIEntreprise::Endpoint.find('insee/etablissements').api_status }

      expect(ping).to have_been_requested.once
    end

    it 'probes again once the status is a minute old' do
      ping = stub_request(:get, ping_url).to_return(status: 502)

      endpoint.api_status
      Timecop.travel(2.minutes.from_now) { APIEntreprise::Endpoint.find('insee/etablissements').api_status }

      expect(ping).to have_been_requested.twice
    end
  end
end
