class RateLimitingService
  include Rails.application.routes.url_helpers

  DISCRIMINATOR_ENV_KEY = 'siade.rate_limiting.authorization_request_discriminator'.freeze

  FRANCE_CONNECT_INTROSPECTION_THROTTLES = [
    { name: 'FranceConnect introspection per IP and per minute', limit: 30, period: 60 },
    { name: 'FranceConnect introspection per IP and per hour', limit: 600, period: 3600 }
  ].freeze

  def discriminate_by_authorization_request_for_endpoints(req, endpoints_list)
    endpoint = extract_endpoint_from_url(req.url).slice(:controller, :action)

    return nil unless endpoints_list.include?(endpoint)

    authorization_request_discriminator(req)
  end

  def whitelisted_access?(req)
    whitelist.include?(
      resolved_token(req)
    )
  end

  def blacklisted_access?(req)
    user = resolved_user(req)

    user.present? && user.blacklisted?
  end

  def ip_forbidden_access?(req)
    user = resolved_user(req)

    return false unless user&.ip_restricted?

    !user.ip_allowed?(req.ip)
  end

  def custom_rate_limit_for(req)
    resolved_user(req)&.rate_limit_per_minute
  end

  def custom_rate_limit?(req)
    custom_rate_limit_for(req).present?
  end

  def throttle_limit_for(req, throttle_name, default_limit)
    resolved_user(req)&.throttle_override_for(throttle_name.to_s) || default_limit
  end

  def authorization_request_discriminator(req)
    return req.env[DISCRIMINATOR_ENV_KEY] if req.env.key?(DISCRIMINATOR_ENV_KEY)

    req.env[DISCRIMINATOR_ENV_KEY] = compute_authorization_request_discriminator(req)
  end

  def france_connect_introspection_ip_discriminator(req)
    req.ip if france_connect_introspection?(req)
  end

  def build_rate_limit_headers(data)
    {
      'RateLimit-Limit' => data[:limit].to_s,
      'RateLimit-Remaining' => compute_remaining(data),
      'RateLimit-Reset' => compute_reset(data)
    }
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
    token = resolved_token(req)
    Digest::SHA256.hexdigest(token) if token.present?
  end

  def france_connect_introspection?(req)
    resolved_user(req).nil? &&
      bearer_token?(req) &&
      france_connectable_controller?(extract_endpoint_from_url(req.url)[:controller])
  end

  def bearer_token?(req)
    req.env['HTTP_AUTHORIZATION'].to_s.match?(/\ABearer .+\z/)
  end

  def france_connectable_controller?(controller)
    return false if controller.blank?

    france_connectable_controllers.compute_if_absent(controller) do
      "#{controller}_controller".camelize.safe_constantize&.include?(APIParticulier::FranceConnectable) || false
    end
  end

  def france_connectable_controllers
    @france_connectable_controllers ||= Concurrent::Map.new
  end

  def resolved_user(req)
    req.env[UserResolutionMiddleware::USER_ENV_KEY]
  end

  def resolved_token(req)
    req.env[UserResolutionMiddleware::TOKEN_ENV_KEY]
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

  def whitelist
    @whitelist ||= Rails.configuration.jwt_whitelist
  end
end
