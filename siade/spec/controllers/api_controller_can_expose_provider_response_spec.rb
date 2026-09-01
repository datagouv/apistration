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

    def operation_id
      'whatever'
    end

    def organizer
      @organizer ||= OpenStruct.new(
        context: OpenStruct.new(
          response: OpenStruct.new(
            headers: { 'Content-Type' => 'application/json' },
            body: { 'message' => 'I like providers\' tea' }.to_json,
            status: 418
          )
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
  let(:token) { yes_jwt }
  let(:whitelisted_token_ids) { [JwtUser.debugger_id] }
  let(:expected_provider_response) do
    {
      'status' => 418,
      'headers' => { 'Content-Type' => 'application/json' },
      'body_base64' => Base64.strict_encode64({ 'message' => 'I like providers\' tea' }.to_json)
    }
  end

  before do
    Siade.credentials[ProviderResponseDebuggingService::CREDENTIALS_KEY] = whitelisted_token_ids
  end

  after do
    Siade.credentials.delete(ProviderResponseDebuggingService::CREDENTIALS_KEY)
  end

  context 'when the token is whitelisted and the header is sent' do
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

  context 'when the token is not whitelisted' do
    let(:whitelisted_token_ids) { ['f5d5cb02-185a-426f-b3f4-99a25ce6cdf4'] }

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
end
