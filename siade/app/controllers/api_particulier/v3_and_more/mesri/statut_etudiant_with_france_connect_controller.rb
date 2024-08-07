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

  def organizer_params
    {
      family_name: france_connect_service_user_identity.family_name,
      first_name: france_connect_service_user_identity.given_name.split.first,
      birth_date: france_connect_service_user_identity.birthdate,
      birth_place: france_connect_service_user_identity.birthplace,
      gender: france_connect_service_user_identity.gender == 'male' ? 'm' : 'f',
      france_connect: true,
      token_id: current_user.token_id
    }
  end

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end
end
