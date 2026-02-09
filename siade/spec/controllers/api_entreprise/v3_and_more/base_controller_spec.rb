RSpec.describe APIEntreprise::V3AndMore::BaseController do
  before(:all) do
    # rubocop:disable Style/ClassAndModuleChildren
    module APIEntreprise::DummyResourceSerializer
      class V42 < APIEntreprise::V3AndMore::BaseSerializer; end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  end

  controller(described_class) do
    def index
      render json: { data: true }, status: :ok
    end

    def serializer_module
      APIEntreprise::DummyResourceSerializer
    end

    def api_kind
      'api_entreprise'
    end
  end

  describe 'version management' do
    before do
      get :index, params: { api_version:, token: yes_jwt }.merge(**api_entreprise_mandatory_params)
    end

    context 'with valid version' do
      let(:api_version) { 42 }

      its(:status) { is_expected.to be(200) }

      it 'does not serialize an error' do
        expect(response_json).not_to have_key(:errors)
      end
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
                      .merge(**api_entreprise_mandatory_params)
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

    context 'with a recipient same as siret param' do
      let(:recipient) { valid_siret(:recipient) }
      let(:siret) { valid_siret(:recipient) }

      its(:status) { is_expected.to be(200) }
    end
  end

  describe 'recipient param with a siren resource ID' do
    before do
      get :index, params: { api_version: 42, token: yes_jwt }
                      .merge(**api_entreprise_mandatory_params)
                      .merge(recipient:, siren:)
    end

    context 'when identical' do
      let(:recipient) { valid_siret(:recipient) }
      let(:siren) { valid_siren(:recipient) }

      its(:status) { is_expected.to be(200) }
    end
  end

  describe 'cache management' do
    class DummyRetrieverOrganizer < RetrieverOrganizer; end

    subject(:call!) do
      routes.draw { get 'show' => 'api_entreprise/v3_and_more/base#show' }

      get :show, params: { api_version: 42, token: yes_jwt }.merge(**api_entreprise_mandatory_params)
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
          APIEntreprise::DummyResourceSerializer
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
          APIEntreprise::DummyResourceSerializer
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

  describe 'maintenance' do
    class DummyMaintenanceRetrieverOrganizer < RetrieverOrganizer
      def call
        context.bundled_data = BundledData.new(data: Resource.new(data: { dummy: 'data' }), context: {})

        super
      end

      def provider_name
        'dummy_maintenance'
      end
    end

    controller(described_class) do
      def show
        if organizer.success?
          render json: serialize_data,
            status: extract_http_code(organizer)
        else
          render_errors
        end
      end

      def serializer_module
        APIEntreprise::DummyResourceSerializer
      end

      def organizer
        @organizer = DummyMaintenanceRetrieverOrganizer.call
      end
    end

    subject(:call!) do
      routes.draw { get 'show' => 'api_entreprise/v3_and_more/base#show' }

      get :show, params: { api_version: 42, token: yes_jwt }.merge(**api_entreprise_mandatory_params)
    end

    before do
      allow(ErrorsBackend.instance).to receive(:provider_code_from_name).and_return('dummy_maintenance')

      Timecop.freeze(time)
    end

    after do
      Timecop.return
    end

    context 'when maintenance is activated' do
      let(:time) { Time.zone.local(2021, 1, 1, 1, 1, 0) }

      it 'renders 503 code' do
        call!

        expect(response).to have_http_status(:service_unavailable)
      end
    end

    context 'when maintenance is not activated' do
      let(:time) { Time.zone.local(2021, 1, 1, 2, 1, 0) }

      it 'renders 200 code' do
        call!

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
