RSpec.describe InterceptWithOpenAPIMockedPayloadInStaging do
  controller(APIEntrepriseController) do
    include InterceptWithOpenAPIMockedPayloadInStaging

    def operation_id
      'dummy_name'
    end

    def index
      render json: { dummy: 'response' }, status: :ok
    end
  end

  before do
    routes.draw { get 'index', to: 'api_entreprise#index' }
  end

  context 'when requesting any env but staging' do
    it 'renders default paylad' do
      get :index, params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)
      expect(response_json).to eq({ dummy: 'response' })
    end
  end

  context 'when requesting on staging env' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)

      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(described_class)
        .to receive(:open_api_schema)
        .and_return(schema.deep_stringify_keys)
      # rubocop:enable RSpec/AnyInstance
    end

    let(:example_value) { 'the expected example value' }

    let(:schema) do
      {
        paths: {
          '/any/path/will/work': {
            get: {
              responses: {
                '200': {
                  'x-operationId': operation_id,
                  content: {
                    'application/json': {
                      schema: {
                        type: 'object',
                        properties: {
                          dummy: {
                            type:,
                            example: example_value
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    end

    context 'with valid schema' do
      let(:type) { 'string' }
      let(:operation_id) { 'dummy_name' }

      it 'renders an example instead of normal payload' do
        get :index, params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)
        expect(response_json).to eq({ dummy: example_value })
      end
    end

    context 'with invalid schema' do
      let(:type) { 'unknown' }
      let(:operation_id) { 'dummy_name' }

      it 'renders an error' do
        get :index, params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)

        assert_response :internal_server_error
        expect(response_json).to have_json_error(detail: "Une erreur dans la configuration de notre environnement de staging ne permet pas la génération de l'exemple de test. Une alerte a été remontée.")
      end

      it 'tracks OpenAPI error in monitoring service' do
        allow(MonitoringService.instance).to receive(:capture_message)
        get :index, params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)

        expect(MonitoringService.instance)
          .to have_received(:capture_message)
          .with('Unknown type: {"type" => "unknown", "example" => "the expected example value"}', level: 'warning')
      end
    end

    context 'when operationId is not found in OpenAPI file' do
      let(:type) { 'string' }
      let(:operation_id) { 'wrong_id' }

      it 'renders an error' do
        get :index, params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)

        assert_response :internal_server_error
        expect(response_json).to have_json_error(detail: "Une erreur dans la configuration de notre environnement de staging ne permet pas la génération de l'exemple de test. Une alerte a été remontée.")
      end

      it 'tracks OpenAPI error in monitoring service' do
        allow(MonitoringService.instance).to receive(:capture_message)
        get :index, params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)

        expect(MonitoringService.instance)
          .to have_received(:capture_message)
          .with('operationId not found: dummy_name', level: 'warning')
      end
    end
  end
end
