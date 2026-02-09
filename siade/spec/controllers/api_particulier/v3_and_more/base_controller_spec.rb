RSpec.describe APIParticulier::V3AndMore::BaseController do
  before(:all) do
    # rubocop:disable Style/ClassAndModuleChildren
    module APIParticulier::DummyResourceSerializer
      class V42 < APIParticulier::V3AndMore::BaseSerializer; end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  end

  controller(described_class) do
    def index
      render json: { data: true }, status: :ok
    end

    def serializer_module
      APIParticulier::DummyResourceSerializer
    end

    def api_kind
      'api_particulier'
    end
  end

  describe 'error format (with missing recipient error)' do
    before do
      get :index, params: { api_version: 42, token: yes_jwt }
                      .merge(**api_particulier_mandatory_params)
                      .merge(recipient: 'wrong')
    end

    it 'renders json_api format errors' do
      subject

      expect(response_json).to have_json_api_format_errors
    end
  end

  describe 'version management' do
    before do
      get :index, params: { api_version:, token: yes_jwt }.merge(**api_particulier_mandatory_params)
    end

    context 'with a valid version' do
      let(:api_version) { 42 }

      its(:status) { is_expected.to be(200) }
    end

    context 'with invalid version' do
      let(:api_version) { 4 }

      its(:status) { is_expected.to be(404) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors).to include(
            hash_including(
              code: '00402',
              title: 'Version d\'API non prise en charge',
              detail: 'La version v4 n\'est pas supportée pour cet endpoint'
            )
          )
        end
      end
    end
  end

  describe 'recipient param' do
    let(:siret) { valid_siret }

    before do
      get :index, params: { api_version: 42, token: yes_jwt }
                      .merge(**api_particulier_mandatory_params)
                      .merge(recipient:, siret:)
    end

    context 'with valid siret as recipient' do
      let(:recipient) { valid_siret(:recipient) }

      its(:status) { is_expected.to be(200) }
    end

    context 'with invalid value as recipient' do
      let(:recipient) { 'invalid' }

      its(:status) { is_expected.to be(422) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors.pluck(:code)).to include('00210')
        end
      end
    end
  end

  describe 'cache management' do
    class DummyRetrieverOrganizer < RetrieverOrganizer; end

    subject(:call!) do
      routes.draw { get 'show' => 'api_particulier/v3_and_more/base#show' }

      get :show, params: { api_version: 42, token: yes_jwt }.merge(**api_particulier_mandatory_params)
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

        def cache_key
          'keykey'
        end

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
              cache_key: 'keykey',
              expires_in: 1.hour
            })

          call!
        end
      end
    end

    context 'when cache is deactivated' do
      controller(described_class) do
        def show
          retrieve_payload_data(DummyRetrieverOrganizer, cache: false)
        end

        private

        def organizer_params
          {
            very: :parameters
          }
        end

        def serializer_module
          APIParticulier::DummyResourceSerializer
        end
      end

      it 'renders X-Response-cached header as false, and an empty X-Cache-Expires-in' do
        call!

        expect(response.headers['X-Response-Cached']).to be(false)
        expect(response.headers['X-Cache-Expires-in']).to eq('')
      end

      it 'does not call CacheResourceRetriever' do
        expect(CacheResourceRetriever).not_to receive(:call)

        call!
      end

      it 'calls the retriever directly with parameters' do
        expect(DummyRetrieverOrganizer)
          .to receive(:call)
          .with(
            hash_including(
              params: { very: :parameters }
            )
          )

        call!
      end
    end
  end
end
