class GetOAuth2Token < AbstractGetToken
  protected

  def client_url
    fail NotImplementedError
  end

  def client_id
    nil
  end

  def client_secret
    nil
  end

  def scope
    nil
  end

  private

  def form_data
    {
      client_id:,
      client_secret:,
      grant_type: 'client_credentials',
      scope:
    }.compact
  end

  def access_token(response)
    JSON.parse(response.body)['access_token']
  end

  def expires_in(response)
    JSON.parse(response.body)['expires_in']
  end
end
