class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::FranceConnectable

  def show
    organizer = retrieve_payload_data(MESRI::StudentStatus::WithCivility)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  # rubocop:disable Metrics/AbcSize
  def organizer_params
    {
      nom_naissance: france_connect_service_user_identity.family_name,
      prenoms: france_connect_service_user_identity.given_name.split.first,
      annee_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').first,
      mois_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').second,
      jour_date_de_naissance: france_connect_service_user_identity.birthdate.split('-').third,
      code_cog_insee_commune_de_naissance: france_connect_service_user_identity.birthplace,
      sexe_etat_civil: france_connect_service_user_identity.gender == 'male' ? 'M' : 'F',
      france_connect: true,
      token_id: current_user.token_id
    }
  end
  # rubocop:enable Metrics/AbcSize

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end
end
