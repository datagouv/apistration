class APIEntreprise::V3AndMore::BaseController < APIEntrepriseController
  include UseRetrievers

  class UnsupportedVersionError < ::ActionController::RoutingError; end

  before_action :verify_api_version!
  before_action :verify_recipient_is_a_siret!
  before_action :verify_recipient_is_not_resource_id_nor_whitelist!
  before_action :set_content_type_header!

  rescue_from UnsupportedVersionError, with: :unsupported_version_response

  protected

  def cache_key
    request.path
  end

  def serialize_data(organizer)
    if organizer.mocked_data.present?
      organizer.mocked_data[:payload]
    else
      serializer_class.new(organizer.bundled_data).serializable_hash
    end
  end

  def verify_api_version!
    raise_unsupported_version_error! unless supported_version?
  end

  def verify_recipient_is_a_siret!
    return if recipient_is_a_siret?

    render json: ErrorsSerializer.new([InvalidRecipientError.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  def verify_recipient_is_not_resource_id_nor_whitelist!
    return unless recipient_is_resource_siren_or_siret?
    return if recipient_whitelisted?

    render json: ErrorsSerializer.new([RecipientAndResourceIdIdenticalError.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  def recipient_is_a_siret?
    ValidateSiret.call(params: { siret: params[:recipient] }).success?
  end

  def recipient_whitelisted?
    Rails.application.config_for('recipient_sirets_whitelist').any? do |recipient_siret_data|
      recipient_siret_data[:siret].first(9) == params[:recipient].strip.first(9)
    end
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

  def unsupported_version_response(exception)
    error = UnsupportedAPIVersionError.new(exception.message)

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
end
