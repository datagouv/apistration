class RateLimitingService
  include Rails.application.routes.url_helpers

  def discriminate_by_jwt_for_endpoints(req, endpoints_list)
    jwt = extract_token_from_request(req)
    endpoint = extract_endpoint_from_url(req.url).slice(:controller, :action)

    Digest::SHA256.hexdigest(jwt) if jwt && endpoints_list.include?(endpoint)
  end

  def whitelisted_access?(req)
    jwt = extract_token_from_request(req)
    jwt.present? && whitelist.include?(jwt)
  end

  def blacklisted_access?(req)
    jwt = extract_token_from_request(req)

    jwt.present? && (
      blacklist.include?(jwt) ||
      token_blacklisted_from_database?(jwt)
    )
  end

  def build_rate_limit_headers(data)
    {
      'RateLimit-Limit' => data[:limit].to_s,
      'RateLimit-Remaining' => compute_remaining(data),
      'RateLimit-Reset' => compute_reset(data)
    }
  end

  private

  def compute_reset(data)
    now = data[:epoch_time]

    (now + (data[:period] - (now % data[:period]))).to_s
  end

  def compute_remaining(data)
    remaining = data[:limit] - data[:count]

    [remaining, 0].max.to_s
  end

  def extract_endpoint_from_url(url)
    Rails.application.routes.recognize_path(url)
  rescue ActionController::RoutingError
    {}
  end

  def extract_token_from_request(request)
    extract_token_from_header(request) ||
      extract_token_from_query_params(request)
  end

  def extract_token_from_header(request)
    auth_header = request.get_header('HTTP_AUTHORIZATION')

    if auth_header
      matchs = auth_header.match(/\ABearer (.+)\z/)
      matchs[1] if matchs
    else
      request.get_header('HTTP_X_API_KEY')
    end
  end

  def extract_token_from_query_params(request)
    request.params.fetch('token', nil)
  end

  def token_blacklisted_from_database?(jwt)
    user = user_from_jwt(jwt)

    user.present? &&
      user.blacklisted?
  end

  def user_from_jwt(jwt)
    JwtTokenService.new(jwt).extract_user
  end

  def whitelist
    @whitelist ||= Rails.configuration.jwt_whitelist
  end

  def blacklist
    @blacklist ||= Rails.configuration.jwt_blacklist
  end
end
