require 'rails_helper'

RSpec.describe APIController, 'log requests info for debugging' do
  # rubocop:enable RSpec/DescribeMethod
  controller(described_class) do
    def show
      render json: { message: 'I like tea' },
        status: 418
    end

    def operation_id
      'whatever'
    end

    def organizer
      @organizer ||= OpenStruct.new(
        response: OpenStruct.new(
          headers: { 'Content-Type' => 'application/json' },
          body: { 'message' => 'I like providers\' tea' }.to_json,
          status: 418
        )
      )
    end
  end

  subject do
    routes.draw { get 'show/:path_example_param' => 'api#show' }

    get :show, params: { token:, what: 'ever', path_example_param: 'drink' }
  end

  let(:requests_debugging_service) { instance_double(RequestsDebuggingService) }
  let(:token) { yes_jwt }

  before do
    allow(RequestsDebuggingService).to receive(:new).and_return(requests_debugging_service)
  end

  context 'when request debugging is enable' do
    before do
      allow(requests_debugging_service).to receive(:enable?).and_return(true)
    end

    it 'instanciates a RequestsDebuggingService with valid argument' do
      expect(RequestsDebuggingService).to receive(:new).with(
        'whatever',
        418
      )

      subject
    end

    it 'logs request info, excluding token' do
      expect(RequestsDebuggerLogger.instance).to receive(:log).with(
        controller_name: 'api',
        path: '/show/drink',
        request_params: {
          'what' => 'ever',
          'path_example_param' => 'drink'
        },
        provided_organizer_params: nil,
        provider: {
          header: { 'Content-Type' => 'application/json' },
          body: 'eyJtZXNzYWdlIjoiSSBsaWtlIHByb3ZpZGVycycgdGVhIn0=',
          status: 418
        },
        response_body: {
          'message' => 'I like tea'
        },
        response_status: 418
      )

      subject
    end
  end

  context 'when request debugging is disabled' do
    before do
      allow(requests_debugging_service).to receive(:enable?).and_return(false)
    end

    it 'does not log request info' do
      expect(RequestsDebuggerLogger.instance).not_to receive(:log)

      subject
    end
  end

  context 'when organizer params is defined' do
    controller(described_class) do
      def show
        render json: { message: 'I like tea' },
          status: 418
      end

      def operation_id
        'whatever'
      end

      def organizer_params
        { 'organizer' => 'params' }
      end

      def organizer
        @organizer ||= OpenStruct.new(
          response: OpenStruct.new(
            headers: { 'Content-Type' => 'application/json' },
            body: { 'message' => 'I like providers\' tea' }.to_json,
            status: 418
          )
        )
      end
    end

    before do
      allow(requests_debugging_service).to receive(:enable?).and_return(true)
    end

    it 'logs request info with organizer params' do
      expect(RequestsDebuggerLogger.instance).to receive(:log).with(
        hash_including(
          controller_name: 'api',
          path: '/show/drink',
          request_params: {
            'what' => 'ever',
            'path_example_param' => 'drink'
          },
          provided_organizer_params: { 'organizer' => 'params' },
          provider: {
            header: { 'Content-Type' => 'application/json' },
            body: 'eyJtZXNzYWdlIjoiSSBsaWtlIHByb3ZpZGVycycgdGVhIn0=',
            status: 418
          },
          response_body: {
            'message' => 'I like tea'
          },
          response_status: 418
        )
      )

      subject
    end
  end
end
