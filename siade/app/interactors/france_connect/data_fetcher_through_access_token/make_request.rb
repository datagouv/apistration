class FranceConnect::DataFetcherThroughAccessToken::MakeRequest < MakeRequest::Post
  def call
    super

    api_call_with_error_handling if call_france_connect_in_staging?
  end

  def mock_call
    context.mocked_data = MockService.new(operation_id, mocking_params).mock_from_backend
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

  def call_france_connect_in_staging?
    (Rails.env.staging? || Rails.env.development?) && context.mocked_data.nil?
  end

  def france_connect_check_token_url
    if Rails.env.production?
      Siade.credentials[:france_connect_production_check_token_url]
    else
      Siade.credentials[:france_connect_sandbox_check_token_url]
    end
  end
end
