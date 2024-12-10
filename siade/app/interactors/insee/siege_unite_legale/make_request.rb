class INSEE::SiegeUniteLegale::MakeRequest < INSEE::MakeRequest
  protected

  def request_uri
    URI([base_uri, sirene_base_path, 'siret'].join('/'))
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
