module HandleTokens
  extend ActiveSupport::Concern

  class NotValidTokenError < StandardError; end
  class NotAuthorizedError < StandardError; end

  included do
    attr_reader :current_user

    before_action :authenticate_user!
    before_action :set_monitoring_context
    before_action :authorize_access_to_resource!

    rescue_from NotAuthorizedError, NotValidTokenError, with: :user_not_authorized
    rescue_from ::JWT::ExpiredSignature, with: :user_no_longer_authorized
  end

  def bearer_token_from_headers
    auth = request.headers['Authorization']

    return unless auth

    matchs = auth.match(/\ABearer (.+)\z/)
    matchs[1] if matchs
  end

  protected

  def resource_name
    self.class.name
  end

  private

  def authorize_access_to_resource!
    return if ScopesAuthorizationService.new(current_user.scopes, resource_name).allow?

    raise NotAuthorizedError
  end

  def authenticate_user!
    @current_user = request.env[UserResolutionMiddleware::USER_ENV_KEY] || extract_user_from_token

    raise NotValidTokenError if current_user.blank? || current_user.invalid?

    instrument_user_access

    current_user.not_expired!

    true
  end

  def extract_user_from_token
    token = params[:token] || bearer_token_from_headers
    JwtTokenService.instance.extract_user(token) if token
  end

  def set_monitoring_context
    return if current_user.blank?

    monitoring_service.set_user_context(current_user.as_json.symbolize_keys!)
    monitoring_service.set_controller_params(params.to_unsafe_h)
  end

  def instrument_user_access
    ActiveSupport::Notifications.instrument(
      'user_access',
      user: current_user.logstash_id,
      jti: current_user.token_id,
      iat: current_user.iat
    )
  end

  def monitoring_service
    @monitoring_service ||= MonitoringService.instance
  end
end
