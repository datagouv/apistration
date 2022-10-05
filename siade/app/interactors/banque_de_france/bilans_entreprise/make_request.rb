class BanqueDeFrance::BilansEntreprise::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI('https://ws-dlnuf.banque-france.fr/ws/BILAN_APIEntreprise_1_0_0_PRD/bilans/json')
  end

  def request_params
    {
      siren:
    }
  end

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
      cert:,
      key:
    }
  end

  private

  def siren
    context.params[:siren]
  end

  def key
    raw_key = File.read(Siade.credentials[:ssl_wildcard_certif_key_path])
    OpenSSL::PKey::RSA.new(raw_key)
  end

  def cert
    raw_cert = File.read(Siade.credentials[:ssl_wildcard_certif_crt_path])
    OpenSSL::X509::Certificate.new(raw_cert)
  end
end
