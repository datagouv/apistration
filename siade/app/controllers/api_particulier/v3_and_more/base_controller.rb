class APIParticulier::V3AndMore::BaseController < APIController
  include VersionAware

  before_action :verify_api_version!
  before_action :set_content_type_header!

  rescue_from UnsupportedVersionError, with: :unsupported_version_response

  protected

  def content_type_header
    'application/vnd.api+json'
  end

  def set_content_type_header!
    response.headers['Content-Type'] = content_type_header
  end
end
