class MESRI::Scolarite::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:mesri_scolarite_url])
  end

  def request_params
    {
      nom: context.params[:nom],
      prenom: context.params[:prenom],
      sexe: context.params[:sexe],
      'date-naissance': context.params[:date_naissance],
      'code-uai': context.params[:code_etablissement],
      'annee-scolaire': context.params[:annee_scolaire]
    }
  end

  def set_headers(request)
    request['Authorization'] = "Bearer #{context.access_token}"
    super(request)
  end
end
