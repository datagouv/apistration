class MEN::ScolaritesPerimetre::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI("#{Siade.credentials[:men_scolarites_url_v2]}/perimetre")
  end

  def request_params
    {
      nom: params[:nom_naissance],
      prenom:,
      sexe:,
      'date-naissance': date_naissance,
      'annee-scolaire': params[:annee_scolaire],
      scope: 'men_statut_scolarite',
      'degre-etablissement': params[:degre_etablissement],
      'type-perimetre': context.perimetre_type,
      'valeurs-perimetre': context.perimetre_valeurs
    }
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
    request['X-Siret-Partenaire'] = context.recipient
    super
  end

  def mocking_params
    mocking_identity_params.merge(mocking_search_params).compact
  end

  private

  def params
    context.params
  end

  def mocking_identity_params
    {
      nomNaissance: params[:nom_naissance],
      prenoms: params[:prenoms],
      sexeEtatCivil: params[:sexe_etat_civil]&.downcase,
      anneeDateNaissance: params[:annee_date_naissance],
      moisDateNaissance: params[:mois_date_naissance],
      jourDateNaissance: params[:jour_date_naissance]
    }
  end

  def mocking_search_params
    {
      anneeScolaire: params[:annee_scolaire],
      degreEtablissement: params[:degre_etablissement],
      codesBcnDepartements: params[:codes_bcn_departements],
      codesBcnRegions: params[:codes_bcn_regions]
    }
  end

  def sexe
    case params[:sexe_etat_civil]&.downcase
    when 'm' then 1
    when 'f' then 2
    else raise 'Invalid sexe_etat_civil sent to MakeRequest'
    end
  end

  def prenom
    params[:prenoms].first
  end

  def date_naissance
    Civility::FormatDateNaissance.new(
      params[:annee_date_naissance],
      params[:mois_date_naissance],
      params[:jour_date_naissance]
    ).format
  end
end
