class INSEE::SiegeUniteLegale::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI([base_uri, 'entreprises', 'sirene', 'siret'].join('/'))
  end

  def request_params
    {
      q: ['etablissementSiege:true', "siren:#{siren}"].join(' AND ')
    }
  end

  def set_headers(request)
    request['Authorization'] = "Bearer #{token}"
    super(request)
  end

  private

  def siren
    context.params[:siren]
  end

  def token
    context.token
  end

  def base_uri
    Siade.credentials[:insee_v3_domain]
  end
end
