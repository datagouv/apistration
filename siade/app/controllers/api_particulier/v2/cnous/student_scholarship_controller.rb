class APIParticulier::V2::CNOUS::StudentScholarshipController < APIParticulier::V2::BaseController
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
    if france_connect?
      CNOUS::StudentScholarshipWithFranceConnect
    elsif call_with_ine?
      CNOUS::StudentScholarshipWithINE
    else
      CNOUS::StudentScholarshipWithCivility
    end
  end

  def organizer_params
    cnous_student_scholarship_params
  end

  def cnous_student_scholarship_params
    if france_connect?
      france_connect_service_user_identity_params
    elsif call_with_ine?
      ine_params
    else
      civility_params
    end
  end

  def call_with_ine?
    params[:ine].present?
  end

  def ine_params
    {
      ine: params[:ine]
    }
  end

  # rubocop:disable Metrics/AbcSize
  def civility_params
    {
      nom_naissance: params[:nom],
      prenoms: (params[:prenoms] || '').split,
      code_cog_insee_commune_naissance: params[:lieuDeNaissance],
      sexe_etat_civil: params[:sexe]
    }.merge(date_naissance)
  end

  def date_naissance
    {
      annee_date_naissance: params[:dateDeNaissance]&.split('-')&.first,
      mois_date_naissance: params[:dateDeNaissance]&.split('-')&.second,
      jour_date_naissance: params[:dateDeNaissance]&.split('-')&.third
    }
  end

  def france_connect_service_user_identity_params
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

  def format_not_found_error(error)
    {
      error: 'not_found',
      reason: 'Scholarship not found',
      message: error.detail
    }
  end

  def api_name
    'etudiant_boursier'
  end

  def organizer
    @organizer ||= retrieve_payload_data(extract_organizer_thanks_to_params)
  end
end
