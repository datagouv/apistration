class MockedInteractor < MakeRequest
  class EndpointNotYetImplemented < StandardError; end

  # rubocop:disable Metrics/AbcSize
  def call
    raise EndpointNotYetImplemented unless Rails.env.staging? || Rails.env.test?

    context.mocked_data = MockService.new(operation_id, mocking_params).mock
    context.status = context.mocked_data[:status]
    context.payload = context.mocked_data[:payload]

    track_mock_operation
  end
  # rubocop:enable Metrics/AbcSize
end
