RSpec.describe MakeRequestPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_make_request][:driver_params]
    end
    let(:status) { 200 }

    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:pole_emploi_status_url]).to_return(
        status:
      )
    end

    it 'calls the API' do
      make_ping

      expect(stubbed_request).to have_been_requested
    end

    context 'when status matches' do
      let(:status) { 404 }

      it { is_expected.to eq(:ok) }
    end

    context 'when status does not match' do
      let(:status) { 418 }

      it { is_expected.to eq(:bad_gateway) }
    end
  end
end
