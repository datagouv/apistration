class INPI::Brevets::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI([inpi_domain_opendata, 'api', 'brevets', 'search'].join('/'))
  end

  def request_params
    {
      collections: %w[FR EP WO CCP],
      query: "[TISI=#{siren}]"
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
