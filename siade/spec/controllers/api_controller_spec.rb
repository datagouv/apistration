# frozen_string_literal: true

RSpec.describe APIController, type: :controller do
  controller(APIController) do
    skip_after_action :verify_authorized

    def index
      head :ok
    end

    def show
      render json: { siret: siret }, status: 200
    end

    protected

    def siret
      params.require(:siret)
    end
  end

  describe 'error json (with bad request error)' do
    subject do
      routes.draw { get 'show/:siret' => 'api#show' }

      get :show, params: { siret: ' ', error_format: error_format, token: yes_jwt }.merge(mandatory_params)
    end

    context 'when error_format is nil' do
      let(:error_format) { nil }

      before do
        ENV['JSON_API_FORMAT_ERROR'] = nil
      end

      after do
        expect(response.content_type).to start_with('application/json')
        ENV['JSON_API_FORMAT_ERROR'] = 'true'
      end

      it 'renders flatten errors' do
        subject

        json = JSON.parse(response.body)
        expect(json['errors']).to be_an(Array)
        expect(json['errors'].first).to be_a(String)
      end
    end

    context 'when error_format is flat' do
      let(:error_format) { 'flat' }

      before do
        ENV['JSON_API_FORMAT_ERROR'] = nil
      end

      after do
        ENV['JSON_API_FORMAT_ERROR'] = 'true'
      end

      it 'renders flatten errors' do
        subject

        json = JSON.parse(response.body)
        expect(json['errors']).to be_an(Array)
        expect(json['errors'].first).to be_a(String)
      end
    end

    context 'when error format is json_api' do
      let(:error_format) { 'json_api' }

      it 'renders json API errors' do
        subject

        json = JSON.parse(response.body)

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

    it 'renders a 400 error' do
      routes.draw { get 'show/:siret' => 'api#show' }

      get :show, params: { siret: siret }

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
end
