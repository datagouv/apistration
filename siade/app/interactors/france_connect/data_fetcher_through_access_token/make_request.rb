class FranceConnect::DataFetcherThroughAccessToken::MakeRequest < MakeRequest::Post
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

  def france_connect_check_token_url
    if Rails.env.production?
      Siade.credentials[:france_connect_production_check_token_url]
    else
      Siade.credentials[:france_connect_sandbox_check_token_url]
    end
  end
end
