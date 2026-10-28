RSpec.describe HyperpingMonitorsSyncJob do
  subject(:sync) { described_class.perform_now }

  let(:hyperping_api) do
    instance_double(HyperpingAPI, get_monitors: remote_monitors, create_monitor: {}, update_monitor: {})
  end

  let(:remote_monitors) do
    [
      {
        'uuid' => 'mon_existing',
        'name' => 'Old name',
        'url' => 'https://particulier.api.gouv.fr/api/existing/ping'
      }
    ]
  end

  let(:pings) do
    {
      api_particulier: {
        existing: { status_page: { name: 'Existing', alerts_wait: 5 } },
        missing: { status_page: { name: 'Missing', alerts_wait: 10 } },
        paused: { status_page: { name: 'Paused', paused: true } },
        without_status_page: { kind: 'retriever' }
      },
      api_entreprise: {
        'insee/sirene': { status_page: { name: 'INSEE - Sirene' } }
      },
      api_kind: {
        ignored: { status_page: { name: 'Ignored' } }
      }
    }
  end

  let(:default_regions) { %w[london paris frankfurt amsterdam] }

  around do |example|
    frontal = ENV.fetch('FRONTAL', nil)
    example.run
  ensure
    ENV['FRONTAL'] = frontal
  end

  before do
    allow(HyperpingAPI).to receive(:new).and_return(hyperping_api)
    allow(Rails.application).to receive(:config_for).with(:pings).and_return(pings)
    allow(Rails.env).to receive(:production?).and_return(true)
  end

  context 'when it is the frontal app' do
    before do
      ENV['FRONTAL'] = 'true'
    end

    it 'creates the monitors Hyperping does not have yet' do
      sync

      expect(hyperping_api).to have_received(:create_monitor).with(
        regions: default_regions,
        alerts_wait: 10,
        paused: false,
        name: 'Missing',
        url: 'https://particulier.api.gouv.fr/api/missing/ping'
      )
    end

    it 'builds the url of an API Entreprise monitor from its path' do
      sync

      expect(hyperping_api).to have_received(:create_monitor).with(
        hash_including(url: 'https://entreprise.api.gouv.fr/ping/insee/sirene')
      )
    end

    it 'takes paused from the status page' do
      sync

      expect(hyperping_api).to have_received(:create_monitor).with(
        hash_including(name: 'Paused', paused: true)
      )
    end

    it 'updates the monitors Hyperping already has, without recreating them' do
      sync

      expect(hyperping_api).to have_received(:update_monitor).with(
        'mon_existing',
        regions: default_regions,
        alerts_wait: 5,
        paused: false,
        name: 'Existing'
      )
      expect(hyperping_api).not_to have_received(:create_monitor).with(
        hash_including(url: 'https://particulier.api.gouv.fr/api/existing/ping')
      )
    end

    it 'skips pings without a status page and the other api kinds' do
      sync

      expect(hyperping_api).to have_received(:create_monitor).exactly(3).times
    end

    context 'when Hyperping fails on one monitor' do
      before do
        allow(hyperping_api).to receive(:update_monitor).and_raise(HyperpingAPI::Error.new('429', 'Rate limit'))
      end

      it 'still syncs the monitors after it, then reports the failure' do
        expect { sync }.to raise_error(described_class::SyncError, /1 monitors failed.*api_particulier existing/)

        expect(hyperping_api).to have_received(:create_monitor).with(hash_including(name: 'Paused'))
      end
    end

    context 'when Hyperping cannot list the monitors' do
      before do
        allow(hyperping_api).to receive(:get_monitors).and_raise(HyperpingAPI::Error.new('401', 'Unauthorized'))
      end

      it 'fails once without trying to write anything' do
        expect { sync }.to raise_error(HyperpingAPI::Error)

        expect(hyperping_api).to have_received(:get_monitors).once
        expect(hyperping_api).not_to have_received(:create_monitor)
      end
    end
  end

  context 'when it is not the frontal app' do
    before do
      ENV['FRONTAL'] = 'false'
    end

    it 'does not call Hyperping' do
      sync

      expect(HyperpingAPI).not_to have_received(:new)
    end
  end
end
