class RateLimitingService
  include Rails.application.routes.url_helpers

  DISCRIMINATOR_ENV_KEY = 'siade.rate_limiting.authorization_request_discriminator'.freeze

  def discriminate_by_authorization_request_for_endpoints(req, endpoints_list)
    endpoint = extract_endpoint_from_url(req.url).slice(:controller, :action)

    return nil unless endpoints_list.include?(endpoint)

    authorization_request_discriminator(req)
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

  def authorization_request_discriminator(req)
    return req.env[DISCRIMINATOR_ENV_KEY] if req.env.key?(DISCRIMINATOR_ENV_KEY)

    req.env[DISCRIMINATOR_ENV_KEY] = compute_authorization_request_discriminator(req)
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

  def compute_authorization_request_discriminator(req)
    user = resolved_user(req)

    if user
      user.authorization_request_id || fallback_discriminator(user)
    else
      opaque_token_discriminator(req)
    end
  end

  def fallback_discriminator(user)
    if user.editor?
      "editor:#{user.editor_id}"
    else
      "token:#{user.token_id}"
    end
  end

  def opaque_token_discriminator(req)
    token = extract_token_from_request(req)
    Digest::SHA256.hexdigest(token) if token.present?
  end

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
