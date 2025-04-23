class MEN::Scolarites::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:"men_scolarites_url_#{provider_api_version}"])
  end

  def request_params
    {
      nom: context.params[:nom_naissance],
      prenom:,
      sexe:,
      'date-naissance': date_naissance,
      'code-uai': context.params[:code_etablissement],
      'annee-scolaire': context.params[:annee_scolaire]
    }
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
    request['X-Siret-Partenaire'] = (context.params.fetch(:recipient) || JwtTokenService::DINUM_SIRET) if provider_api_version == 'v2'

    super
  end

  # rubocop:disable Metrics/AbcSize
  def mocking_params
    {
      nomNaissance: context.params[:nom_naissance],
      prenoms: context.params[:prenoms],
      sexeEtatCivil: context.params[:sexe_etat_civil].downcase,
      anneeDateNaissance: context.params[:annee_date_naissance],
      moisDateNaissance: context.params[:mois_date_naissance],
      jourDateNaissance: context.params[:jour_date_naissance],
      codeEtablissement: context.params[:code_etablissement],
      anneeScolaire: context.params[:annee_scolaire]
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  def mocking_params_v2
    {
      nom: context.params[:nom_naissance],
      prenom:,
      sexe: context.params[:sexe_etat_civil].downcase,
      dateNaissance: date_naissance,
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

  def date_naissance
    Civility::FormatDateNaissance.new(
      context.params[:annee_date_naissance],
      context.params[:mois_date_naissance],
      context.params[:jour_date_naissance]
    ).format
  end

  def provider_api_version
    context.params[:provider_api_version] || 'v2'
  end
end
