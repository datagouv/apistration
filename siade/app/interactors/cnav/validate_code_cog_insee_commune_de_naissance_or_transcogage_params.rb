class CNAV::ValidateCodeCogINSEECommuneDeNaissanceOrTranscogageParams < ValidateParamInteractor
  def call
    validator = call_validator

    return if validator.nil? || validator.success?

    context.errors = validator.errors
    mark_as_error!
  end

  private

  def call_validator
    if code_cog_insee_commune_de_naissance? || !france?
      CNAV::ValidateCodeCogINSEECommuneDeNaissance.call(params: context.params)
    elsif transcogage_params?
      INSEE::CommuneINSEECode::ValidateParams.call(params: context.params)
    else
      invalid_param!(:birth_place)
    end
  end

  def code_cog_insee_commune_de_naissance?
    params[:code_cog_insee_commune_de_naissance].present?
  end

  def transcogage_params?
    %i[nom_commune_naissance annee_date_de_naissance code_cog_insee_departement_de_naissance].all? { |key| context.params[key].present? }
  end

  def france?
    code_pays_lieu_de_naissance == '99100'
  end

  def code_pays_lieu_de_naissance
    param(:code_pays_lieu_de_naissance).to_s
  end
end
