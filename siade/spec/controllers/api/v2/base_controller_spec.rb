RSpec.describe API::V2::BaseController, type: :controller do
  controller described_class do
    skip_after_action :verify_authorized

    def controller_name
      'dummy_name'
    end

    def index
      render json: { dummy: 'response' }, status: :ok
    end
  end

  before do
    routes.draw { get 'index', to: 'api/v2/base#index' }
  end

  context 'when requesting any env but staging' do
    it 'renders default paylad' do
      get :index, params: { token: yes_jwt }.merge(mandatory_params)

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
              controller_action: 'dummy_name_index',
              responses: {
                '200': {
                  content: {
                    'application/json': {
                      schema: {
                        type: 'object',
                        properties: {
                          dummy: {
                            type: 'string',
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

    it 'renders an example instead of normal payload' do
      get :index, params: { token: yes_jwt }.merge(mandatory_params)

      expect(response_json).to eq({ dummy: example_value })
    end
  end
end
