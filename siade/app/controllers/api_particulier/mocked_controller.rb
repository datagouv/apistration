class APIParticulier::MockedController < APIParticulierController
  def show
    return render not_implemented_error unless Rails.env.staging? || Rails.env.test?

    mocked_data = MockService.new(operation_id, mocking_params).mock
    render json: mocked_data[:payload], status: mocked_data[:status]
  end

  protected

  def not_implemented_error
    error_json(NotImplementedYetError.new, status: :not_implemented)
  end

  def mocking_params
    raise NotImplementedError
  end

  def operation_id
    raise NotImplementedError
  end
end
