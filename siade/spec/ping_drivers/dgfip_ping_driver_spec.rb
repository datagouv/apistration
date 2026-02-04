RSpec.describe DGFIPPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_dgfip][:driver_params]
    end
    let(:routes) { params.fetch(:routes) }
    let(:etat_sante_url) { "#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/etatSante" }

    before do
      stub_request(:post, "#{Siade.credentials[:dgfip_apim_base_url]}/token")
        .to_return(status: 200, body: { access_token: 'bearer_token' }.to_json)
      AccessLog.delete_all
    end

    context 'when etatSante returns non-200' do
      before do
        stub_request(:get, etat_sante_url).to_return(status: 503)
      end

      it { is_expected.to eq(:bad_gateway) }
    end

    context 'when etatSante returns 200' do
      before do
        stub_request(:get, etat_sante_url).to_return(status: 200)
      end

      context 'when there is no data in access_logs' do
        it { is_expected.to eq(:ok) }
      end

      context 'when error ratio is below threshold (< 10%)' do
        before do
          10.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
          AccessLog.create!(route: routes.first, status: '503', timestamp: 1.minute.ago)
          AccessLogPingView.refresh!
        end

        it { is_expected.to eq(:ok) }
      end

      context 'when error ratio is at threshold (10%)' do
        before do
          9.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
          AccessLog.create!(route: routes.first, status: '503', timestamp: 1.minute.ago)
          AccessLogPingView.refresh!
        end

        it { is_expected.to eq(:bad_gateway) }
      end

      context 'when error ratio is above threshold' do
        before do
          5.times { AccessLog.create!(route: routes.first, status: '200', timestamp: 1.minute.ago) }
          5.times { AccessLog.create!(route: routes.first, status: '504', timestamp: 1.minute.ago) }
          AccessLogPingView.refresh!
        end

        it { is_expected.to eq(:bad_gateway) }
      end

      context 'when all requests are errors' do
        before do
          AccessLog.create!(route: routes.first, status: '503', timestamp: 1.minute.ago)
          AccessLogPingView.refresh!
        end

        it { is_expected.to eq(:bad_gateway) }
      end

      context 'when errors are on a different route' do
        before do
          AccessLog.create!(route: 'other/route#show', status: '503', timestamp: 1.minute.ago)
          AccessLogPingView.refresh!
        end

        it { is_expected.to eq(:ok) }
      end
    end
  end
end
