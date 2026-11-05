require 'rails_helper'

RSpec.describe APIController, 'expose provider response' do
  controller(described_class) do
    def show
      organizer

      render json: { data: { message: 'I like tea' }, meta: { existing_meta: true } },
        status: :ok
    end

    def errors
      organizer

      render json: { errors: [{ detail: 'I do not like tea' }] },
        status: :bad_gateway
    end

    def binary_body
      @organizer = Interactor::Context.build(
        response: OpenStruct.new(
          headers: { 'Content-Type' => 'application/pdf' },
          body: "%PDF-1.4\xC3\x28".dup.force_encoding(Encoding::ASCII_8BIT),
          status: 200
        )
      )

      render json: { data: { message: 'I like tea' } }, status: :ok
    end

    def operation_id
      'whatever'
    end

    def organizer
      @organizer ||= Interactor::Context.build(
        response: OpenStruct.new(
          headers: { 'Content-Type' => 'application/json' },
          body: { 'message' => 'I like providers\' tea' }.to_json,
          status: 418
        )
      )
    end
  end

  subject(:payload) do
    routes.draw { get 'show' => 'api#show' }

    request.headers[header_name] = header_value if header_value

    get :show, params: { token: }

    response.parsed_body
  end

  let(:header_name) { ProviderResponseDebuggingService::HEADER_NAME }
  let(:header_value) { 'true' }
  let(:token) { back_office_jwt }
  let(:expected_provider_response) do
    {
      'status' => 418,
      'headers' => { 'Content-Type' => 'application/json' },
      'body' => { 'message' => 'I like providers\' tea' }.to_json
    }
  end

  context 'when the IP-restricted back-office token sends the header' do
    it 'exposes the raw provider response in meta' do
      expect(payload['meta']['provider_response']).to eq(expected_provider_response)
    end

    it 'keeps the original payload' do
      expect(payload['data']).to eq({ 'message' => 'I like tea' })
      expect(payload['meta']['existing_meta']).to be(true)
    end
  end

  context 'when the header is not sent' do
    let(:header_value) { nil }

    it 'does not expose the raw provider response' do
      expect(payload['meta']).to eq({ 'existing_meta' => true })
    end
  end

  context 'when the token is not the back-office one' do
    let(:token) { yes_jwt }

    it 'does not expose the raw provider response' do
      expect(payload['meta']).to eq({ 'existing_meta' => true })
    end
  end

  context 'when the payload holds errors' do
    subject(:payload) do
      routes.draw { get 'errors' => 'api#errors' }

      request.headers[header_name] = header_value

      get :errors, params: { token: }

      response.parsed_body
    end

    it 'exposes the raw provider response at the root of the document' do
      expect(payload['meta']['provider_response']).to eq(expected_provider_response)
      expect(payload['errors']).to eq([{ 'detail' => 'I do not like tea' }])
    end
  end

  context 'when the provider body is not valid UTF-8' do
    subject(:payload) do
      routes.draw { get 'binary_body' => 'api#binary_body' }

      request.headers[header_name] = header_value

      get :binary_body, params: { token: }

      response.parsed_body
    end

    it 'renders the scrubbed provider body instead of failing' do
      expect(payload['meta']['provider_response']['body']).to start_with('%PDF-1.4')
      expect(response).to have_http_status(:ok)
    end
  end
end
