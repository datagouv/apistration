class SIADE::V2::Requests::EntreprisesArtisanales < SIADE::V2::Requests::Generic
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
    'CMA France'
  end

  def request_uri
    URI("https://rnm_domain.gouv.fr/v2/entreprises/#{siren}")
  end

  def request_params
    {
      format: format,
    }
  end

  def format
    :json
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::EntreprisesArtisanales
  end

  private

  def set_error_message_422
    set_error_for_bad_siren
  end
end
