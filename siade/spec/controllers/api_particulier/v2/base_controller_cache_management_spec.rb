require 'rails_helper'

RSpec.describe APIParticulier::V2::BaseController, 'cache_management' do
  describe 'cache management' do
    class DummyRetrieverOrganizer < RetrieverOrganizer; end

    subject(:call!) do
      routes.draw { get 'show' => 'api_particulier/v2/base#show' }

      get :show, params: { token: yes_jwt }
    end

    before do
      allow(DummyRetrieverOrganizer).to receive(:call)
    end

    context 'when cache is activated' do
      controller(described_class) do
        def show
          retrieve_payload_data(
            DummyRetrieverOrganizer,
            cache: true,
            expires_in: 1.hour
          )
        end

        private

        def operation_id
          'operation_id'
        end

        def organizer_params
          {
            very: :parameters
          }
        end

        def serializer_module
          APIParticulier::DummyResourceSerializer
        end
      end

      context 'when Cache-Control: no-cache request header is present' do
        before do
          request.headers['Cache-Control'] = 'no-cache'
        end

        it 'does not call CacheResourceRetriever' do
          expect(CacheResourceRetriever).not_to receive(:call)

          call!
        end

        it 'renders X-Response-cached header as false, and an empty X-Cache-Expires-in' do
          call!

          expect(response.headers['X-Response-Cached']).to be(false)
          expect(response.headers['X-Cache-Expires-in']).to eq('')
        end

        it 'adds custom field retriever_cached as false on LogStasher' do
          expect(LogStasher).to receive(:build_logstash_event).with(
            hash_including(
              retriever_cached: false
            ),
            anything
          )

          call!
        end

        it 'calls the retriever with parameters and operation id' do
          expect(DummyRetrieverOrganizer)
            .to receive(:call)
            .with(
              hash_including(
                params: { very: :parameters },
                operation_id: 'operation_id'
              )
            )

          call!
        end
      end

      context 'without the Cache-Control: no-cache request header' do
        # rubocop:disable RSpec/VerifiedDoubles
        let(:cache_resource_retriever) { double('cache_resource_retriever', from_cache: true, expires_in: 9001) }
        # rubocop:enable RSpec/VerifiedDoubles

        before do
          allow(CacheResourceRetriever).to receive(:call).and_return(cache_resource_retriever)
        end

        it 'renders X-Response-cached header as true, with X-Cache-Expires-in sets as an integer' do
          call!

          expect(response.headers['X-Response-Cached']).to be(true)
          expect(response.headers['X-Cache-Expires-in']).to eq(9001)
        end

        it 'adds custom field retriever_cached as true on LogStasher' do
          expect(LogStasher).to receive(:build_logstash_event).with(
            hash_including(
              retriever_cached: true
            ),
            anything
          )

          call!
        end

        it 'calls CacheResourceRetriever with parameters' do
          expect(CacheResourceRetriever)
            .to receive(:call)
            .with({
              retriever_organizer: DummyRetrieverOrganizer,
              retriever_params: {
                params: { very: :parameters },
                operation_id: 'operation_id',
                recipient: '13002526500013'
              },
              cache_key: '/show:very=parameters',
              expires_in: 1.hour
            })

          call!
        end
      end
    end
  end
end
