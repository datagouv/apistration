class SIADE::V2::Requests::CartesProfessionnellesFNTP < SIADE::V2::Requests::Generic
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
    'FNTP'
  end

  def request_lib
    :rest_client
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::CartesProfessionnellesFNTP
  end

  def request_uri
    "http://rip.fntp.fr/rip/sgmap/#{@siren}/cartepro"
  end

  def request_params
    { token: token }
  end

  private

  def set_error_message_422
    set_error_for_bad_siren
  end

  def token
    Siade.credentials[:fntp_token]
  end
end
