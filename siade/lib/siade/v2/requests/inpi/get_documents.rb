class SIADE::V2::Requests::INPI::GetDocuments < SIADE::V2::Requests::Generic
  def initialize(ids_fichiers, cookie)
    @ids_fichiers = ids_fichiers
    @cookie = cookie
  end

  def valid?
    if @ids_fichiers.is_a?(Array)
      true
    else
      set_error_message_for(502)
      false
    end
  end

  protected

  def provider_name
    'INPI'
  end

  def request_uri
    URI "#{inpi_uri}/document/get"
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def headers(request)
    request['Cookie'] = @cookie
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def build_response
    response_wrapper.new(raw_response)
  end

  def response_wrapper
    SIADE::V2::Responses::INPI::GetDocuments
  end

  def request_params
    {
      listeIdFichier: @ids_fichiers.join(',')
    }
  end

  def inpi_uri
    Siade.credentials[:inpi_url]
  end

  def set_error_message_502
    (@errors ||= []) << INPIError.new(:incorrect_ids)
  end
end
