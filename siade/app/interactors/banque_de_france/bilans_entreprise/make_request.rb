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
    http_wildcard_ssl_options.merge(
      cert_store: custom_cert_store
    )
  end

  def custom_cert_store
    cert_store = OpenSSL::X509::Store.new
    cert_store.add_file(Rails.root.join('config/certificates/certification-authority-banque-de-france.pem').to_s)
    cert_store
  end

  private

  def siren
    context.params[:siren]
  end
end
