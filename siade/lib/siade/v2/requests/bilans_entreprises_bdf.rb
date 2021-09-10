class SIADE::V2::Requests::BilansEntreprisesBDF < SIADE::V2::Requests::Generic
  attr_reader :siren

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
    'Banque de France'
  end

  def request_uri
    URI('https://ws-dlnuf.banque-france.fr/ws/BILAN_APIEntreprise_1_0_0_PRD/bilans/json')
  end

  def request_lib
    :rest_client
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::BilansEntreprisesBDF
  end

  def request_params
    { siren: siren }
  end

  def rest_client_options
    # TODO: Ask certs of banque de france
    # when done use ssl_ca_file: ca_file
    # and verify_ssl: OpenSSL::SSL::VERIFY_PEER
    { ssl_client_cert: cert, ssl_client_key: key, verify_ssl: OpenSSL::SSL::VERIFY_NONE }
  end

  # TODO: Ask certs
  # def ca_file
  # end

  def key
    raw_key = File.read(Siade.credentials[:ssl_wildcard_certif_key_path])
    OpenSSL::PKey::RSA.new(raw_key)
  end

  def cert
    raw_cert = File.read(Siade.credentials[:ssl_wildcard_certif_crt_path])
    OpenSSL::X509::Certificate.new(raw_cert)
  end

  def set_error_message_422
    set_error_for_bad_siren
  end
end
