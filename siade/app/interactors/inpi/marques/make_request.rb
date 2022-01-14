class INPI::Marques::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI([inpi_domain_opendata, 'api', 'marques', 'search'].join('/'))
  end

  def request_params
    {
      collections: %w[FR EU WO],
      query: "[ApplicantIdentifier=#{siren}]"
    }
  end

  private

  def inpi_domain_opendata
    Siade.credentials[:inpi_domain_opendata]
  end

  def siren
    context.params[:siren]
  end
end
