class SIADE::V2::Requests::CertificatsOPQIBI < SIADE::V2::Requests::Generic
  attr_accessor :siren

  def initialize(siren)
    @siren = siren
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
    'OPQIBI'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def request_uri
    URI("https://www.opqibi.com/certificats/#{@siren}")
  end

  def net_http_options
    {
      use_ssl:     true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
  end

  def request_params
    { token: token }
  end

  def response_wrapper
    SIADE::V2::Responses::CertificatsOPQIBI
  end

  private

  def set_error_message_422
    set_error_for_bad_siren
  end

  def token
    Siade.credentials[:opqibi_token]
  end
end
