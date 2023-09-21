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
  end

  describe 'error json (with bad request error)' do
    subject do
      routes.draw { get 'show/:siret' => 'api#show' }

      get :show, params: { siret: ' ', error_format:, token: yes_jwt }.merge(mandatory_params)
    end

    context 'when error_format is nil' do
      let(:error_format) { nil }

      after do
        expect(response.content_type).to start_with('application/json')
      end

      it 'renders flatten errors' do
        subject

        json = response.parsed_body
        expect(json['errors']).to be_an(Array)
        expect(json['errors'].first).to be_a(String)
      end
    end

    context 'when error_format is flat' do
      let(:error_format) { 'flat' }

      it 'renders flatten errors' do
        subject

        json = response.parsed_body
        expect(json['errors']).to be_an(Array)
        expect(json['errors'].first).to be_a(String)
      end
    end

    context 'when error format is json_api' do
      let(:error_format) { 'json_api' }

      it 'renders json API errors' do
        subject

        json = response.parsed_body

        expect(json['errors']).to be_an(Array)
        expect(json['errors'].first).to be_a(Hash)

        %w[
          code
          title
          detail
        ].each do |key|
          expect(json['errors'].first[key]).to be_present
        end
      end
    end
  end

  describe 'with a required blank parameter' do
    let(:siret) { ' ' }

    before { request.headers['Authorization'] = "Bearer #{yes_jwt}" }

    it 'renders a 400 error' do
      routes.draw { get 'show/:siret' => 'api#show' }

      get :show, params: { siret: }

      assert_response 400
    end
  end

  describe 'with an unkwown mime type' do
    let(:siret) { ' ' }

    it 'renders a 400 error' do
      routes.draw { get 'index' => 'api#index' }

      request.headers['Content-Type'] = 'var://service/original-content-type'

      get :index

      assert_response 400
    end
  end

  describe 'malformatted requests' do
    it 'returns 401 when token is missing' do
      get :index
      assert_response 401
    end

    it 'returns 401 with bad header naming' do
      request.headers['Authorization'] = "FuBearer #{yes_jwt}"
      get :index
      assert_response 401
    end
  end

  context 'with a jwt token' do
    context 'when jwt is passed in the header' do
      before { request.headers['Authorization'] = "Bearer #{token}" }

      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'returns 200' do
          get :index, params: mandatory_params
          assert_response 200
        end
      end

      context 'with a jwt which has no valid uid for jti' do
        let(:token) { JwtHelper.jwt(:without_uuid_as_jti) }

        it 'returns 401' do
          get :index, params: mandatory_params
          assert_response 401
        end
      end

      context 'with a jwt which has no valid uid for uid' do
        let(:token) { JwtHelper.jwt(:without_uuid_as_uid) }

        it 'returns 401' do
          get :index, params: mandatory_params
          assert_response 401
        end
      end

      context 'with an expired jwt' do
        let(:token) { expired_jwt }

        it 'returns 401' do
          get :index
          assert_response 401
        end
      end

      context 'with an expired jwt in request but valid in database' do
        let(:token) { TokenFactory.new(Scope.all).expired(uid: yes_jwt_id) }

        it 'returns 200' do
          get :index
          assert_response 200
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'returns 401' do
          get :index
          assert_response 401
        end
      end

      context 'with an invalid jwt' do
        let(:token) { forged_jwt }

        it 'returns 401' do
          get :index
          assert_response 401
        end
      end

      context 'with an incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'returns 401' do
          get :index
          assert_response 401
        end
      end
    end

    context 'when jwt is passed in the parameters' do
      context 'with a valid jwt' do
        let(:token) { yes_jwt }

        it 'returns 200' do
          get :index, params: { token: }.merge(mandatory_params)
          assert_response 200
        end
      end

      context 'with an unsigned jwt' do
        let(:token) { unsigned_jwt }

        it 'returns 401' do
          get :index
          assert_response 401
        end
      end

      context 'with an invalid jwt' do
        let(:token) { forged_jwt }

        it 'returns 401' do
          get :index
          assert_response 401
        end
      end

      context 'with an incorrect jwt' do
        let(:token) { corrupted_jwt }

        it 'returns 401' do
          get :index
          assert_response 401
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
        mandatory_params.merge(
          controller: 'api',
          action: 'index',
          token: an_instance_of(String)
        )
      )

      get :index, params: { token: yes_jwt }.merge(mandatory_params)
    end
  end
end
