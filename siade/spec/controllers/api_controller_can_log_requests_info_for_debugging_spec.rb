require 'rails_helper'

# rubocop:disable RSpec/DescribeMethod
RSpec.describe APIController, 'log requests info for debugging' do
  # rubocop:enable RSpec/DescribeMethod
  controller(described_class) do
    def show
      render json: { message: 'I like tea' },
        status: 418
    end

    def operation_id
      params[:operation_id]
    end
  end

  subject do
    routes.draw { get 'show/:path_example_param' => 'api#show' }

    get :show, params: { token:, operation_id:, what: 'ever', path_example_param: 'drink' }
  end

  let(:token) { yes_jwt }

  context 'when operation id matches' do
    let(:operation_id) { 'api_teapot' }

    it 'logs request info, excluding token' do
      expect(RequestsDebuggerLogger.instance).to receive(:log).with(
        controller_name: 'api',
        path: '/show/drink',
        request_params: {
          'operation_id' => operation_id,
          'what' => 'ever',
          'path_example_param' => 'drink'
        },
        response_body: {
          'message' => 'I like tea'
        },
        response_status: 418
      )

      subject
    end
  end

  context 'when operation id does not match' do
    let(:operation_id) { 'api_coffee' }

    it 'does not log request info' do
      expect(RequestsDebuggerLogger.instance).not_to receive(:log)

      subject
    end
  end
end
