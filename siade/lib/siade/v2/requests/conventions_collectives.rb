class SIADE::V2::Requests::ConventionsCollectives < SIADE::V2::Requests::Generic
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
    'Fabrique numérique des Ministères Sociaux'
  end

  def request_uri
    URI("https://fabrique_numerique_conventions_collectives_url.gouv.fr/#{siret}")
  end

  def request_params
    {}
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
    SIADE::V2::Responses::ConventionsCollectives
  end

  private

  def set_error_message_422
    set_error_for_bad_siret
  end
end
