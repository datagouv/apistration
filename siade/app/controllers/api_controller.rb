class APIController < ActionController::API
  include Pundit
  # Not needed anymore with rails 5 ActionController::API controllers
  # protect_from_forgery with: :null_session

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ::JWT::ExpiredSignature, with: :user_no_longer_authorized

  # FIXME: need test
  # rescue_from ActionDispatch::ParamsParser::ParseError, with: :bad_request
  rescue_from ActionController::ParameterMissing, with: :bad_request

  after_action :verify_authorized

  def index; end

  def process_action(*args)
    super
  rescue ActionDispatch::Http::MimeNegotiation::InvalidType => e
    request.headers['Content-Type'] = content_type_header

    error = BadRequestError.new(e.message)

    render error_json(error, status: 400)
  end

  def remote_ip
    # XXX Might be because of old infra load balancer shit
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end

  protected

  def content_type_header
    raise ::NotImplementedError
  end

  def render_errors(retriever, extra_payload = {})
    render json:    ErrorsSerializer.new(retriever.errors, format: error_format).as_json.merge(extra_payload || {}),
      status:  retriever.http_code
  end

  private

  # XXX Clean this, after no more old tokens
  def user_not_authorized(exception)
    case exception.message
    when /must have valid token/
      render_generic_errors_serializer(InvalidTokenError, status: 401)
    when /must be activated/
      render_generic_errors_serializer(OldTokenError, status: 401)
    when /not allowed to/
      render_generic_errors_serializer(InsufficientPrivilegesError, status: 403)
    end
  end

  def user_no_longer_authorized(_exception)
    ::UserAccessSpy.log_expired_token(user: pundit_user)

    render_generic_errors_serializer(ExpiredTokenError, status: 401)
  end

  def render_generic_errors_serializer(klass, status:)
    error = klass.new

    render error_json(error, status: status)
  end

  def error_json(error, status:)
    {
      json: ErrorsSerializer.new([error], format: error_format).as_json,
      status: status
    }
  end

  def bad_request
    render_generic_errors_serializer(BadRequestError, status: 400)
  end

  def error_format
    json_api_format_error_activated? ? :json_api : :flat
  end

  def json_api_format_error_activated?
    params[:error_format] == 'json_api'
  end
end
