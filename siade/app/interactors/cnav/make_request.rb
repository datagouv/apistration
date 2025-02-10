class CNAV::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:"cnav_#{context.dss_prestation_name}_url"])
  end

  # rubocop:disable Metrics/AbcSize
  def mocking_params
    {
      nomNaissance: context.params[:nom_naissance],
      nomUsage: context.params[:nom_usage],
      prenoms: context.params[:prenoms],
      anneeDateNaissance: int_or_nil(date_naissance.split('-').first.to_i),
      moisDateNaissance: int_or_nil(date_naissance.split('-').second.to_i),
      jourDateNaissance: int_or_nil(date_naissance.split('-').last.to_i),
      sexeEtatCivil: context.params[:sexe_etat_civil],
      codeCogInseePaysNaissance: context.params[:code_cog_insee_pays_naissance],
      codeCogInseeCommuneNaissance: code_cog_insee_commune_de_naissance,
      nomCommuneNaissance: context.params[:nom_commune_naissance],
      codeCogInseeDepartementNaissance: context.params[:code_cog_insee_departement_naissance]
    }.compact
  end

  def mocking_params_v2
    {
      nomUsage: context.params[:nom_usage],
      nomNaissance: context.params[:nom_naissance],
      prenoms: context.params[:prenoms],
      anneeDateDeNaissance: int_or_nil(date_naissance.split('-').first.to_i),
      moisDateDeNaissance: int_or_nil(date_naissance.split('-').second.to_i),
      jourDateDeNaissance: int_or_nil(date_naissance.split('-').last.to_i),
      codeInseeLieuDeNaissance: code_cog_insee_commune_de_naissance,
      codePaysLieuDeNaissance: context.params[:code_cog_insee_pays_naissance],
      sexe: context.params[:sexe_etat_civil],
      nomCommuneNaissance: context.params[:nom_commune_naissance],
      codeCogInseeDepartementNaissance: context.params[:code_cog_insee_departement_naissance]
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['X-Correlation-ID'] = context.params[:request_id]
    request['X-APIPART-FSFINAL'] = context.params[:recipient]
  end

  # rubocop:disable Metrics/AbcSize
  def request_params
    {
      nomUsage: context.params[:nom_usage],
      nomNaissance: context.params[:nom_naissance],
      listePrenoms: liste_prenoms,
      dateNaissance: date_naissance,
      codeLieuNaissance: code_cog_insee_commune_de_naissance,
      codePaysNaissance: context.params[:code_cog_insee_pays_naissance],
      villeNaissance: context.params[:nom_commune_naissance],
      depNaissance: context.params[:code_cog_insee_departement_naissance],
      genre: context.params[:sexe_etat_civil].upcase
    }.compact
  end
  # rubocop:enable Metrics/AbcSize

  private

  def token
    context.token
  end

  def liste_prenoms
    context.params[:prenoms].try(:join, ' ')
  end

  def date_naissance
    Civility::FormatDateNaissance.new(
      context.params[:annee_date_naissance],
      context.params[:mois_date_naissance],
      context.params[:jour_date_naissance]
    ).format
  end

  def int_or_nil(value)
    value.to_i.zero? ? nil : value.to_i
  end

  def code_cog_insee_commune_de_naissance
    return nil unless country_is_france?

    context.params[:code_cog_insee_commune_naissance]
  end

  def country_is_france?
    context.params[:code_cog_insee_pays_naissance] == '99100'
  end
end
