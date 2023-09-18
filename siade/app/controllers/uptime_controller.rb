class UptimeController < APIController
  def show
    if route_recognized?
      render status: http_code
    else
      render status: :not_found
    end
  end

  private

  def mocked_response_for_staging
    render status: :ok
  end

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
    @internal_response ||= Net::HTTP.start(uri.hostname, uri.port, request_options) do |http|
      uptime_request = Net::HTTP::Get.new uri

      if api == 'entreprise'
        uptime_request['Authorization'] = "Bearer #{jwt}"
      else
        uptime_request['X-Api-key'] = jwt
      end

      http.request uptime_request
    end
  end

  def query_params
    if api == 'entreprise'
      {
        context: 'Ping',
        recipient: 'DINUM',
        object: 'Uptime'
      }
    else
      URI.decode_www_form(URI("#{base_uri}#{route}").query).to_h
    end
  end

  def uri
    URI("#{base_uri}#{route}")
      .tap { |u| u.query = URI.encode_www_form(query_params) }
  end

  def route
    route_from_params
  end

  def route_from_params
    @route_from_params ||= begin
      raw_route = params.require(:route)

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
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
      open_timeout: 11,
      read_timeout: 11
    }
  end

  def base_uri
    case Rails.env
    when 'staging', 'sandbox'
      "https://#{Rails.env}.#{api}.api.gouv.fr"
    else
      "https://#{api}.api.gouv.fr"
    end
  end

  def api
    if request.host.include?('entreprise.api')
      'entreprise'
    else
      'particulier'
    end
  end

  def jwt
    JWT.encode(jwt_payload, jwt_hash_secret, jwt_hash_algo)
  end

  def jwt_payload
    {
      uid: JwtUser.uptime_id,
      jti: JwtUser.uptime_id,
      scopes: Scope.all,
      sub: 'whatever',
      version: '1.0',
      iat: 10.seconds.ago.to_i,
      exp: 90.seconds.from_now.to_i
    }
  end

  def jwt_hash_secret
    Siade.credentials[:jwt_hash_secret]
  end

  def jwt_hash_algo
    Siade.credentials[:jwt_hash_algo]
  end
end
