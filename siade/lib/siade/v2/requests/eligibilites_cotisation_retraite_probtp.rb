class SIADE::V2::Requests::EligibilitesCotisationRetraitePROBTP < SIADE::V2::Requests::Generic
  attr_accessor :siret

  def initialize(siret)
    @siret = siret
  end

  def valid?
    if Siret.new(@siret).valid?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'ProBTP'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :post
  end

  def post_request_body
    { corps: @siret }.to_json
  end

  def request_uri
    URI('https://probtp_domain.gouv.fr/ws_ext/rest/certauth/mpsservices/getStatutCotisation')
  end

  def net_http_options
    {
      use_ssl:     true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
      cert:        cert,
      key:         key
    }
  end

  def response_wrapper
    SIADE::V2::Responses::EligibilitesCotisationRetraitePROBTP
  end

  private

  def set_error_message_422
    set_error_for_bad_siret
  end

  def key
    raw_key = File.read(Siade.credentials[:ssl_wildcard_certif_key_path])
    OpenSSL::PKey::RSA.new(raw_key)
  end

  def cert
    raw_cert = File.read(Siade.credentials[:ssl_wildcard_certif_crt_path])
    OpenSSL::X509::Certificate.new(raw_cert)
  end
end
