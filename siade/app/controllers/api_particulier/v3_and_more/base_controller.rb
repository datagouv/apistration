class APIParticulier::V3AndMore::BaseController < APIController
  include VersionAware
  include RecipientManagement

  before_action :verify_api_version!
  before_action :verify_recipient_is_a_siret!
  before_action :verify_recipient_is_not_resource_id_nor_whitelist!
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
