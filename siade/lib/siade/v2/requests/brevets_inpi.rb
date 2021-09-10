class SIADE::V2::Requests::BrevetsINPI < SIADE::V2::Requests::Generic
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
    SIADE::V2::Responses::BrevetsINPI
  end

  def set_error_message_422
    set_error_for_bad_siren
  end

  # Exotic parameters structure due to solr syntax that can be embedded in query strings
  # prevent us from having the classic request_params. Option in curl is -g to disable
  # globbing
  def request_uri
    URI("https://opendata-pi.inpi.fr/api/brevets/search?collections=FR&collections=EP&collections=WO&collections=CCP&query=[TISI=#{siren}]")
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
