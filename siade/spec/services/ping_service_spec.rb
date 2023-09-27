RSpec.describe PingService, type: :service do
  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  describe '#perform' do
    subject(:make_ping) { described_class.new(api_kind, identifier).perform }

    let(:api_kind) { 'api_kind' }

    let(:now) { Time.zone.now }

    context 'with unknown identifier' do
      let(:identifier) { 'unknown' }

      it do
        expect(make_ping).to eq({
          status: :not_found,
          json: {}
        })
      end
    end

    context 'with valid identifier' do
      let(:identifier) { 'with_retriever' }
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
          operation_id: "ping_#{api_kind}_#{identifier}"
        )
      end

      context 'when retriever is successful' do
        before do
          allow(interactor_context).to receive(:success?).and_return(true)
        end

        it do
          expect(make_ping).to eq({
            status: :ok,
            json: {
              last_update: now
            }
          })
        end
      end

      context 'when retriever is not successful' do
        before do
          allow(interactor_context).to receive(:success?).and_return(false)
        end

        it do
          expect(make_ping).to eq({
            status: :bad_gateway,
            json: {
              last_update: now
            }
          })
        end
      end
    end
  end
end
