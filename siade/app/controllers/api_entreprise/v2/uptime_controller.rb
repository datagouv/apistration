class APIEntreprise::V2::UptimeController < APIEntreprise::V2::BaseController
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
    route_attributes = Rails.application.routes.recognize_path(request.base_url + route)

    route_attributes[:controller] != 'errors'
  end

  def http_code
    internal_response.is_a?(Net::HTTPOK) ? :ok : :bad_gateway
  rescue Net::ReadTimeout, Net::OpenTimeout, SocketError
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
      context: 'Ping',
      recipient: 'DINUM',
      object: 'Uptime'
    }
  end

  def uri
    URI("https://entreprise.api.gouv.fr#{route}")
      .tap { |u| u.query = URI.encode_www_form(query_params) }
  end

  def route
    @route ||= begin
      raw_route = params.permit(:route)[:route]

      if raw_route.starts_with?('/')
        raw_route
      else
        "/#{raw_route}"
      end
    end
  end

  def request_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER
    }
  end

  def jwt
    JwtUser.new(
      uid: '99999999-9999-9999-9999-999999999999',
      jti: '99999999-9999-9999-9999-999999999999',
      scopes: all_scopes,
      iat: 10.seconds.ago.to_i,
      exp: 1.minutes.from_now.to_i
    )
  end

  def all_scopes
    YAML.load_file(Rails.root.join('config/all_scopes.yml'))
  end
end
