class API::V2::UptimeController < API::V2::BaseController
  skip_before_action :context_is_filled!

  def show
    authorize :uptime

    if route_recognized?
      render status: http_code
    else
      render status: :not_found
    end
  end

  private

  def route_recognized?
    Rails.application.routes.recognize_path route
  rescue ActionController::RoutingError
    false
  end

  def http_code
    internal_response.is_a?(Net::HTTPOK) ? :ok : :bad_gateway
  rescue Net::ReadTimeout, Net::OpenTimeout
    :bad_gateway
  end

  def internal_response
    Net::HTTP.start(uri.hostname, uri.port, request_options) do |http|
      uptime_request = Net::HTTP::Get.new uri
      uptime_request['Authorization'] = "Bearer #{jwt}"
      http.request uptime_request
    end
  end

  def query_params
    {
      context:   'Ping',
      recipient: 'DINUM',
      object:    'Uptime'
    }
  end

  def uri
    URI("https://entreprise.api.gouv.fr#{route}")
      .tap { |u| u.query = URI.encode_www_form(query_params) }
  end

  def route
    params.permit(:route)[:route]
  end

  def request_options
    {
      use_ssl:     true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER
    }
  end

  def jwt
    Siade.credentials[:uptime_robot_internal_jwt]
  end
end
