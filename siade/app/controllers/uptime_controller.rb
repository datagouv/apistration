class UptimeController < APIController
  skip_before_action :authenticate_user!, only: :show_without_token
  skip_before_action :authorize_access_to_resource!, only: :show_without_token

  def show
    render_status
  end

  def show_without_token
    if valid_provider?
      render_status
    else
      render status: :not_found
    end
  end

  private

  def mocked_response_for_staging
    render status: :ok
  end

  def render_status
    if route_recognized?
      render status: http_code
    else
      render status: :not_found
    end
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
    if valid_provider?
      route_for_provider
    else
      route_from_params
    end
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

  def route_for_provider
    {
      'caf' => "/api/v2/composition-familiale?codePostal=#{Siade.credentials[:ping_cnaf_postal_code]}&numeroAllocataire=#{Siade.credentials[:ping_cnaf_numero_allocataire]}",
      'impots' => "/api/v2/avis-imposition?numeroFiscal=#{Siade.credentials[:ping_dgfip_svair_numero_fiscal]}&referenceAvis=#{Siade.credentials[:ping_dgfip_svair_reference_avis]}"
    }[params[:provider]]
  end

  def valid_provider?
    route_for_provider.present?
  end

  def request_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER
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
      uid: '99999999-9999-9999-9999-999999999999',
      jti: '99999999-9999-9999-9999-999999999999',
      scopes: all_scopes,
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

  def all_scopes
    Rails.application.config_for(:authorizations).values.flatten.uniq
  end
end
