class CNAV::ValidateCodeINSEELieuDeNaissanceOrTranscogageParams < ValidateParamInteractor
  def call
    validator = call_validator

    return if validator.nil? || validator.success?

    context.errors = validator.errors
    mark_as_error!
  end

  private

  def call_validator
    if code_insee_lieu_de_naissance?
      CNAV::ValidateCodeINSEELieuDeNaissance.call(params: context.params)
    elsif transcogage_params?
      INSEE::CommuneINSEECode::ValidateParams.call(params: context.params)
    else
      invalid_param!(:birth_place)
    end
  end

  def code_insee_lieu_de_naissance?
    params[:code_insee_lieu_de_naissance].present?
  end

  def transcogage_params?
    %i[nom_commune_naissance annee_date_de_naissance code_insee_departement_de_naissance].all? { |key| context.params[key].present? }
  end
end
