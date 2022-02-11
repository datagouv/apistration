class SIADE::V2::Requests::Infogreffe < SIADE::V2::Requests::Generic
  attr_accessor :siren

  def initialize(siren)
    @siren = siren
  end

  def valid?
    if Siren.new(siren).valid?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'Infogreffe'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :post
  end

  def response_wrapper
    SIADE::V2::Responses::Infogreffe
  end

  def request_uri
    URI('https://infogreffe_url_extrait_rcs.gouv.fr')
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def set_headers(request)
    request['Content-Type'] = 'text/xml'
    request['charset'] = 'utf-8'
    request['SOAPAction'] = 'getProduitsWebServicesXML'
  end

  def post_request_body
    InfogreffeKbisSoapBuilder.new(siren).render
  end

  def set_error_message_422
    set_error_for_bad_siren
  end
end
