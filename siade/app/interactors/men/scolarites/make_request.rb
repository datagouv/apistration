class MEN::Scolarites::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:men_scolarites_url])
  end

  def request_params
    {
      nom: context.params[:family_name],
      prenom: context.params[:first_name],
      sexe:,
      'date-naissance': context.params[:birth_date],
      'code-uai': context.params[:code_etablissement],
      'annee-scolaire': context.params[:annee_scolaire]
    }
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
    super(request)
  end

  private

  def sexe
    case context.params[:gender]
    when 'm'
      1
    when 'f'
      2
    else
      raise 'Invalid gender sent to MakeRequest'
    end
  end
end
