class APIParticulier::V3AndMore::BaseController < APIController
  class UnsupportedVersionError < ::ActionController::RoutingError; end

  before_action :verify_api_version!
  before_action :set_content_type_header!

  rescue_from UnsupportedVersionError, with: :unsupported_version_response

  protected

  def verify_api_version!
    raise_unsupported_version_error! unless supported_version?
  end

  def raise_unsupported_version_error!
    raise UnsupportedVersionError, "v#{api_version}"
  end

  def supported_version?
    serializer_class
    true
  rescue ::NameError => _e
    false
  end

  def serializer_class
    serializer_module.const_get("V#{api_version}")
  end

  def unsupported_version_response(exception)
    error = UnsupportedAPIVersionError.new(exception.message)

    render content_type: content_type_header,
      json:         ::ErrorsSerializer.new([error], format: error_format).as_json,
      status:       error.kind
  end

  def error_format
    :json_api
  end

  def api_version
    params.fetch('api_version').to_i
  end

  def content_type_header
    'application/vnd.api+json'
  end

  def set_content_type_header!
    response.headers['Content-Type'] = content_type_header
  end
end
