class RateLimitingService
  include Rails.application.routes.url_helpers

  def discriminate_by_jwt_for_endpoints(req, endpoints_list)
    jwt = extract_token_from_header(req)
    endpoint = extract_endpoint_from_path(req.path).slice(:controller, :action)

    Digest::SHA256.hexdigest(jwt) if jwt && endpoints_list.include?(endpoint)
  end

  def whitelisted_access?(req)
    jwt = extract_token_from_header(req)
    jwt.present? && whitelist.include?(jwt)
  end

  def blacklisted_access?(req)
    jwt = extract_token_from_header(req)
    jwt.present? && blacklist.include?(jwt)
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

  def extract_endpoint_from_path(path)
    Rails.application.routes.recognize_path(path)
  rescue ActionController::RoutingError
    {}
  end

  def extract_token_from_header(request)
    auth_header = request.get_header('HTTP_AUTHORIZATION')
    return unless auth_header

    matchs = auth_header.match(/\ABearer (.+)\z/)
    matchs[1] if matchs
  end

  def whitelist
    @whitelist ||= Rails.configuration.jwt_whitelist
  end

  def blacklist
    @blacklist ||= Rails.configuration.jwt_blacklist
  end
end
