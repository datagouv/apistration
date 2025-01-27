class INSEE::Metadonnees::MakeRequest < MakeRequest::Get
  def extra_headers(request)
    request['Accept'] = 'application/json'
    super
  end

  def request_uri
    URI([base_url, 'geo', 'communes'].join('/'))
  end

  def request_params
    {
      date: "#{annee_date_naissance}-01-01",
      filtreNom: nom_commune_naissance,
      com: false
    }
  end

  def extra_http_start_options
    {
      open_timeout: 5,
      read_timeout: 5
    }
  end

  private

  def base_url
    Siade.credentials[:insee_metadata_url]
  end

  def annee_date_naissance
    context.params[:annee_date_naissance]
  end

  def nom_commune_naissance
    context.params[:nom_commune_naissance]
  end
end
