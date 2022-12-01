class APIParticulier::V2::MESRI::StudentStatusController < APIParticulierController
  include APIParticulier::FranceConnectable

  def show
    authorize :mesri_identifiant, :mesri_identite, :mesri_inscription_etudiant, :mesri_inscription_autre, :mesri_admission, :mesri_etablissements

    organizer = extract_organizer_thanks_to_params.call(params: organizer_params)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def extract_organizer_thanks_to_params
    if call_with_ine? && !france_connect?
      MESRI::StudentStatusWithINE
    else
      MESRI::StudentStatusWithCivility
    end
  end

  def organizer_params
    mesri_student_status_params.merge(
      token_id: current_user.token_id
    )
  end

  def mesri_student_status_params
    if france_connect?
      mesri_student_civility_params_from_france_connect_service_user_identity
    elsif call_with_ine?
      {
        ine: params[:ine]
      }
    else
      {
        family_name: params[:nom],
        first_name: params[:prenom],
        birthday_date: params[:dateDeNaissance],
        birth_place: params[:lieuDeNaissance],
        gender: params[:sexe]
      }
    end
  end

  def mesri_student_civility_params_from_france_connect_service_user_identity
    {
      family_name: france_connect_service_user_identity.family_name,
      first_name: extract_first_first_name_from_france_connect_given_name(france_connect_service_user_identity.given_name),
      birthday_date: france_connect_service_user_identity.birthdate,
      birth_place: france_connect_service_user_identity.birthplace,
      gender: france_connect_service_user_identity.gender == 'male' ? 'm' : 'f'
    }
  end

  def call_with_ine?
    params[:ine].present?
  end

  def format_not_found_error(error)
    {
      error: 'not_found',
      reason: 'Student not found',
      message: error.detail
    }
  end

  def extract_first_first_name_from_france_connect_given_name(given_name)
    given_name.split.first
  end
end
