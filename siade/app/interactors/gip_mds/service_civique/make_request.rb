class GIPMDS::ServiceCivique::MakeRequest < MakeRequest::Get
  SERVICE_CIVIQUE_CODE = '89'.freeze

  protected

  def request_uri
    URI("#{gip_mds_domain}/contrats-generique")
  end

  def mocking_params
    {
      nom: context.params[:nom_naissance],
      prenom: context.params[:prenoms]&.first,
      date_naissance: formatted_date_naissance
    }
  end

  def request_params
    {
      nom: context.params[:nom_naissance].upcase,
      prenom: context.params[:prenoms]&.first,
      dateNaissance: formatted_date_naissance,
      listeCodeNature: SERVICE_CIVIQUE_CODE,
      dateDebutPeriode: 5.years.ago.to_date.strftime('%Y-%m-%d')
    }
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
  end

  private

  def formatted_date_naissance
    format('%<day>02d%<month>02d%<year>s',
      day: context.params[:jour_date_naissance].to_i,
      month: context.params[:mois_date_naissance].to_i,
      year: context.params[:annee_date_naissance])
  end

  def token
    context.token
  end

  def gip_mds_domain
    Siade.credentials[:gip_mds_domain]
  end
end
