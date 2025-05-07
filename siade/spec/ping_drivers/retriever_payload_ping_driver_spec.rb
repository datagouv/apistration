RSpec.describe RetrieverPayloadPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_retriever_payload][:driver_params]
    end

    let(:retriever) { CNAF::QuotientFamilial }
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
          beneficiary_number: Siade.credentials[:ping_cnaf_numero_allocataire],
          postal_code: Siade.credentials[:ping_cnaf_postal_code]
        },
        recipient: JwtTokenService::DINUM_SIRET,
        operation_id: 'ping_cnaf_quotient_familial'
      )
    end

    context 'when retriever is successful' do
      let(:bundled_data) { BundledData.new(data: resource, context: {}) }

      before do
        allow(interactor_context).to receive_messages(success?: true, bundled_data:)
      end

      context 'when payload is valid' do
        let(:resource) { Resource.new(a: { b: { c: ['data'] } }) }

        it { is_expected.to eq(:ok) }
      end

      context 'when payload is not valid' do
        context 'when method is valid' do
          let(:resource) { Resource.new(a: { b: { c: [] } }) }

          it { is_expected.to eq(:bad_gateway) }
        end

        context 'when method is not valid' do
          let(:resource) { Resource.new(a: 'wrong') }

          it { is_expected.to eq(:bad_gateway) }
        end
      end
    end

    context 'when retriever is not successful' do
      before do
        allow(interactor_context).to receive(:success?).and_return(false)
      end

      it { is_expected.to eq(:bad_gateway) }
    end
  end
end
