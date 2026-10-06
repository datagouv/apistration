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

    it 'is up when the ping answers 200' do
      stub_request(:get, ping_url).to_return(status: 200)

      expect(endpoint.api_status).to eq('up')
    end

    it 'is down when the ping answers an error' do
      stub_request(:get, ping_url).to_return(status: 502)

      expect(endpoint.api_status).to eq('down')
    end

    it 'is down when the ping times out' do
      stub_request(:get, ping_url).to_timeout

      expect(endpoint.api_status).to eq('down')
    end

    it 'is down when the connection fails' do
      stub_request(:get, ping_url).to_raise(Errno::ECONNREFUSED)

      expect(endpoint.api_status).to eq('down')
    end

    it 'shares the status between instances, down included' do
      ping = stub_request(:get, ping_url).to_return(status: 502)

      2.times { APIEntreprise::Endpoint.find('insee/etablissements').api_status }

      expect(ping).to have_been_requested.once
    end

    it 'probes again once the cache expires' do
      ping = stub_request(:get, ping_url).to_return(status: 502)

      endpoint.api_status
      Timecop.travel(2.minutes.from_now) { APIEntreprise::Endpoint.find('insee/etablissements').api_status }

      expect(ping).to have_been_requested.twice
    end

    it 'uses short timeouts' do
      stub_request(:get, ping_url).to_return(status: 200)
      allow(Net::HTTP).to receive(:start).and_call_original

      endpoint.api_status

      expect(Net::HTTP).to have_received(:start).with(anything, anything, hash_including(open_timeout: 2, read_timeout: 3))
    end
  end
end
