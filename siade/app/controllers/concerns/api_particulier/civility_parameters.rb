module APIParticulier::CivilityParameters
  CIVILITY_SCALAR_KEYS = %i[
    nomUsage
    nomNaissance
    anneeDateNaissance
    moisDateNaissance
    jourDateNaissance
    sexeEtatCivil
    nomCommuneNaissance
    codeCogInseePaysNaissance
    codeCogInseeDepartementNaissance
  ].freeze

  CIVILITY_KEYS = (CIVILITY_SCALAR_KEYS + %i[prenoms]).freeze

  def civility_parameters
    civility = {}
    CIVILITY_KEYS.each do |param|
      civility[to_snake_case_sym(param)] = civility_param(param)
    end

    civility[:code_cog_insee_commune_naissance] = extract_code_cog_insee_commune_naissance

    civility
  end

  protected

  def extract_code_cog_insee_commune_naissance
    permitted_civility_params[:codeCogInseeCommuneNaissance].presence
  end

  private

  def permitted_civility_params
    @permitted_civility_params ||= params.permit(
      *CIVILITY_SCALAR_KEYS,
      :codeCogInseeCommuneNaissance,
      prenoms: []
    )
  end

  def civility_param(param)
    permitted_civility_params[param]
  end

  def to_snake_case_sym(param)
    param.to_s.underscore.to_sym
  end
end
