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
    ].each do |param|
      civility[to_snake_case_sym(param)] = civility_param(param)
    end

    civility[:code_cog_insee_commune_naissance] = extract_code_cog_insee_commune_naissance

    civility
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize
  def civility_parameters_from_france_connect(except: [])
    {
      nom_usage: france_connect_service_user_identity.preferred_username,
      nom_naissance: france_connect_service_user_identity.family_name,
      prenoms: france_connect_service_user_identity.given_name.split,
      annee_date_naissance: france_connect_service_user_identity.birthdate.split('-').first,
      mois_date_naissance: france_connect_service_user_identity.birthdate.split('-').second,
      jour_date_naissance: france_connect_service_user_identity.birthdate.split('-').third,
      code_cog_insee_commune_naissance: france_connect_service_user_identity.birthplace,
      code_cog_insee_pays_naissance: france_connect_service_user_identity.birthcountry,
      sexe_etat_civil: france_connect_service_user_identity.gender == 'male' ? 'M' : 'F',
      france_connect: true
    }.except(*except)
  end
  # rubocop:enable Metrics/AbcSize

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
