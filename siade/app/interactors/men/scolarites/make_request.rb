class MEN::Scolarites::MakeRequest < MakeRequest
  protected

  def request_uri
    if context.perimetre_type
      URI("#{Siade.credentials[:men_scolarites_url_v2]}/perimetre")
    else
      URI(Siade.credentials[:"men_scolarites_url_#{provider_api_version}"])
    end
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
    request['X-Siret-Partenaire'] = context.recipient if provider_api_version == 'v2'
    super
  end

  def mocking_params
    mocking_identity_params.merge(mocking_search_params).compact
  end

  def mocking_params_v2
    {
      nom: params[:nom_naissance],
      prenom:,
      sexe: params[:sexe_etat_civil].downcase,
      dateNaissance: date_naissance,
      codeEtablissement: params[:code_etablissement],
      anneeScolaire: params[:annee_scolaire]
    }
  end

  private

  def mocking_identity_params
    {
      nomNaissance: params[:nom_naissance],
      prenoms: params[:prenoms],
      sexeEtatCivil: params[:sexe_etat_civil]&.downcase,
      anneeDateNaissance: params[:annee_date_naissance],
      moisDateNaissance: params[:mois_date_naissance],
      jourDateNaissance: params[:jour_date_naissance],
      anneeScolaire: params[:annee_scolaire]
    }
  end

  def mocking_search_params
    if context.perimetre_type
      {
        degreEtablissement: params[:degre_etablissement],
        codesBcnDepartements: params[:codes_bcn_departements],
        codesBcnRegions: params[:codes_bcn_regions]
      }
    else
      { codeEtablissement: params[:code_etablissement] }
    end
  end

  def api_call
    if context.perimetre_type
      perimetre_api_call
    else
      etablissement_api_call
    end
  end

  def etablissement_api_call
    uri = request_uri
    uri.query = URI.encode_www_form(etablissement_request_params)
    context.request_url = uri.to_s

    context.response = http_wrapper do
      Net::HTTP::Get.new(uri)
    end
  end

  def perimetre_api_call
    context.response = http_wrapper do
      request = Net::HTTP::Post.new(request_uri)
      request.body = perimetre_request_params.to_json
      request
    end
  end

  def etablissement_request_params
    {
      nom: params[:nom_naissance],
      prenom:,
      sexe:,
      'date-naissance': date_naissance,
      'code-uai': params[:code_etablissement],
      'annee-scolaire': params[:annee_scolaire]
    }.merge(scope_param)
  end

  def perimetre_request_params
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

  def params
    context.params
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

  def provider_api_version
    params[:provider_api_version] || 'v2'
  end

  def scope_param
    return { scope: 'men_statut_scolarite' } if provider_api_version == 'v2'

    {}
  end
end
