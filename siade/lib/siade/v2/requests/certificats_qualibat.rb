class SIADE::V2::Requests::CertificatsQUALIBAT < SIADE::V2::Requests::Generic
  attr_accessor :siret

  def initialize(siret)
    @siret = siret
  end

  def valid?
    if Siret.new(siret).valid?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'Qualibat'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def request_uri
    URI(Siade.credentials[:qualibat_url])
  end

  def response_wrapper
    SIADE::V2::Responses::CertificatsQUALIBAT
  end

  def request_params
    { token: token, SIRET: siret }
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  private

  def set_error_message_422
    set_error_for_bad_siret
  end

  def token
    Siade.credentials[:qualibat_token]
  end
end
