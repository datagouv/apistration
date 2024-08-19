module APIParticulier::CivilityParameters
  def civility_parameters(required: [])
    civility = {}
    %i[
      nomNaissance
      prenoms
      anneeDateDeNaissance
      moisDateDeNaissance
      jourDateDeNaissance
      sexeEtatCivil
    ].each do |param|
      civility[to_snake_case_sym(param)] = civility_param(param, required)
    end

    civility
  end

  # rubocop:disable Metrics/AbcSize
  def civility_parameters_from_france_connect
    {
      nom_naissance: france_connect_service_user_identity.family_name,
      prenoms: france_connect_service_user_identity.given_name.split,
      annee_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').first,
      mois_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').second,
      jour_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').third,
      code_cog_insee_commune_de_naissance: france_connect_service_user_identity.birthplace,
      sexe_etat_civil: france_connect_service_user_identity.gender == 'male' ? 'M' : 'F',
      france_connect: true
    }
  end
  # rubocop:enable Metrics/AbcSize

  private

  def civility_param(param, required)
    if required.include?(param)
      params.require(param)
    else
      params[param]
    end
  end

  def to_snake_case_sym(param)
    param.to_s.underscore.to_sym
  end
end
