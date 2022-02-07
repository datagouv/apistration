class API::V3AndMore::BaseController < API::AuthenticateEntityController
  class UnsupportedVersionError < ::ActionController::RoutingError; end

  before_action :verify_api_version!
  before_action :verify_recipient_is_a_siret!
  before_action :verify_recipient_is_not_param!
  before_action :set_content_type_header!

  rescue_from UnsupportedVersionError, with: :unsupported_version_response

  protected

  def verify_api_version!
    raise_unsupported_version_error! unless supported_version?
  end

  def verify_recipient_is_a_siret!
    return if recipient_is_a_siret?

    render json: ErrorsSerializer.new([InvalidRecipientError.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  def verify_recipient_is_not_param!
    return unless params[:recipient] == params[:siret]

    render json: ErrorsSerializer.new([RecipientAndResourceIdIdenticalError.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  def recipient_is_a_siret?
    ValidateSiret.call(params: { siret: params[:recipient] }).success?
  end

  def api_version
    params.fetch('api_version').to_i
  end

  def serializer_module
    raise ::NotImplementedError
  end

  def serializer_class
    serializer_module.const_get("V#{api_version}")
  end

  def supported_version?
    serializer_class
    true
  rescue ::NameError => _e
    false
  end

  def raise_unsupported_version_error!
    raise UnsupportedVersionError, "v#{api_version}"
  end

  def unsupported_version_response(e)
    error = UnsupportedAPIVersionError.new(e.message)

    render content_type: content_type_header,
      json:         ::ErrorsSerializer.new([error], format: error_format).as_json,
      status:       error.kind
  end

  def render_errors(organizer)
    render content_type: content_type_header,
      json:         ::ErrorsSerializer.new(organizer.errors, format: error_format).as_json,
      status:       extract_http_code(organizer)
  end

  def error_format
    :json_api
  end

  # rubocop:disable Metrics/MethodLength
  def extract_http_code(retriever)
    if retriever.errors.blank?
      :ok
    elsif at_least_one_error_kind_of?(:wrong_parameter, retriever)
      :unprocessable_entity
    elsif at_least_one_error_kind_of?(:network_error, retriever)
      :gateway_timeout
    elsif at_least_one_error_kind_of?(:unavailable_for_legal_reason, retriever)
      :unavailable_for_legal_reasons
    elsif at_least_one_error_kind_of?(:unauthorized, retriever)
      :unauthorized
    elsif at_least_one_error_kind_of?(:not_found, retriever)
      :not_found
    elsif at_least_one_error_kind_of?(:provider_error, retriever)
      :bad_gateway
    elsif at_least_one_error_kind_of?(:internal_error, retriever)
      :internal_error
    else
      raise 'No valid HTTP status'
    end
  end
  # rubocop:enable Metrics/MethodLength

  def at_least_one_error_kind_of?(kind, retriever)
    retriever.errors.any? do |error|
      error.kind == kind
    end
  end

  def content_type_header
    'application/vnd.api+json'
  end

  def set_content_type_header!
    response.headers['Content-Type'] = content_type_header
  end
end
