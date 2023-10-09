RSpec.describe PingService, type: :service do
  before do
    Timecop.freeze(current_time)
  end

  after do
    Timecop.return
  end

  let(:current_time) { Time.zone.local(2023, 9, 10, 12, 0) }

  describe '#perform' do
    subject(:make_ping) { described_class.new(api_kind, identifier).perform }

    let(:api_kind) { 'api_kind' }

    let(:ok_payload) do
      {
        status:,
        last_update: current_time
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
      let(:ping_driver) { instance_double(RetrieverPingDriver, perform: status) }
      let(:status) { :whatever }

      before do
        allow(RetrieverPingDriver).to receive(:new).and_return(ping_driver)
      end

      context 'when it is in maintenance' do
        let(:identifier) { 'with_retriever_and_maintenance' }
        let(:current_time) { Time.zone.local(2023, 9, 10, 1, 30) }

        it 'does not call the driver' do
          make_ping

          expect(ping_driver).not_to have_received(:perform)
        end

        it do
          expect(make_ping).to eq({
            status: :ok,
            json: {
              status: :maintenance,
              until: 30.minutes.from_now,
              last_update: current_time
            }
          })
        end
      end

      context 'when it is not in maintenance' do
        it 'calls the driver with driver params' do
          make_ping

          expect(RetrieverPingDriver).to have_received(:new).with(
            retriever: 'CNAF::QuotientFamilial',
            params: {
              beneficiary_number: Siade.credentials[:ping_cnaf_numero_allocataire],
              postal_code: Siade.credentials[:ping_cnaf_postal_code]
            }
          )
        end

        context 'when driver is successful' do
          let(:status) { :ok }

          it do
            expect(make_ping).to eq({
              status: :ok,
              json: ok_payload
            })
          end
        end

        context 'when driver is not successful' do
          let(:status) { :bad_gateway }

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

            it 'does not call the driver' do
              make_ping

              expect(ping_driver).not_to have_received(:perform)
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

            context 'when driver is successful' do
              let(:status) { :ok }

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

            context 'when driver is not successful' do
              let(:status) { :bad_gateway }

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
end
