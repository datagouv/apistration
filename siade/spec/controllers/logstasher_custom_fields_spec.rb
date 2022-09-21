class APIParticulier::V2::DummyController < APIParticulierController; end
class APIEntreprise::V2::DummyController < APIController; end
class APIEntreprise::V3AndMore::DummyController < APIController; end

# rubocop:disable Lint/NestedMethodDefinition
def define_dummy_controller(controller_klass)
  controller(controller_klass) do
    def index
      head :ok
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition

RSpec.describe 'logstasher custom fields', type: :controller do
  subject(:make_call) do
    get :index
  end

  before do
    allow(LogStasher).to receive(:build_logstash_event)
  end

  define_dummy_controller(APIController)

  describe 'basic controller' do
    before do
      routes.draw { get 'index' => 'api#index' }
    end

    it 'adds basic custom fields to logstasher' do
      expect(LogStasher).to receive(:build_logstash_event).with(
        hash_including(
          type: 'siade',
          domain: 'test.host',
          user_agent_raw: 'Rails Testing'
        ),
        anything
      )

      make_call
    end

    it 'does not add api_version to logstasher' do
      expect(LogStasher).not_to receive(:build_logstash_event).with(
        hash_including(
          api_version: anything
        ),
        anything
      )

      make_call
    end
  end

  describe 'on api particulier request' do
    before do
      routes.draw { get 'index' => 'api/v2/dummy#index' }
    end

    define_dummy_controller(APIParticulier::V2::DummyController)

    it 'adds api: particulier to logstasher' do
      expect(LogStasher).to receive(:build_logstash_event).with(
        hash_including(
          api: 'particulier'
        ),
        anything
      )

      make_call
    end

    it 'adds api_version v2 to logstasher' do
      expect(LogStasher).to receive(:build_logstash_event).with(
        hash_including(
          api_version: 'v2'
        ),
        anything
      )

      make_call
    end
  end

  describe 'on api entreprise request' do
    context 'when it is a v2' do
      let(:api_controller_name) { 'api/v2/dummy' }

      before do
        routes.draw { get 'index' => 'api/v2/dummy#index' }
      end

      define_dummy_controller(APIEntreprise::V2::DummyController)

      it 'adds api: entreprise to logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            api: 'entreprise'
          ),
          anything
        )

        make_call
      end

      it 'adds retrieved_cached to logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            retriever_cached: false
          ),
          anything
        )

        make_call
      end

      it 'adds api_version v2 to logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            api_version: 'v2'
          ),
          anything
        )

        make_call
      end
    end

    context 'when it is a v3 and more' do
      let(:api_controller_name) { 'api/v3_and_more/dummy' }

      before do
        routes.draw { get 'index' => 'api/v3_and_more/dummy#index' }
      end

      define_dummy_controller(APIEntreprise::V3AndMore::DummyController)

      it 'adds api: entreprise to logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            api: 'entreprise'
          ),
          anything
        )

        make_call
      end

      it 'adds api_version v3_and_more to logstasher' do
        expect(LogStasher).to receive(:build_logstash_event).with(
          hash_including(
            retriever_cached: false,
            api_version: 'v3_and_more'
          ),
          anything
        )

        make_call
      end
    end
  end

  describe 'with jwt token, on an authenticate controller' do
    subject(:make_call) do
      request.headers['Authorization'] = "Bearer #{yes_jwt}"

      get :index, params: { context: 'context', recipient: valid_siret(:recipient), object: 'object' }
    end

    before do
      routes.draw { get 'index' => 'api_entreprise#index' }
    end

    controller(APIEntrepriseController) do
      def index
        authorize :entreprises

        head :ok
      end
    end

    it 'adds jwt info logstasher' do
      expect(LogStasher).to receive(:build_logstash_event).with(
        hash_including(
          'user_access' => hash_including(
            user: yes_jwt_user.logstash_id,
            jti: yes_jwt_user.token_id,
            iat: yes_jwt_user.iat
          )
        ),
        anything
      )

      make_call
    end
  end
end
