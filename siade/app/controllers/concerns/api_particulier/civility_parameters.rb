module APIParticulier::CivilityParameters
  # rubocop:disable Metrics/MethodLength
  def civility_parameters(requireds: [])
    civility = {}
    %i[
      nomUsage
      nomNaissance
      prenoms
      anneeDateDeNaissance
      moisDateDeNaissance
      jourDateDeNaissance
      sexeEtatCivil
      nomCommuneNaissance
      codePaysLieuDeNaissance
    ].each do |param|
      civility[to_snake_case_sym(param)] = civility_param(param, required?(param, requireds))
    end

    civility[:code_cog_insee_commune_de_naissance] = extract_code_cog_insee_commune_de_naissance(required?(:codeCogInseeCommuneDeNaissance, requireds))

    civility
  end
  # rubocop:enable Metrics/MethodLength

  def civility_parameters_from_france_connect
    {
      nom_usage: france_connect_service_user_identity.preferred_username,
      nom_naissance: france_connect_service_user_identity.family_name,
      prenoms: france_connect_service_user_identity.given_name.split,
      annee_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').first,
      mois_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').second,
      jour_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').third,
      code_cog_insee_commune_de_naissance: france_connect_service_user_identity.birthplace,
      code_pays_lieu_de_naissance: france_connect_service_user_identity.birthcountry,
      sexe_etat_civil: france_connect_service_user_identity.gender == 'male' ? 'M' : 'F',
      france_connect: true
    }
  end

  protected

  def required?(param, required)
    required.include?(param)
  end

  def extract_code_cog_insee_commune_de_naissance(required)
    code_cog = params[:codeCogInseeCommuneDeNaissance].presence

    if transcogage? && transcogage_params?
      extract_code_commune_organizer = INSEE::CommuneINSEECode.call(params: transcogage_params)

      code_cog ||= extract_code_commune_organizer.bundled_data.data.code_insee if extract_code_commune_organizer.success?
    end

    return code_cog unless required && code_cog.blank?

    raise ActionController::ParameterMissing, 'codeCogInseeCommuneDeNaissance'
  end

  def transcogage?
    raise NotImplementedError
  end

  private

  def transcogage_params
    @transcogage_params ||= {
      nom_commune_naissance: params[:nomCommuneNaissance],
      annee_date_de_naissance: params[:anneeDateDeNaissance],
      code_cog_insee_departement_de_naissance: params[:codeCogInseeDepartementDeNaissance]
    }
  end

  def transcogage_params?
    %i[nom_commune_naissance annee_date_de_naissance code_cog_insee_departement_de_naissance].all? { |key| transcogage_params[key].present? }
  end

  def civility_param(param, required)
    if required
      params.require(param)
    else
      params[param]
    end
  end

  def to_snake_case_sym(param)
    param.to_s.underscore.to_sym
  end
end
