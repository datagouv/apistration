class APIParticulier::V2::CNOUS::StudentScholarshipController < APIParticulierController
  include APIParticulier::FranceConnectable

  def show
    authorize :cnous_statut_boursier,
      :cnous_echelon_bourse,
      :cnous_email,
      :cnous_periode_versement,
      :cnous_statut_bourse,
      :cnous_ville_etudes,
      :cnous_identite

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
    if france_connect?
      CNOUS::StudentScholarshipWithFranceConnect
    elsif call_with_ine?
      CNOUS::StudentScholarshipWithINE
    else
      CNOUS::StudentScholarshipWithCivility
    end
  end

  def organizer_params
    cnous_student_scholarship_params.merge(
      user_id: current_user.id
    )
  end

  def cnous_student_scholarship_params
    if france_connect?
      france_connect_service_user_identity.to_h
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

  def civility_params
    {
      family_name: params[:nom],
      first_names: params[:prenoms].split,
      birthday_date: params[:dateDeNaissance],
      birthday_place: params[:lieuDeNaissance],
      gender: params[:sexe]
    }
  end

  def format_not_found_error(error)
    {
      error: 'not_found',
      reason: 'Student situation not found',
      message: error.detail
    }
  end
end
