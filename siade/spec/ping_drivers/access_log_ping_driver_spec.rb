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
          AccessLogPingView.refresh!
        end

        it { is_expected.to eq(:unknown) }
      end

      context 'when there is data for routes in the period' do
        before do
          AccessLog.create!(valid_access_log_data.merge(extra_data))
          AccessLogPingView.refresh!
        end

        context 'when it is not the matching route' do
          let(:extra_data) { { route: 'another/route#show' } }

          it { is_expected.to eq(:unknown) }
        end

        context 'when it is not a 200 status' do
          let(:extra_data) { { status: '404' } }

          it { is_expected.to eq(:bad_gateway) }

          describe 'with a excluded statuses config' do
            let(:params) do
              Rails.application.config_for(:pings)[:api_kind][:with_access_logs_and_excluded_status][:driver_params]
            end

            it { is_expected.to eq(:unknown) }
          end
        end

        context 'when everything is valid' do
          let(:extra_data) { {} }

          it { is_expected.to eq(:ok) }
        end
      end
    end

    context 'when there is a ActiveRecord::StatementInvalid error, due to refreshing view and table not exists' do
      before do
        pg_error = PG::UndefinedTable.new('ERROR: relation "admin_apientreprise_production_access_logs_last_10_minutes" does not exist')
        ar_error = ActiveRecord::StatementInvalid.new(pg_error.message)
        ar_error.set_backtrace(caller)

        allow(AccessLogPingView).to receive(:where).and_raise(ar_error)
        allow(ar_error).to receive(:cause).and_return(pg_error)
      end

      it 'returns :unknown' do
        expect(make_ping).to eq(:unknown)
      end
    end
  end
end
