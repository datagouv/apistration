class FranceConnect::DataFetcherThroughAccessToken::MakeRequest < MakeRequest::Post
  def call
    super

    api_call_with_error_handling if call_france_connect_in_staging?
  end

  def mock_call
    context.mocked_data = MockService.new(operation_id, mocking_params).mock_from_backend
  end

  def mocking_params
    {
      token:
    }
  end

  def operation_id
    'france_connect'
  end

  def request_uri
    URI(france_connect_check_token_url)
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
  end

  def form_data
    {
      client_id:,
      client_secret:,
      token:
    }
  end

  private

  def token
    context.params[:token]
  end

  def call_france_connect_in_staging?
    Rails.env.staging? && context.mocked_data.nil?
  end

  def client_id
    Siade.credentials[:"france_connect_v2_#{api_name}_client_id"]
  end

  def client_secret
    Siade.credentials[:"france_connect_v2_#{api_name}_client_secret"]
  end

  def france_connect_check_token_url
    Siade.credentials[:france_connect_v2_check_token_url]
  end

  def api_name
    context.params[:api_name]
  end
end
