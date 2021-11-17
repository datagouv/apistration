class API::AuthenticateEntityController < APIController
  before_action :authenticate_entity!,
    :set_monitoring_context

  rescue_from APIPolicy::AccessForbiddenError, with: :access_forbidden

  include HasMandatoryParams
  include MockableInStaging

  private

  def authenticate_entity!
    @token = retrieve_token
    raise not_valid_token_error unless @token

    @authenticated_user = user_from_jwt if jwt?

    unless @authenticated_user
      UserAccessSpy.log_unauthorized(user_info: @token)
      raise not_valid_token_error
    end

    @authenticated_user.not_expired!

    true
  end

  def pundit_user
    @authenticated_user
  end

  def not_valid_token_error
    Pundit::NotAuthorizedError.new(message: 'must have valid token')
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

  def jwt?
    jwt_token_service.valid?
  end

  def user_from_jwt
    jwt_token_service.jwt_user
  end

  def jwt_token_service
    ::JwtTokenService.new(jwt: @token)
  end

  def set_monitoring_context
    monitoring_service.set_user_context(
      pundit_user.as_json.symbolize_keys!
    )

    monitoring_service.set_controller_params(
      params.to_unsafe_h
    )
  end

  def monitoring_service
    @monitoring_service ||= MonitoringService.instance
  end
end
