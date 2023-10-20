RSpec.describe SyncPingsWithMonitorsRemoteService, type: :service do
  describe '#perform' do
    subject(:sync_pings_with_monitors) { described_class.new.perform }

    let(:get_monitors) do
      [
        {
          'uuid' => '1',
          'name' => 'With Retriever and Maintenance',
          'url' => 'https://particulier.api.gouv.fr/api/with_retriever_and_maintenance/ping'
        }
      ]
    end

    let(:default_params) do
      {
        regions: %w[
          london
          paris
          frankfurt
          amsterdam
        ]
      }
    end

    before do
      allow(HyperpingAPI).to receive(:new).and_return(hyperping_api_service)
    end

    context 'when everything is fine' do
      let(:hyperping_api_service) { instance_double(HyperpingAPI, get_monitors:, create_monitor: {}, update_monitor: {}) }

      it 'creates missing API with valid attributes' do
        sync_pings_with_monitors

        expect(hyperping_api_service).to have_received(:create_monitor).with(
          default_params.merge(
            name: 'With Retriever',
            url: 'https://particulier.api.gouv.fr/api/with_retriever/ping'
          )
        )
      end

      it 'updates existing API with valid attributes' do
        sync_pings_with_monitors

        expect(hyperping_api_service).to have_received(:update_monitor).with(
          '1',
          default_params.merge(
            name: 'With Retriever and Maintenance'
          )
        )
      end
    end

    context 'when there is an error on one' do
      let(:hyperping_api_service) { instance_double(HyperpingAPI, get_monitors:, create_monitor: {}) }

      before do
        allow(hyperping_api_service).to receive(:update_monitor).and_raise(JSON::ParserError)
      end

      it 'works for the other' do
        sync_pings_with_monitors

        expect(hyperping_api_service).to have_received(:create_monitor).with(
          default_params.merge(
            name: 'With Retriever',
            url: 'https://particulier.api.gouv.fr/api/with_retriever/ping'
          )
        )
      end

      it 'tracks error' do
        expect(MonitoringService.instance).to receive(:track).with(
          'error',
          'Fail to update ping properties on status page',
          hash_including(
            identifier: :with_retriever_and_maintenance
          )
        )

        sync_pings_with_monitors
      end
    end
  end
end
