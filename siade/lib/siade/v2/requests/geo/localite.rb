class SIADE::V2::Requests::Geo::Localite < SIADE::V2::Requests::Generic
  def initialize(code)
    @code = code
  end

  def valid?
    if code_commune?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'API Geo'
  end

  def request_uri
    URI([base_uri, 'communes', @code + additional_fields].join('/'))
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::Geo::Generic
  end

  def request_params
    {}
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  private

  def additional_fields
    '?fields=nom,codePostal,region,departement'
  end

  def code_commune?
    @code.is_a?(String) && @code.length == 5
  end

  def base_uri
    Siade.credentials[:geo_api_domain]
  end

  def set_error_message_422
    (@errors ||= []) << UnprocessableEntityError.new(:code_insee_commune)
  end
end
