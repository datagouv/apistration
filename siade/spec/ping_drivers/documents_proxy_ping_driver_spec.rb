RSpec.describe DocumentsProxyPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_documents_proxy][:driver_params]
    end
    let(:route) { params.fetch(:routes).first }

    before do
      AccessLog.delete_all
    end

    def log_calls(count, status)
      count.times { AccessLog.create!(route:, status:, timestamp: 1.minute.ago) }
    end

    context 'when a few isolated errors happen among normal traffic' do
      before do
        log_calls(9, '200')
        log_calls(1, '502')
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:ok) }
    end

    context 'when every call fails but there are fewer than 5 calls' do
      before do
        log_calls(4, '502')
        AccessLogPingView.refresh!
      end

      it { is_expected.to eq(:ok) }
    end

    %w[502 503 504].each do |status|
      context "when 1 call out of 5 fails with #{status}" do
        before do
          log_calls(4, '200')
          log_calls(1, status)
          AccessLogPingView.refresh!
        end

        it { is_expected.to eq(:bad_gateway) }
      end
    end
  end
end
