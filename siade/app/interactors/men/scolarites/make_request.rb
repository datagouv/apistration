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
    super
  end

  def mocking_params
    {
      nom: context.params[:family_name],
      prenom: context.params[:first_name],
      sexe: context.params[:gender].downcase,
      dateNaissance: context.params[:birth_date],
      codeEtablissement: context.params[:code_etablissement],
      anneeScolaire: context.params[:annee_scolaire]
    }
  end

  private

  def sexe
    case context.params[:gender].downcase
    when 'm'
      1
    when 'f'
      2
    else
      raise 'Invalid gender sent to MakeRequest'
    end
  end
end
