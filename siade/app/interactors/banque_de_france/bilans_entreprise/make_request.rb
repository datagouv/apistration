class BanqueDeFrance::BilansEntreprise::MakeRequest < MakeRequest::Get
  include UseWildcardSSLCertificate

  protected

  def request_uri
    URI("#{bdf_url}/#{siren}")
  end

  def request_params
    {}
  end

  def http_options
    http_wildcard_ssl_options
  end

  private

  def bdf_url
    Siade.credentials[:banque_de_france_bilans_url]
  end

  def siren
    context.params[:siren]
  end
end
