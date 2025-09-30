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

  def token
    @token ||= retrieve_token
  end

  private

  def authorize_access_to_resource!
    return if ScopesAuthorizationService.new(current_user.scopes, self.class.name).allow?

    raise NotAuthorizedError
  end

  def authenticate_user!
    raise NotValidTokenError unless token

    extract_user

    raise NotValidTokenError if current_user.blank? || current_user.invalid?

    current_user.not_expired!

    true
  end

  def extract_user
    @current_user = jwt_token_service.extract_user(token)
  end

  def retrieve_token
    token_from_query_params || token_from_headers
  end

  def token_from_query_params
    params[:token]
  end

  def token_from_headers
    bearer_token_from_headers
  end

  def jwt_token_service
    ::JwtTokenService.instance
  end

  def set_monitoring_context
    return if current_user.blank?

    monitoring_service.set_user_context(
      current_user.as_json.symbolize_keys!
    )

    monitoring_service.set_controller_params(
      params.to_unsafe_h
    )
  end

  def monitoring_service
    @monitoring_service ||= MonitoringService.instance
  end
end
