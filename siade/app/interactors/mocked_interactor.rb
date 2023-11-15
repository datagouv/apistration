class MockedInteractor < MakeRequest
  class EndpointNotYetImplemented < StandardError; end

  def call
    raise EndpointNotYetImplemented unless Rails.env.staging? || Rails.env.test?

    mocked_data = MockService.new(operation_id, mocking_params).mock
    context.status = mocked_data[:status]
    context.payload = mocked_data[:payload]
  end
end
