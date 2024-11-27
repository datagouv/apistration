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
end
