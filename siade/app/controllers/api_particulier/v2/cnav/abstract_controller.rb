class APIParticulier::V2::CNAV::AbstractController < APIParticulier::V2::BaseController
  include APIParticulier::FranceConnectable

  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def cache_key
    "#{request.path}:#{user_identity_params.to_query}"
  end

  def operation_id
    raise NotImplementedError
  end

  def retriever
    raise NotImplementedError
  end

  def organizer_params
    user_identity_params.merge({ request_id: })
  end

  def user_identity_params
    if france_connect?
      france_connect_service_user_identity_params
    else
      civility_params
    end
  end

  # rubocop:disable Metrics/AbcSize
  def france_connect_service_user_identity_params
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
      recipient: params[:recipient],
      france_connect: true
    }
  end

  def civility_params
    {
      nom_usage: params[:nomUsage],
      nom_naissance: params[:nomNaissance],
      prenoms: params[:prenoms],
      annee_date_naissance: params[:anneeDateDeNaissance],
      mois_date_naissance: params[:moisDateDeNaissance],
      jour_date_naissance: params[:jourDateDeNaissance],
      code_cog_insee_pays_naissance: params[:codePaysLieuDeNaissance],
      code_cog_insee_commune_naissance: params[:codeInseeLieuDeNaissance],
      code_cog_insee_departement_naissance: params[:codeInseeDepartementNaissance],
      nom_commune_naissance: params[:nomCommuneNaissance],
      sexe_etat_civil: params[:sexe],
      recipient: current_user.siret
    }
  end
  # rubocop:enable Metrics/AbcSize

  def request_id
    request.request_id
  end

  def expires_in
    1.hour
  end

  def organizer
    @organizer ||= retrieve_payload_data(retriever, cache: true, expires_in:)
  end
end
