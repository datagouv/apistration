module APIParticulier::CivilityParameters
  # rubocop:disable Metrics/MethodLength
  def civility_parameters
    civility = {}
    %i[
      nomUsage
      nomNaissance
      prenoms
      anneeDateNaissance
      moisDateNaissance
      jourDateNaissance
      sexeEtatCivil
      nomCommuneNaissance
      codeCogInseePaysNaissance
      codeCogInseeDepartementNaissance
    ].each do |param|
      civility[to_snake_case_sym(param)] = civility_param(param)
    end

    civility[:code_cog_insee_commune_naissance] = extract_code_cog_insee_commune_naissance

    civility
  end
  # rubocop:enable Metrics/MethodLength

  protected

  def extract_code_cog_insee_commune_naissance
    params[:codeCogInseeCommuneNaissance].presence
  end

  private

  def civility_param(param)
    params[param]
  end

  def to_snake_case_sym(param)
    param.to_s.underscore.to_sym
  end
end
