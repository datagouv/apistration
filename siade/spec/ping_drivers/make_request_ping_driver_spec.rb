RSpec.describe MakeRequestPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_make_request][:driver_params]
    end
    let(:status) { 200 }

    context 'with valid response from provider' do
      let!(:stubbed_request) do
        stub_ants_extrait_immatriculation_vehicule_invalid(status:)
      end

      it 'calls the API' do
        make_ping

        expect(stubbed_request).to have_been_requested
      end

      context 'when status matches' do
        let(:status) { 200 }

        it { is_expected.to eq(:ok) }
      end

      context 'when status does not match' do
        let(:status) { 418 }

        it { is_expected.to eq(:bad_gateway) }
      end

      context 'when there is a token_interactor key in config' do
        let(:token_interactor) { Interactor::Context.new(token: 'token') }
        let!(:stubbed_request) do
          stub_request(:post, Siade.credentials[:france_travail_status_url]).with(
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
          allow(FranceTravail::Authenticate).to receive(:call).and_return(token_interactor)
        end

        it 'calls this class' do
          make_ping

          expect(FranceTravail::Authenticate).to have_received(:call).at_least(:once)
        end

        it 'calls make request interactor with this token' do
          make_ping

          expect(stubbed_request).to have_been_requested
        end
      end

      context 'with organizer params' do
        let(:token_interactor) { Interactor::Context.new(token: 'token') }
        let(:params) do
          Rails.application.config_for(:pings)[:api_kind][:with_make_request_and_organizer_params][:driver_params]
        end

        let!(:stubbed_request) do
          stub_request(:get, /#{Siade.credentials[:cnav_complementaire_sante_solidaire_url]}/).to_return(status:)
        end

        let(:organizer_params) do
          {
            dss_prestation_name: 'complementaire_sante_solidaire'
          }
        end

        before do
          allow(CNAV::Authenticate).to receive(:call).with(organizer_params).and_return(token_interactor)
          stub_cnav_authenticate('complementaire_sante_solidaire')
        end

        it 'calls the authenticator with params' do
          expect(CNAV::Authenticate).to receive(:call).with(organizer_params).at_least(:once)

          make_ping
        end

        it 'calls make request interactor with this token' do
          make_ping

          expect(stubbed_request).to have_been_requested
        end
      end
    end

    context 'when there is no response from organizer' do
      before do
        allow(ANTS::ExtraitImmatriculationVehicule::MakeRequest).to receive(:call).and_return(Interactor::Context.new)
      end

      it { is_expected.to eq(:bad_gateway) }
    end
  end
end
