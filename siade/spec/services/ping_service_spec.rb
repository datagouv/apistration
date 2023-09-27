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
    let(:ok_payload) do
      {
        last_update: now,
      }
    end

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
            json: ok_payload
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
            json: ok_payload
          })
        end
      end

      describe 'with cache' do
        let(:identifier) { 'with_retriever_and_cache' }
        let(:cache_key) { "ping_#{api_kind}_#{identifier}" }

        context 'when cache is present' do
          before do
            Rails.cache.write(cache_key, {
              status: :ok,
              json: ok_payload
            })
          end

          it 'does not call the retriever' do
            make_ping

            expect(retriever).not_to have_received(:call)
          end

          it do
            expect(make_ping).to eq({
              status: :ok,
              json: ok_payload
            })
          end
        end

        context 'when cache is empty' do
          before do
            Rails.cache.delete(cache_key)
          end

          context 'when retriever is successful' do
            before do
              allow(interactor_context).to receive(:success?).and_return(true)
            end

            it do
              expect(make_ping).to eq({
                status: :ok,
                json: ok_payload
              })
            end

            it 'stores the result in cache for the time specified' do
              make_ping

              expect(Rails.cache.read(cache_key)).to eq({
                status: :ok,
                json: ok_payload
              })

              expect(Rails.cache.redis.ttl("ping_#{api_kind}_#{identifier}")).to be_within(5).of(5.minutes)
            end
          end

          context 'when retriever is not successful' do
            before do
              allow(interactor_context).to receive(:success?).and_return(false)
            end

            it do
              expect(make_ping).to eq({
                status: :bad_gateway,
                json: ok_payload
              })
            end

            it 'does not stores the result in cache' do
              make_ping

              expect(Rails.cache.read(cache_key)).to be_nil
            end
          end
        end
      end
    end
  end
end
