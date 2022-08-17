class GetOAuth2Token < ApplicationInteractor
  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end
    end
  end

  def call
    context.token = token_from_redis || retrieve_and_save_token
  end

  protected

  def headers
    {}
  end

  def client_url
    fail NotImplementedError
  end

  def request_options
    {}
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

  def response_not_defined?
    context.token.nil?
  end

  def auth_uri
    URI(client_url)
  end

  def body_credentials
    {
      client_id:,
      client_secret:,
      scope:,
      grant_type: 'client_credentials'
    }.compact
  end

  def redis_token_key
    self
      .class
      .name
      .underscore
      .to_sym
  end

  def retrieve_and_save_token
    response_body = JSON.parse(http_response.body)

    redis.set(redis_token_key, response_body['access_token'], ex: response_body['expires_in'])

    token_from_redis
  end

  def http_response
    Net::HTTP.start(auth_uri.hostname, auth_uri.port, request_options.merge({ use_ssl: true })) do |http|
      http.request(request)
    end
  end

  def request
    request = Net::HTTP::Post.new(auth_uri)

    headers.each { |key, value| request[key.to_s] = value }

    request.set_form_data(grant_type: 'client_credentials')
    request.body = body_credentials.to_query

    request
  end

  def token_from_redis
    redis.get(redis_token_key)
  end

  def redis
    @redis ||= RedisService.instance
  end
end
