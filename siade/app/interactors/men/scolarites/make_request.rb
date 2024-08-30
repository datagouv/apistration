class MEN::Scolarites::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:men_scolarites_url])
  end

  def request_params
    {
      nom: context.params[:nom_naissance],
      prenom:,
      sexe:,
      'date-naissance': date_de_naissance,
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
      nom: context.params[:nom_naissance],
      prenom:,
      sexe: context.params[:sexe_etat_civil].downcase,
      dateNaissance: date_de_naissance,
      codeEtablissement: context.params[:code_etablissement],
      anneeScolaire: context.params[:annee_scolaire]
    }
  end

  private

  def sexe
    case context.params[:sexe_etat_civil].downcase
    when 'm'
      1
    when 'f'
      2
    else
      raise 'Invalid sexe_etat_civil sent to MakeRequest'
    end
  end

  def prenom
    context.params[:prenoms].first
  end

  def date_de_naissance
    Civility::FormatDateDeNaissance.new(
      context.params[:annee_date_de_naissance],
      context.params[:mois_date_de_naissance],
      context.params[:jour_date_de_naissance]
    ).format
  end
end
