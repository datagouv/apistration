class APIController < ApplicationController
  include HandleTokens
  include CanLogRequestsInfoForDebugging

  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from MockedInteractor::EndpointNotYetImplemented, with: :not_implemented_error

  before_action :verify_duplicate_params!
  after_action :clean_duplicate_param_tracking

  attr_reader :organizer

  def process_action(*args)
    super
  rescue ActionDispatch::Http::MimeNegotiation::InvalidType => e
    request.headers['Content-Type'] = content_type_header

    error = BadRequestError.new(e.message)

    render error_json(error, status: 400)
  end

  protected

  def at_least_one_error_kind_of?(kinds, retriever)
    kinds = Array(kinds)

    retriever.errors.any? do |error|
      kinds.include?(error.kind)
    end
  end

  def content_type_header
    'application/json'
  end

  def render_errors(extra_payload = {})
    render json:    ErrorsSerializer.new(organizer.errors, format: error_format).as_json.merge(extra_payload || {}),
      status:  organizer.http_code
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
    render error_json(ExpiredTokenError.new(api_kind), status: 401)
  end

  def verify_duplicate_params!
    if Rails.cache.fetch(duplicate_param_backend_key).blank?
      Rails.cache.write(duplicate_param_backend_key, '1', expires_in: 1.minute)
    else
      render error_json(ConflictError.new, status: 409)
      false
    end
  end

  def clean_duplicate_param_tracking
    Rails.cache.delete(duplicate_param_backend_key)
  end

  def duplicate_param_backend_key
    @duplicate_param_backend_key ||= Digest::SHA256.hexdigest("#{operation_id}_#{params.to_unsafe_h.except(:controller, :action)}_#{current_user.id}")
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

  def not_implemented_error
    error_json(NotImplementedYetError.new, status: :not_implemented)
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
