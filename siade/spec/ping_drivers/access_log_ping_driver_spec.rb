RSpec.describe AccessLogPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_access_logs][:driver_params]
    end
    let(:routes) { params.fetch(:routes) }
    let(:valid_access_log_data) do
      {
        route: routes.sample,
        status: '200',
        timestamp: 1.minute.ago
      }
    end

    before do
      AccessLog.delete_all
    end

    context 'when there is no data' do
      it { is_expected.to eq(:unknown) }
    end

    context 'when there is data' do
      context 'when there is no data for routes in the period' do
        before do
          AccessLog.create!(route: routes.sample, timestamp: 6.minutes.ago)
        end

        it { is_expected.to eq(:unknown) }
      end

      context 'when there is data for routes in the period' do
        before do
          AccessLog.create!(valid_access_log_data.merge(extra_data))
        end

        context 'when it is not the matching route' do
          let(:extra_data) { { route: 'another/route#show' } }

          it { is_expected.to eq(:unknown) }
        end

        context 'when it is not a 200 status' do
          let(:extra_data) { { status: '502' } }

          it { is_expected.to eq(:bad_gateway) }
        end

        context 'when everything is valid' do
          let(:extra_data) { {} }

          it { is_expected.to eq(:ok) }
        end
      end
    end
  end
end
