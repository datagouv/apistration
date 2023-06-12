class MockedInteractor < MakeRequest
  def call
    mocked_data = MockService.new(operation_id, mocking_params).mock
    context.status = mocked_data[:status]
    context.payload = mocked_data[:payload]
  end
end
