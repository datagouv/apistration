class UserAccessSpy
  class << self
    def log_authorized(user:)
      ActiveSupport::Notifications.instrument('user_access', user: user.logstash_id, jti: user.token_id, iat: user.iat, access: 'allow')
      true
    end

    def log_forbidden_jwt_token(user:)
      ActiveSupport::Notifications.instrument('user_access', user: user.logstash_id, jti: user.token_id, access: 'deny')
      false
    end

    def log_expired_token(user:)
      ActiveSupport::Notifications.instrument('user_access', user: user.logstash_id, jti: user.token_id, access: 'expired token')
      false
    end

    def log_unauthorized(user_info:)
      ActiveSupport::Notifications.instrument('user_access', user: user_info, jti: nil, access: 'deny')
      false
    end
  end
end
