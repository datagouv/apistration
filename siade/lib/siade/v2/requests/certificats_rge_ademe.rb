class SIADE::V2::Requests::CertificatsRGEAdeme < SIADE::V2::Requests::Generic
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
    'Ademe'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :post
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_PEER }
  end

  def request_uri
    URI('https://bo-ris.ademe.fr/api/search/company')
  end

  def set_headers(request)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
  end

  def post_request_body
    URI.encode_www_form({ siret: siret, key: ademe_secret_token })
  end

  def response_wrapper
    SIADE::V2::Responses::CertificatsRGEAdeme
  end

  def ademe_secret_token
    "#{Siade.credentials[:ademe_rge_token]}"
  end

  def set_error_message_422
    set_error_for_bad_siret
  end
end
