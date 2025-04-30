module VersionAware
  class UnsupportedVersionError < ::ActionController::RoutingError; end

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
      json:         ::ErrorsSerializer.new([error]).as_json,
      status:       error.kind
  end

  def api_version
    params.fetch('api_version').to_i
  end
end
