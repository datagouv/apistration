class API::V3::BaseController < API::AuthenticateEntityController
  def render_errors(organizer)
    render json:    ::ErrorsSerializer.new(organizer.errors, format: error_format).as_json,
           status:  organizer.status
  end
end
