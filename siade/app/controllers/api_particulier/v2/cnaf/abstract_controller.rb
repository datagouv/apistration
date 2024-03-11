class APIParticulier::V2::CNAF::AbstractController < APIParticulierController
  include APIParticulier::FranceConnectable

  def show
    organizer = retrieve_payload_data(retriever, cache: true, expires_in: 1.hour)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def operation_id
    raise NotImplementedError
  end

  def retriever
    raise NotImplementedError
  end

  def organizer_params
    user_identity_params.merge(
      {
        annee: params[:annee],
        mois: params[:mois],
        request_id:
      }
    )
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
      date_naissance: france_connect_service_user_identity.birthdate,
      code_insee_lieu_de_naissance: france_connect_service_user_identity.birthplace,
      code_pays_lieu_de_naissance: france_connect_service_user_identity.birthcountry,
      gender: france_connect_service_user_identity.gender == 'male' ? 'M' : 'F',
      recipient: params[:recipient]
    }
  end

  def civility_params
    {
      nom_usage: params[:nomUsage],
      nom_naissance: params[:nomNaissance],
      prenoms: params[:prenoms],
      annee_date_de_naissance: params[:anneeDateDeNaissance],
      mois_date_de_naissance: params[:moisDateDeNaissance],
      jour_date_de_naissance: params[:jourDateDeNaissance],
      code_pays_lieu_de_naissance: params.require(:codePaysLieuDeNaissance),
      gender: params.require(:sexe),
      recipient: current_user.siret
    }.merge(code_insee_lieu_de_naissance_or_transcogage_params)
  end
  # rubocop:enable Metrics/AbcSize

  def code_insee_lieu_de_naissance_or_transcogage_params
    {
      code_insee_lieu_de_naissance: params[:codeInseeLieuDeNaissance],
      code_insee_departement_de_naissance: params[:codeInseeDepartementNaissance],
      nom_commune_naissance: params[:nomCommuneNaissance]
    }
  end

  def request_id
    request.request_id
  end
end
