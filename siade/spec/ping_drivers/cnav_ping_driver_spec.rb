RSpec.describe CNAVPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_cnav][:driver_params]
    end
    let(:routes) { params.fetch(:routes) }
    let(:provider) { params.fetch(:provider) }

    before do
      AccessLog.delete_all
    end

    context 'when recently out of maintenance' do
      let(:maintenance) { instance_double(MaintenanceService, to_hour: 5.minutes.ago) }

      before do
        allow(MaintenanceService).to receive(:new).with(provider).and_return(maintenance)
        5.times { AccessLog.create!(route: routes.first, status: '502', timestamp: 1.minute.ago) }
        AccessLogPingView.refresh!
      end

      it 'returns :ok despite high error ratio' do
        expect(subject).to eq(:ok)
      end
    end

    context 'when maintenance ended more than 10 minutes ago' do
      let(:maintenance) { instance_double(MaintenanceService, to_hour: 15.minutes.ago) }

      before do
        allow(MaintenanceService).to receive(:new).with(provider).and_return(maintenance)
        5.times { AccessLog.create!(route: routes.first, status: '502', timestamp: 1.minute.ago) }
        AccessLogPingView.refresh!
      end

      it 'returns :bad_gateway due to high error ratio' do
        expect(subject).to eq(:bad_gateway)
      end
    end

    context 'when there is no data in access_logs' do
      it { is_expected.to eq(:ok) }
    end

    context 'when error ratio is below threshold (< 10%)' do
      before do
        10.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
        AccessLog.create!(route: routes.first, status: '502', timestamp: 1.minute.ago)
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:ok) }
    end

    context 'when error ratio is at threshold (10%) with 502' do
      before do
        9.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
        AccessLog.create!(route: routes.first, status: '502', timestamp: 1.minute.ago)
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:bad_gateway) }
    end

    context 'when error ratio is above threshold with mixed 502/503/504' do
      before do
        5.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
        2.times { AccessLog.create!(route: routes.first, status: '502', timestamp: 1.minute.ago) }
        2.times { AccessLog.create!(route: routes.first, status: '503', timestamp: 1.minute.ago) }
        AccessLog.create!(route: routes.first, status: '504', timestamp: 1.minute.ago)
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:bad_gateway) }
    end

    context 'when errors are on a different route' do
      before do
        AccessLog.create!(route: 'other/route#show', status: '502', timestamp: 1.minute.ago)
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:ok) }
    end

    context 'when rate-limit responses (subcode 008) are below the 25% rate-limit threshold' do
      before do
        8.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
        2.times do
          AccessLog.create!(
            route: routes.first, status: '502', timestamp: 1.minute.ago,
            params: { error_subcode: '008' }
          )
        end
        AccessLogPingView.refresh!
      end

      it 'returns :ok despite a raw ratio above the normal 10% threshold' do
        expect(subject).to eq(:ok)
      end
    end

    context 'when rate-limit responses (subcode 008) are at the 25% rate-limit threshold' do
      before do
        9.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
        3.times do
          AccessLog.create!(
            route: routes.first, status: '502', timestamp: 1.minute.ago,
            params: { error_subcode: '008' }
          )
        end
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:bad_gateway) }
    end

    context 'when non-rate-limited errors are at the normal 10% threshold despite rate-limit noise below 25%' do
      before do
        15.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
        3.times do
          AccessLog.create!(
            route: routes.first, status: '502', timestamp: 1.minute.ago,
            params: { error_subcode: '008' }
          )
        end
        2.times { AccessLog.create!(route: routes.first, status: '502', timestamp: 1.minute.ago) }
        AccessLogPingView.refresh!
      end

      it 'returns :bad_gateway due to the non-rate-limited errors alone' do
        expect(subject).to eq(:bad_gateway)
      end
    end

    context 'when both rate-limited and non-rate-limited errors stay under their own threshold' do
      before do
        18.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
        AccessLog.create!(
          route: routes.first, status: '502', timestamp: 1.minute.ago,
          params: { error_subcode: '008' }
        )
        AccessLog.create!(route: routes.first, status: '502', timestamp: 1.minute.ago)
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:ok) }
    end
  end
end
