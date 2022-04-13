class OPQIBI::CertificationsIngenierie::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{opqibi_domain}/certificats/#{siren}")
  end

  def request_params
    {}
  end

  private

  def opqibi_domain
    Siade.credentials[:opqibi_domain]
  end

  def siren
    context.params[:siren]
  end
end
