RSpec.describe MakeRequestPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_make_request][:driver_params]
    end
    let(:status) { 200 }

    context 'with valid response from provider' do
      let!(:stubbed_request) do
        mock_valid_cnaf_quotient_familial(status:)
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

      context 'when there is a token_interactor key in config' do
        let(:token_interactor) { Interactor::Context.new(token: 'token') }
        let!(:stubbed_request) do
          stub_request(:post, Siade.credentials[:pole_emploi_status_url]).with(
            body: 'identifiant',
            headers: {
              'Content-Type' => 'application/json',
              'Authorization' => "Bearer #{token_interactor.token}",
              'X-pe-consommateur' => 'DINUM - 22222222-2222-2222-2222-222222222222'
            }
          ).to_return(
            status:
          )
        end

        let(:params) do
          Rails.application.config_for(:pings)[:api_kind][:with_make_request_and_token][:driver_params]
        end

        before do
          allow(PoleEmploi::Authenticate).to receive(:call).and_return(token_interactor)
        end

        it 'calls this class' do
          make_ping

          expect(PoleEmploi::Authenticate).to have_received(:call).at_least(:once)
        end

        it 'calls make request interactor with this token' do
          make_ping

          expect(stubbed_request).to have_been_requested
        end
      end
    end

    context 'when there is no response from organizer' do
      before do
        allow(CNAF::QuotientFamilial).to receive(:call).and_return(Interactor::Context.new)
      end

      it { is_expected.to eq(:bad_gateway) }
    end
  end
end
