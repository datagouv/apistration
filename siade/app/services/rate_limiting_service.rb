class RateLimitingService
  include Rails.application.routes.url_helpers

  def discriminate_by_jwt_for_endpoints(req, endpoints_list)
    endpoint = extract_endpoint_from_url(req.url).slice(:controller, :action)

    return nil unless endpoints_list.include?(endpoint)

    user = resolved_user(req)

    if user
      Digest::SHA256.hexdigest(user.token_id)
    else
      token = extract_token_from_request(req)
      Digest::SHA256.hexdigest(token) if token.present?
    end
  end

  def whitelisted_access?(req)
    whitelist.include?(
      extract_token_from_request(req)
    )
  end

  def blacklisted_access?(req)
    user = resolved_user(req)

    user.present? && user.blacklisted?
  end

  def ip_forbidden_access?(req)
    user = resolved_user(req)

    return false if user.blank?
    return false if user.allowed_ips.blank?

    !user.ip_allowed?(req.ip)
  end

  def custom_rate_limit_for(req)
    resolved_user(req)&.rate_limit_per_minute
  end

  def custom_rate_limit?(req)
    custom_rate_limit_for(req).present?
  end

  def build_rate_limit_headers(data)
    {
      'RateLimit-Limit' => data[:limit].to_s,
      'RateLimit-Remaining' => compute_remaining(data),
      'RateLimit-Reset' => compute_reset(data)
    }
  end

  def extract_token_from_request(request)
    extract_token_from_header(request) ||
      extract_token_from_query_params(request)
  end

  private

  def resolved_user(req)
    req.env[UserResolutionMiddleware::USER_ENV_KEY]
  end

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

  def whitelist
    @whitelist ||= Rails.configuration.jwt_whitelist
  end
end
