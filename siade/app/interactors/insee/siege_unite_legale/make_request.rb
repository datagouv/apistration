class INSEE::SiegeUniteLegale::MakeRequest < INSEE::MakeRequest
  protected

  def request_uri
    URI([base_uri, 'entreprises', 'sirene', 'siret'].join('/'))
  end

  def request_params
    {
      q: ['etablissementSiege:true', "siren:#{siren}"].join(' AND ')
    }
  end

  private

  def siren
    context.params[:siren]
  end
end
