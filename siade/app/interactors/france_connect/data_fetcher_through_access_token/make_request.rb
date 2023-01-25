class FranceConnect::DataFetcherThroughAccessToken::MakeRequest < MakeRequest::Post
  def mock_call
    context.mocked_data = MockService.new(operation_id, mocking_params).mock_from_backend

    return if context.mocked_data

    simulate_not_found_error
  end

  def operation_id
    'france_connect'
  end

  def request_uri
    URI(france_connect_check_token_url)
  end

  def request_params
    {
      token:
    }
  end

  private

  def token
    context.params[:token]
  end

  def simulate_not_found_error
    track_mock_operation
    context.errors << InvalidFranceConnectAccessTokenError.new(:not_found_or_expired)
    context.fail!
  end

  def france_connect_check_token_url
    if Rails.env.production?
      Siade.credentials[:france_connect_production_check_token_url]
    else
      Siade.credentials[:france_connect_sandbox_check_token_url]
    end
  end
end
