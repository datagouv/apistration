class SIADE::V2::Requests::INPI::FindDocuments < SIADE::V2::Requests::Generic
  def initialize(siren, type, cookie)
    @siren = siren
    # :actes or :bilans
    @type = type
    @cookie = cookie
  end

  def valid?
    if Siren.new(@siren).valid?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'INPI'
  end

  def request_uri
    URI "#{inpi_uri}/#{@type}/find"
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def set_headers(request)
    request['Cookie'] = @cookie
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def response_wrapper
    SIADE::V2::Responses::INPI::FindDocuments
  end

  def request_params
    {
      siren: @siren
    }
  end

  private

  def set_error_message_422
    set_error_for_bad_siren
  end

  def inpi_uri
    Siade.credentials[:inpi_url]
  end
end
