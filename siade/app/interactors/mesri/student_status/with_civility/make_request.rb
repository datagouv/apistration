class MESRI::StudentStatus::WithCivility::MakeRequest < MakeRequest::Post
  include MESRI::StudentStatus::MakeRequestCommons

  protected

  def mocking_params_v2
    if context.params[:france_connect]
      france_connect_mocking_params
    else
      civility_mocking_params
    end
  end

  # rubocop:disable Metrics/AbcSize
  def mocking_params
    {
      nomNaissance: nom_naissance,
      prenom:,
      anneeDateNaissance: context.params[:annee_date_naissance].to_i,
      moisDateNaissance: context.params[:mois_date_naissance].to_i,
      jourDateNaissance: context.params[:jour_date_naissance].to_i,
      sexeEtatCivil: sexe_etat_civil.downcase,
      codeCogInseeCommuneNaissance: code_cog_insee_commune_naissance
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  def france_connect_mocking_params
    {
      given_name: prenom,
      family_name: nom_naissance,
      birthdate: date_naissance,
      birthplace: code_cog_insee_commune_naissance,
      gender: sexe_etat_civil.downcase == 'm' ? 'male' : 'female'
    }
  end

  def civility_mocking_params
    {
      nom: nom_naissance,
      prenoms: context.params[:prenoms],
      dateDeNaissance: date_naissance,
      lieuDeNaissance: code_cog_insee_commune_naissance,
      sexe: sexe_etat_civil
    }
  end

  def request_params
    {
      nomFamille: nom_naissance,
      prenom1: prenom,
      dateNaissance: date_naissance,
      sexe: sexe_etat_civil.downcase == 'm' ? '1' : '2',
      lieuNaissance: code_cog_insee_commune_naissance.presence
    }.compact
  end

  def api_key
    Siade.credentials[:mesri_student_status_token_with_civility]
  end

  private

  def nom_naissance
    context.params[:nom_naissance]
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

  def code_cog_insee_commune_naissance
    context.params[:code_cog_insee_commune_naissance]
  end

  def sexe_etat_civil
    context.params[:sexe_etat_civil]
  end
end
