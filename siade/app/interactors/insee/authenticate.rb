class INSEE::Authenticate < ApplicationInteractor
  def call
    context.token = token_from_redis || retrieve_and_save_token_from_insee
  end

  private

  def token_from_redis
    redis.get(redis_token_key)
  end

  def retrieve_and_save_token_from_insee
    response_body = JSON.parse(insee_http_response.body)

    redis.set(redis_token_key, response_body['access_token'], ex: response_body['expires_in'])

    token_from_redis
  end

  def insee_http_response
    Net::HTTP.start(uri.hostname, uri.port, request_options) do |http|
      http.request(request)
    end
  end

  def request_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER
    }
  end

  def request
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Basic #{insee_credentials}"
    request.set_form_data(grant_type: 'client_credentials')
    request
  end

  def uri
    URI([insee_uri, 'token'].join('/'))
  end

  def redis_token_key
    'insee_token'
  end

  def insee_credentials
    Siade.credentials[:insee_credentials]
  end

  def insee_uri
    Siade.credentials[:insee_v3_domain]
  end

  def redis
    @redis ||= Redis.current
  end
end
