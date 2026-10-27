class RackAttack::TrackBlockedRequest < ApplicationOrganizer
  include SecurityEvent::Tracking

  CAPABILITY_PATH = %r{\A(/api/attestations|/proxy/files|/proxy/inpi/download)/[^/]+}
  FILTERED = '[FILTERED]'.freeze

  BLOCKLIST_REASONS = {
    'JWT blacklist' => 'blacklisted',
    'IP whitelist' => 'ip_not_allowed'
  }.freeze

  tracks_security_event 'api.request.blocked',
    target_id: ->(context) { resolved_user(context.request)&.jti },
    computed_details: ->(context) { blocked_details(context.request) }

  organize SecurityEvent::Track

  def self.blocked_details(request)
    user = resolved_user(request)

    {
      reason: reason(request.env),
      rule: request.env['rack.attack.matched'],
      **credential_details(user, request.env[UserResolutionMiddleware::DELEGATION_ENV_KEY]),
      ip: request.ip,
      method: request.request_method,
      path: request.path.squeeze('/').sub(CAPABILITY_PATH, "\\1/#{FILTERED}"),
      user_agent: request.user_agent
    }
  end

  def self.reason(env)
    return 'throttled' if env['rack.attack.match_type'] == :throttle

    BLOCKLIST_REASONS.fetch(env['rack.attack.matched'], env['rack.attack.matched'])
  end

  def self.credential_details(user, delegation)
    return {} if user.nil?

    {
      jti: user.jti,
      credential_type: user.token_type || 'token',
      authorization_request_id: user.authorization_request_id,
      editor_id: user.editor_id,
      delegation_id: delegation&.id
    }
  end

  def self.resolved_user(request)
    request.env[UserResolutionMiddleware::USER_ENV_KEY]
  end
end
