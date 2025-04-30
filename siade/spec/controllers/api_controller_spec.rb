# frozen_string_literal: true

RSpec.describe APIController do
  controller(described_class) do
    def index
      head :ok
    end

    def show
      render json: { siret: }, status: :ok
    end

    protected

    def content_type_header
      'application/csv'
    end

    def siret
      params.require(:siret)
    end

    private

    def clean_duplicate_param_tracking
      Rails.logger.info 'Overridden clean_duplicate_param_tracking called'
    end
  end

  describe 'error format (with bad request error)' do
    subject do
      routes.draw { get 'show/:siret' => 'api#show' }

      get :show, params: { siret: ' ', token: yes_jwt }.merge(api_entreprise_mandatory_params)
    end

    it 'renders json_api format errors' do
      subject

      expect(response_json).to have_json_api_format_errors
    end
  end

  describe 'with a required blank parameter' do
    let(:siret) { ' ' }

    before { request.headers['Authorization'] = "Bearer #{yes_jwt}" }

    it 'renders a 400 error' do
      routes.draw { get 'show/:siret' => 'api#show' }

      get :show, params: { siret: }

      assert_response :bad_request
    end
  end

  describe 'with an unkwown mime type' do
    let(:siret) { ' ' }

    it 'renders a 400 error' do
      routes.draw { get 'index' => 'api#index' }

      request.headers['Content-Type'] = 'var://service/original-content-type'

      get :index

      assert_response :bad_request
    end
  end

  describe 'malformatted requests' do
    it 'returns 401 when token is missing' do
      get :index
      assert_response :unauthorized
    end

    it 'returns 401 with bad header naming' do
      request.headers['Authorization'] = "FuBearer #{yes_jwt}"
      get :index
      assert_response :unauthorized
    end
  end

  context 'with a jwt token' do
    context 'when jwt is passed in the header' do
      before { request.headers['Authorization'] = "Bearer #{token}" }

      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'returns 200' do
          get :index, params: api_entreprise_mandatory_params
          assert_response :ok
        end
      end

      context 'with a jwt which has no valid uid for jti' do
        let(:token) { JwtHelper.jwt(:without_uuid_as_jti) }

        it 'returns 401' do
          get :index, params: api_entreprise_mandatory_params
          assert_response :unauthorized
        end
      end

      context 'with a jwt which has no valid uid for uid' do
        let(:token) { JwtHelper.jwt(:without_uuid_as_uid) }

        it 'returns 401' do
          get :index, params: api_entreprise_mandatory_params
          assert_response :unauthorized
        end
      end

      context 'with an expired jwt' do
        let(:token) { expired_jwt }

        it 'returns 401' do
          get :index
          assert_response :unauthorized
        end
      end

      context 'with an expired jwt in request but valid in database' do
        let(:token) { TokenFactory.new(Scope.all).expired(uid: yes_jwt_id) }

        it 'returns 200' do
          get :index
          assert_response :ok
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'returns 401' do
          get :index
          assert_response :unauthorized
        end
      end

      context 'with an invalid jwt' do
        let(:token) { forged_jwt }

        it 'returns 401' do
          get :index
          assert_response :unauthorized
        end
      end

      context 'with an incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'returns 401' do
          get :index
          assert_response :unauthorized
        end
      end
    end

    context 'when jwt is passed in the parameters' do
      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'returns 200' do
          get :index, params: { token: }.merge(api_entreprise_mandatory_params)
          assert_response :ok
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'returns 401' do
          get :index
          assert_response :unauthorized
        end
      end

      context 'with an invalid jwt' do
        let(:token) { forged_jwt }

        it 'returns 401' do
          get :index
          assert_response :unauthorized
        end
      end

      context 'with an incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'returns 401' do
          get :index
          assert_response :unauthorized
        end
      end
    end
  end

  describe 'monitoring service context setup' do
    let(:uuid_regex) { /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/ }
    let(:date_regex) { /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}[+-]\d{2}:\d{2}/ }

    it 'sets user context with user' do
      expect(MonitoringService.instance).to receive(:set_user_context).with(
        hash_including(
          id: a_string_matching(uuid_regex),
          scopes: an_instance_of(Array),
          jti: a_string_matching(uuid_regex),
          iat: a_string_matching(date_regex),
          exp: an_instance_of(Integer)
        )
      )

      get :index, params: { token: yes_jwt }
    end

    it 'sets expected params in context' do
      expect(MonitoringService.instance).to receive(:set_controller_params).with(
        api_entreprise_mandatory_params.merge(
          controller: 'api',
          action: 'index',
          token: an_instance_of(String)
        )
      )

      get :index, params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)
    end
  end

  describe 'multiple calls with same parameters' do
    subject(:double_call) do
      request.headers['Authorization'] = "Bearer #{previous_jwt}"
      get :index, params: previous_params

      request.headers['Authorization'] = "Bearer #{yes_jwt}"
      get :index, params:
    end

    before do
      routes.draw { get 'index' => 'api#index' }
    end

    let(:params) { { 'what' => 'ever' } }
    let(:previous_jwt) { yes_jwt }

    context 'when previous call is different' do
      let(:previous_params) { { 'what' => 'is love' } }

      it 'renders a 200' do
        double_call

        assert_response :ok
      end
    end

    context 'when previous call is the same' do
      let(:previous_params) { params }

      context 'when it is not the same jwt' do
        let(:previous_jwt) { TokenFactory.new.valid }

        it 'renders a 200' do
          double_call

          assert_response :ok
        end
      end

      context 'when it is the same jwt' do
        it 'renders a conflict' do
          double_call

          assert_response :conflict
        end
      end
    end
  end
end
