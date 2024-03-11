class INSEE::Metadonnees::MakeRequest < INSEE::MakeRequest
  def extra_headers(request)
    request['Accept'] = 'application/json'
    super(request)
  end

  def request_uri
    URI([base_uri, 'metadonnees', 'V1', 'geo', 'communes'].join('/'))
  end

  def request_params
    {
      date: "#{annee_date_de_naissance}-01-01",
      filtreNom: nom_commune_naissance,
      com: false
    }
  end

  private

  def annee_date_de_naissance
    context.params[:annee_date_de_naissance]
  end

  def nom_commune_naissance
    context.params[:nom_commune_naissance]
  end
end
