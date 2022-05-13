class SIADE::V2::Requests::INSEE::Etablissement < SIADE::V2::Requests::Generic
  def initialize(siret)
    @siret = siret
  end

  def valid?
    if siret_valid?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'INSEE'
  end

  def siret_valid?
    Siret.new(@siret).valid?
  end

  def request_uri
    URI([base_uri, 'entreprises', 'sirene', 'V3', 'siret', @siret].join('/'))
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_PEER }
  end

  def build_response
    if @raw_response.is_a?(Net::HTTPForbidden)
      response_wrapper.new(raw_response)
    else
      super
    end
  end

  def response_wrapper
    SIADE::V2::Responses::INSEE::Generic
  end

  def request_params
    {}
  end

  def set_headers(req)
    req['Authorization'] = 'Bearer ' + insee_token
  end

  def follow_redirect(moved_response)
    uri = URI(moved_response['location'])

    @raw_response = Net::HTTP.start(uri.host, uri.port, net_http_options.merge(timeout_http_options)) do |http|
      request = Net::HTTP::Get.new(uri)
      set_headers(request)
      http.request(request)
    end

    @response = build_response
  end

  private

  def timeout_http_options
    {
      open_timeout: 2,
      read_timeout: 2,
    }
  end

  def set_error_message_422
    set_error_for_bad_siret
  end

  def base_uri
    Siade.credentials[:insee_v3_domain]
  end

  def insee_token
    INSEE::Authenticate.call.token
  end
end
