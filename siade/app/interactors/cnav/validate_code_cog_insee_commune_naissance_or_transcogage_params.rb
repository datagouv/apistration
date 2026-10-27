class CNAV::ValidateCodeCogINSEECommuneNaissanceOrTranscogageParams < ValidateParamInteractor
  TRANSCOGAGE_PARAMS = %i[nom_commune_naissance annee_date_naissance code_cog_insee_departement_naissance].freeze

  delegates_to CNAV::ValidateCodeCogINSEECommuneNaissance,
    CNAV::ValidateTranscogageParams

  def call
    validator = call_validator

    return if validator.nil? || validator.success?

    context.errors = validator.errors
    mark_as_error!
  end

  private

  def call_validator
    if code_cog_insee_commune_naissance?
      CNAV::ValidateCodeCogINSEECommuneNaissance.call(params: context.params)
    elsif transcogage_params? || born_in_france_with_partial_transcogage?
      CNAV::ValidateTranscogageParams.call(params: context.params)
    end
  end

  def code_cog_insee_commune_naissance?
    params[:code_cog_insee_commune_naissance].present?
  end

  def transcogage_params?
    TRANSCOGAGE_PARAMS.all? { |key| context.params[key].present? }
  end

  def born_in_france_with_partial_transcogage?
    param(:code_cog_insee_pays_naissance).to_s == '99100' &&
      %i[nom_commune_naissance code_cog_insee_departement_naissance].any? { |key| context.params[key].present? }
  end
end
