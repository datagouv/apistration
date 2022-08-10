class FranceConnectDataFetcherThroughAccessToken::MakeRequest < MakeRequest::Post
  def request_uri
    URI(Siade.credentials[:france_connect_check_token_url])
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
end
