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
    code_cog = params[:codeCogInseeCommuneNaissance].presence

    if transcogage? && transcogage_params?
      extract_code_commune_organizer = INSEE::CommuneINSEECode.call(params: transcogage_params)

      code_cog ||= extract_code_commune_organizer.bundled_data.data.code_insee if extract_code_commune_organizer.success?
    end

    code_cog
  end

  def transcogage?
    raise NotImplementedError
  end

  private

  def transcogage_params
    @transcogage_params ||= {
      nom_commune_naissance: params[:nomCommuneNaissance],
      annee_date_naissance: params[:anneeDateNaissance],
      code_cog_insee_departement_naissance: params[:codeCogInseeDepartementNaissance]
    }
  end

  def transcogage_params?
    %i[nom_commune_naissance annee_date_naissance code_cog_insee_departement_naissance].all? { |key| transcogage_params[key].present? }
  end

  def civility_param(param)
    params[param]
  end

  def to_snake_case_sym(param)
    param.to_s.underscore.to_sym
  end
end
