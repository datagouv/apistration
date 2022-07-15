class API::V3AndMore::BaseController < API::AuthenticateEntityController
  include OrganizersMethodsHelpers

  class UnsupportedVersionError < ::ActionController::RoutingError; end

  before_action :verify_api_version!
  before_action :verify_recipient_is_a_siret!
  before_action :verify_recipient_is_not_resource_id!
  before_action :set_content_type_header!

  rescue_from UnsupportedVersionError, with: :unsupported_version_response

  attr_reader :cached_retriever

  protected

  def verify_api_version!
    raise_unsupported_version_error! unless supported_version?
  end

  def verify_recipient_is_a_siret!
    return if recipient_is_a_siret?

    render json: ErrorsSerializer.new([InvalidRecipientError.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  def verify_recipient_is_not_resource_id!
    return unless recipient_is_resource_siren_or_siret?

    render json: ErrorsSerializer.new([RecipientAndResourceIdIdenticalError.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  def recipient_is_a_siret?
    ValidateSiret.call(params: { siret: params[:recipient] }).success?
  end

  def recipient_is_resource_siren_or_siret?
    recipient_is_resource_siren? || recipient_is_resource_siret?
  end

  def recipient_is_resource_siren?
    return unless params[:siren]

    params[:recipient].strip.first(9) == params[:siren].strip
  end

  def recipient_is_resource_siret?
    return unless params[:siret]

    params[:recipient].strip == params[:siret].strip
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

  def content_type_header
    'application/vnd.api+json'
  end

  def set_content_type_header!
    response.headers['Content-Type'] = content_type_header
  end

  def retrieve_payload_data(retriever, cache: false, expires_in: nil, cache_key: nil)
    if cache && !bypass_cache?
      @cached_retriever = CacheResourceRetriever.call(
        retriever_organizer: retriever,
        retriever_params: organizer_params,
        cache_key:,
        expires_in:
      )
    else
      retriever.call(organizer_params)
    end
  end

  def bypass_cache?
    request.headers['Cache-Control'] == 'no-cache'
  end
end
