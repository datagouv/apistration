class APIController < ApplicationController
  include HandleTokens
  include CanLogRequestsInfoForDebugging

  rescue_from ActionController::ParameterMissing, with: :bad_request

  def process_action(*args)
    super
  rescue ActionDispatch::Http::MimeNegotiation::InvalidType => e
    request.headers['Content-Type'] = content_type_header

    error = BadRequestError.new(e.message)

    render error_json(error, status: 400)
  end

  protected

  def at_least_one_error_kind_of?(kind, retriever)
    retriever.errors.any? do |error|
      error.kind == kind
    end
  end

  def content_type_header
    'application/json'
  end

  def render_errors(retriever, extra_payload = {})
    render json:    ErrorsSerializer.new(retriever.errors, format: error_format).as_json.merge(extra_payload || {}),
      status:  retriever.http_code
  end

  private

  def user_not_authorized(exception)
    case exception
    when NotValidTokenError
      render_generic_errors_serializer(InvalidTokenError, status: 401)
    when NotAuthorizedError
      render error_json(InsufficientPrivilegesError.new(api_kind), status: 403)
    else
      raise 'Invalid exception class', exception.class
    end
  end

  def user_no_longer_authorized(_exception)
    render_generic_errors_serializer(ExpiredTokenError, status: 401)
  end

  def render_generic_errors_serializer(klass, status:)
    error = klass.new

    render error_json(error, status:)
  end

  def error_json(error, status:)
    {
      json: ErrorsSerializer.new([error], format: error_format).as_json,
      status:
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

  def operation_id
    api_name, _, *final_part = self.class.to_s.underscore.split('/')
    [api_name, current_version, final_part].join('_').sub(/_controller$/, '')
  end

  def current_version
    "v#{params.fetch(:api_version, 2)}"
  end
end
