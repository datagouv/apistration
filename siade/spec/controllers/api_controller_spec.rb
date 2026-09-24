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

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'with an unkwown mime type' do
    let(:siret) { ' ' }

    it 'renders a 400 error' do
      routes.draw { get 'index' => 'api#index' }

      request.headers['Content-Type'] = 'var://service/original-content-type'

      get :index

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'malformatted requests' do
    it 'returns 401 stating the token is missing when no token is given' do
      get :index

      expect(response).to have_http_status(:unauthorized)
      expect(response_json).to have_json_error(code: '00101', detail: "Votre token n'est pas renseigné")
    end

    it 'returns 401 stating the token is invalid with bad header naming' do
      request.headers['Authorization'] = "FuBearer #{yes_jwt}"
      get :index

      expect(response).to have_http_status(:unauthorized)
      expect(response_json).to have_json_error(code: '00101', detail: "Votre token n'est pas valide")
    end

    it 'returns 401 stating the token is invalid when given as a param' do
      get :index, params: { token: 'bad_token' }

      expect(response).to have_http_status(:unauthorized)
      expect(response_json).to have_json_error(code: '00101', detail: "Votre token n'est pas valide")
    end

    it 'returns 401 stating the token is invalid when given through X-Api-key' do
      request.headers['X-Api-key'] = 'bad_token'
      get :index

      expect(response).to have_http_status(:unauthorized)
      expect(response_json).to have_json_error(code: '00101', detail: "Votre token n'est pas valide")
    end
  end

  describe 'token issued by another environment' do
    let(:payload) { TokenFactory.new(['whatever']).payload(uid: SecureRandom.uuid) }
    let(:token) { JWT.encode(payload, 'another environment secret', Siade.credentials[:jwt_hash_algo]) }

    before do
      request.host = 'entreprise.api.gouv.fr'
      request.headers['Authorization'] = "Bearer #{token}"
    end

    context 'when a production token is sent to staging' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
      end

      it 'returns 401 stating the token only works in production' do
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(response_json).to have_json_error(code: '00108', detail: ProductionTokenOnStagingError.new.detail)
        expect(response_json[:errors].first[:code]).to eq('00108')
      end

      it 'does not render the token payload' do
        get :index

        expect(response.body).not_to include(payload[:uid])
      end
    end

    context 'when a staging token is sent to production' do
      let(:payload) { super().merge(sub: 'staging', jti: JwtTokenService::STAGING_TOKEN_JTI) }

      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      it 'returns 401 stating the token only works on staging' do
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(response_json).to have_json_error(code: '00109', detail: StagingTokenOnProductionError.new('api_entreprise').detail)
        expect(response_json[:errors].first[:code]).to eq('00109')
      end
    end

    context 'when the environment does not tell anything about the token' do
      it 'returns 401 stating the token is invalid' do
        get :index

        expect(response_json).to have_json_error(code: '00101', detail: "Votre token n'est pas valide")
      end
    end
  end

  context 'with a jwt token' do
    context 'when jwt is passed in the header' do
      before { request.headers['Authorization'] = "Bearer #{token}" }

      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'returns 200' do
          get :index, params: api_entreprise_mandatory_params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with a jwt which has no valid uid for jti' do
        let(:token) { JwtHelper.jwt(:without_uuid_as_jti) }

        it 'returns 401' do
          get :index, params: api_entreprise_mandatory_params
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with a jwt which has no valid uid for uid' do
        let(:token) { JwtHelper.jwt(:without_uuid_as_uid) }

        it 'returns 401' do
          get :index, params: api_entreprise_mandatory_params
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with an expired jwt' do
        let(:token) { expired_jwt }

        it 'returns 401' do
          get :index
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with an expired jwt in request but valid in database' do
        let(:token) { TokenFactory.new(Scope.all).expired(uid: yes_jwt_id) }

        it 'returns 200' do
          get :index
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'returns 401' do
          get :index
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with an invalid jwt' do
        let(:token) { forged_jwt }

        it 'returns 401' do
          get :index
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with an incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'returns 401' do
          get :index
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when jwt is passed in the parameters' do
      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'returns 200' do
          get :index, params: { token: }.merge(api_entreprise_mandatory_params)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'returns 401' do
          get :index
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with an invalid jwt' do
        let(:token) { forged_jwt }

        it 'returns 401' do
          get :index
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with an incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'returns 401' do
          get :index
          expect(response).to have_http_status(:unauthorized)
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

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when previous call is the same' do
      let(:previous_params) { params }

      context 'when it is not the same jwt' do
        let(:previous_jwt) { TokenFactory.new.valid }

        it 'renders a 200' do
          double_call

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when it is the same jwt' do
        it 'renders a conflict' do
          double_call

          expect(response).to have_http_status(:conflict)
        end
      end
    end
  end
end
