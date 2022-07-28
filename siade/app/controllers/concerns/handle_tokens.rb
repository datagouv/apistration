module HandleTokens
  extend ActiveSupport::Concern

  class NotValidTokenError < StandardError; end
  class NotAuthorizedError < StandardError; end

  included do
    before_action :authenticate_user!
    before_action :set_monitoring_context

    after_action :add_user_access_to_logstash

    rescue_from NotAuthorizedError, NotValidTokenError, with: :user_not_authorized
    rescue_from ::JWT::ExpiredSignature, with: :user_no_longer_authorized

    def self.authorize(scopes)
      send(:before_action, :check_authorization, lambda {
        controller.authorize(scopes)
      })
      send(:prepend_after_action, :authenticate_user!)
    end
  end

  def current_user
    @authenticated_user
  end

  def jwt?
    jwt_token_service.valid?
  end

  def user_from_jwt
    @user_from_jwt ||= jwt_token_service.jwt_user
  end

  private

  def authorize(scopes)
    scopes = Array(scopes).map(&:to_s)

    return if (scopes & current_user.scopes).any?

    raise NotAuthorizedError
  end

  def authenticate_user!
    @token = retrieve_token
    raise NotValidTokenError unless @token

    @authenticated_user = user_from_jwt if jwt?

    raise NotValidTokenError if @authenticated_user.blank? || !@authenticated_user.valid?

    @authenticated_user.not_expired!

    true
  end

  def retrieve_token
    token_from_query_params || token_from_headers
  end

  def token_from_query_params
    params[:token]
  end

  def token_from_headers
    auth = request.headers['Authorization']

    return unless auth

    matchs = auth.match(/\ABearer (.+)\z/)
    matchs[1] if matchs
  end

  def jwt_token_service
    ::JwtTokenService.new(jwt: @token)
  end

  def set_monitoring_context
    monitoring_service.set_user_context(
      current_user.as_json.symbolize_keys!
    )

    monitoring_service.set_controller_params(
      params.to_unsafe_h
    )
  end

  def add_user_access_to_logstash
    return unless jwt? && user_from_jwt.present?

    ActiveSupport::Notifications.instrument(
      'user_access',
      user: user_from_jwt.logstash_id,
      jti: user_from_jwt.token_id,
      iat: user_from_jwt.iat
    )
  end

  def monitoring_service
    @monitoring_service ||= MonitoringService.instance
  end
end
