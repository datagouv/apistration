class SIADE::V2::Requests::ModelesINPI < SIADE::V2::Requests::Generic
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
    'INPI'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::ModelesINPI
  end

  def set_error_message_422
    set_error_for_bad_siren
  end

  def request_uri
    URI("https://opendata-pi.inpi.fr/api/modeles/search?collections=FR&collections=WO&query=[ApplicantIdentifier=#{siren}]")
  end

  def request_params
    nil
  end

  def net_http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  end
end
