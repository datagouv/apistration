class SIADE::V2::Requests::CertificatsCNETP < SIADE::V2::Requests::Generic
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
    'CNETP'
  end

  def request_lib
    :rest_client
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::CertificatsCNETP
  end

  def request_uri
    'https://cnetp_domain.gouv.fr/webservice/doc/attestations/entreprises'
  end

  def request_params
    {
      id: client_number,
      jeton: token,
      siren: siren
    }
  end

  def rest_client_options
    {
      verify_ssl: OpenSSL::SSL::VERIFY_NONE
    }
  end

  private

  def set_error_message_422
    set_error_for_bad_siren
  end

  def token
    Siade.credentials[:cnetp_token]
  end

  def client_number
    Siade.credentials[:cnetp_client_number]
  end
end
