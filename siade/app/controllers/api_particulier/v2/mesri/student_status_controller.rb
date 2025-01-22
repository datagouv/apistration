class APIParticulier::V2::MESRI::StudentStatusController < APIParticulier::V2::BaseController
  include APIParticulier::FranceConnectable

  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def extract_organizer_thanks_to_params
    if call_with_ine? && !france_connect?
      MESRI::StudentStatus::WithINE
    else
      MESRI::StudentStatus::WithCivility
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
      mesri_student_civility_params
    end
  end

  # rubocop:disable Metrics/AbcSize
  def mesri_student_civility_params
    {
      nom_naissance: params[:nom],
      prenoms: [params[:prenom]],
      annee_date_naissance: date_of_birth_param.split('-').first,
      mois_date_naissance: date_of_birth_param.split('-').second,
      jour_date_naissance: date_of_birth_param.split('-').third,
      code_cog_insee_commune_naissance: params[:lieuDeNaissance],
      sexe_etat_civil: params[:sexe]
    }
  end

  def mesri_student_civility_params_from_france_connect_service_user_identity
    {
      nom_naissance: france_connect_service_user_identity.family_name,
      prenoms: france_connect_service_user_identity.given_name.split,
      annee_date_naissance: france_connect_service_user_identity.birthdate.split('-').first,
      mois_date_naissance: france_connect_service_user_identity.birthdate.split('-').second,
      jour_date_naissance: france_connect_service_user_identity.birthdate.split('-').third,
      code_cog_insee_commune_naissance: france_connect_service_user_identity.birthplace,
      sexe_etat_civil: france_connect_service_user_identity.gender == 'male' ? 'M' : 'F',
      france_connect: true
    }
  end
  # rubocop:enable Metrics/AbcSize

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

  def date_of_birth_param
    params[:dateDeNaissance] || ''
  end

  def extract_first_first_name_from_france_connect_given_name(given_name)
    given_name.split.first
  end

  def api_name
    'statut_etudiant'
  end

  def organizer
    @organizer ||= retrieve_payload_data(extract_organizer_thanks_to_params)
  end
end
