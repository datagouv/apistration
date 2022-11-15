class PROBTP::MakeRequest < MakeRequest::Post
  include UseWildcardSSLCertificate

  protected

  def request_params
    {
      corps: siret
    }
  end

  def http_options
    http_wildcard_ssl_options
  end

  def probtp_domain
    Siade.credentials[:probtp_domain]
  end

  private

  def siret
    context.params[:siret]
  end
end
