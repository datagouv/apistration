class API::V2::BaseController < ::API::AuthenticateEntityController

  protected

  def content_type_header
    'application/json'
  end
end
