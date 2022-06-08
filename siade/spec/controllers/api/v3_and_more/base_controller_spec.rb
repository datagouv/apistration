RSpec.describe API::V3AndMore::BaseController, type: :controller do
  before(:all) do
    # rubocop:disable Style/ClassAndModuleChildren
    module DummyResourceSerializer
      class V42 < V3AndMore::BaseSerializer; end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  end

  controller(described_class) do
    skip_after_action :verify_authorized

    def index
      render json: { data: true }, status: :ok
    end

    def serializer_module
      DummyResourceSerializer
    end
  end

  describe 'version management' do
    before do
      get :index, params: { api_version:, token: yes_jwt }.merge(**mandatory_params)
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
        .merge(**mandatory_params)
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
          expect(errors).to include(
            hash_including(
              code: '00210',
              title: 'Entité non traitable',
              detail: 'Le paramètre recipient n\'est pas un siret valide',
              source: {
                parameter: 'recipient'
              }
            )
          )
        end
      end
    end

    context 'with a recipient same as siret param' do
      let(:recipient) { valid_siret(:recipient) }
      let(:siret) { valid_siret(:recipient) }

      its(:status) { is_expected.to be(422) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors).to include(
            hash_including(
              code: '00211',
              title: 'Entité non traitable',
              detail: 'Le paramètre recipient est identique au siret de la demande',
              source: {
                parameter: 'recipient'
              }
            )
          )
        end
      end
    end
  end

  describe 'recipient param with a siren resource ID' do
    before do
      get :index, params: { api_version: 42, token: yes_jwt }
        .merge(**mandatory_params)
        .merge(recipient:, siren:)
    end

    context 'when identical' do
      let(:recipient) { valid_siret(:recipient) }
      let(:siren) { valid_siren(:recipient) }

      its(:status) { is_expected.to be(422) }

      it 'serializes an error' do
        expect(response_json).to have_key(:errors)
      end

      describe '#body' do
        let(:errors) { response_json[:errors] }

        it do
          expect(errors).to include(
            hash_including(
              code: '00211',
              title: 'Entité non traitable',
              detail: 'Le paramètre recipient est identique au siret de la demande',
              source: {
                parameter: 'recipient'
              }
            )
          )
        end
      end
    end
  end

  describe 'cache management' do
    class DummyRetrieverOrganizer < RetrieverOrganizer; end

    subject(:call!) do
      routes.draw { get 'show' => 'api/v3_and_more/base#show' }

      get :show, params: { api_version: 42, token: yes_jwt }.merge(**mandatory_params)
    end

    before do
      allow(DummyRetrieverOrganizer).to receive(:call)
    end

    context 'with single resources' do
      context 'when cache is activated' do
        controller(described_class) do
          skip_after_action :verify_authorized

          def show
            retrieve_single_resource(
              DummyRetrieverOrganizer,
              cache: true,
              cache_key: 'keykey',
              expires_in: 1.hour
            )
          end

          private

          def organizer_params
            {
              very: :parameters
            }
          end

          def serializer_module
            DummyResourceSerializer
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

          it 'calls the retriever directly with parameters' do
            expect(DummyRetrieverOrganizer)
              .to receive(:call)
              .with({ very: :parameters })

            call!
          end
        end

        context 'without the Cache-Control: no-cache request header' do
          it 'calls CacheResourceRetriever with parameters' do
            expect(CacheResourceRetriever)
              .to receive(:call)
              .with({
                retriever_organizer: DummyRetrieverOrganizer,
                retriever_params: { very: :parameters },
                cache_key: 'keykey',
                expires_in: 1.hour
              })

            call!
          end
        end
      end

      context 'when cache is deactivated' do
        controller(described_class) do
          skip_after_action :verify_authorized

          def show
            retrieve_single_resource(DummyRetrieverOrganizer, cache: false)
          end

          private

          def organizer_params
            {
              very: :parameters
            }
          end

          def serializer_module
            DummyResourceSerializer
          end
        end

        it 'does not call CacheResourceRetriever' do
          expect(CacheResourceRetriever).not_to receive(:call)

          call!
        end

        it 'calls the retriever directly with parameters' do
          expect(DummyRetrieverOrganizer)
            .to receive(:call)
            .with({ very: :parameters })

          call!
        end
      end
    end

    context 'with resources collections' do
      context 'when cache is activated' do
        controller(described_class) do
          skip_after_action :verify_authorized

          def show
            retrieve_resources_collection(
              DummyRetrieverOrganizer,
              cache: true,
              cache_key: 'keykey',
              expires_in: 1.hour
            )
          end

          private

          def organizer_params
            {
              very: :parameters
            }
          end

          def serializer_module
            DummyResourceSerializer
          end
        end

        context 'when Cache-Control: no-cache request header is present' do
          before do
            request.headers['Cache-Control'] = 'no-cache'
          end

          it 'does not call CacheResourceRetriever' do
            expect(CacheResourceCollectionRetriever).not_to receive(:call)

            call!
          end

          it 'calls the retriever directly with parameters' do
            expect(DummyRetrieverOrganizer)
              .to receive(:call)
              .with({ very: :parameters })

            call!
          end
        end

        context 'without the Cache-Control: no-cache request header' do
          it 'calls CacheResourceRetriever with parameters' do
            expect(CacheResourceCollectionRetriever)
              .to receive(:call)
              .with({
                retriever_organizer: DummyRetrieverOrganizer,
                retriever_params: { very: :parameters },
                cache_key: 'keykey',
                expires_in: 1.hour
              })

            call!
          end
        end
      end

      context 'when cache is deactivated' do
        controller(described_class) do
          skip_after_action :verify_authorized

          def show
            retrieve_resources_collection(DummyRetrieverOrganizer, cache: false)
          end

          private

          def organizer_params
            {
              very: :parameters
            }
          end

          def serializer_module
            DummyResourceSerializer
          end
        end

        it 'does not call CacheResourceRetriever' do
          expect(CacheResourceCollectionRetriever).not_to receive(:call)

          call!
        end

        it 'calls the retriever directly with parameters' do
          expect(DummyRetrieverOrganizer)
            .to receive(:call)
            .with({ very: :parameters })

          call!
        end
      end
    end
  end
end
