class SIADE::V2::Requests::INSEE::Entreprise < SIADE::V2::Requests::Generic
  def initialize(siren)
    @siren = siren
  end

  def valid?
    if siren_valid?
      RenewINSEETokenService.new.call
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

  def siren_valid?
    Siren.new(@siren).valid?
  end

  def request_uri
    URI([base_uri, 'entreprises', 'sirene', 'V3', 'siren', @siren].join('/'))
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
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
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{insee_token}"
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_PEER }
  end

  def follow_redirect(moved_response)
    extract_new_siren_from_location(moved_response['location'])

    if siren_valid?
      recall_api_with_new_siren
    else
      super(moved_response)
    end
  end

  private

  def set_error_message_422
    set_error_for_bad_siren
  end

  def base_uri
    Siade.credentials[:insee_v3_domain]
  end

  def insee_token
    YAML.load_file(filename)['token']
  end

  def filename
    Rails.root.join('config', 'insee_secrets.yml')
  end

  def recall_api_with_new_siren
    call_api
  end

  def extract_new_siren_from_location(location)
    @siren = location.match(/(\d{9})$/).to_s
  end
end
