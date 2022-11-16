class BanqueDeFrance::BilansEntreprise::MakeRequest < MakeRequest::Get
  include UseWildcardSSLCertificate

  protected

  def request_uri
    URI(Siade.credentials[:banque_de_france_bilans_url])
  end

  def request_params
    {
      siren:
    }
  end

  def http_options
    http_wildcard_ssl_options
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
