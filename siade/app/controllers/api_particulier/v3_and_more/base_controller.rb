class APIParticulier::V3AndMore::BaseController < APIController
  before_action :set_content_type_header!

  protected

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
