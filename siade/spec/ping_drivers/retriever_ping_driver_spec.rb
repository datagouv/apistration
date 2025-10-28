RSpec.describe RetrieverPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_retriever][:driver_params]
    end

    let(:retriever) { INPI::RNE::BeneficiairesEffectifs }
    let(:interactor_context) { Interactor::Context.new }

    before do
      allow(retriever).to receive(:call).and_return(
        interactor_context
      )
    end

    it 'calls the correct retriever with params' do
      make_ping

      expect(retriever).to have_received(:call).with(
        params: {
          inpi_rne_login_password: Siade.credentials[:inpi_rne_login_ping_password],
          inpi_rne_login_username: Siade.credentials[:inpi_rne_login_ping_username],
          siren: '900225095'
        },
        recipient: JwtTokenService::DINUM_SIRET,
        operation_id: 'ping_inpi_rne_beneficiaires_effectifs'
      )
    end

    context 'when retriever is successful' do
      before do
        allow(interactor_context).to receive(:success?).and_return(true)
      end

      it { is_expected.to eq(:ok) }
    end

    context 'when retriever is not successful' do
      before do
        allow(interactor_context).to receive(:success?).and_return(false)
      end

      it { is_expected.to eq(:bad_gateway) }
    end
  end
end
