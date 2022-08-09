class APIParticulier::V2::MESRI::StudentStatusController < APIParticulierController
  def show
    authorize :mesri_identifiant, :mesri_identite, :mesri_inscription_etudiant, :mesri_inscription_autre, :mesri_admission, :mesri_etablissements

    organizer = ::MESRI::StudentStatusWithINE.call(params: organizer_params)

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
      ine: params[:ine],
      user_id: current_user.id
    }
  end

  def format_not_found_error(error)
    {
      error: 'not_found',
      reason: 'Student not found',
      message: error.detail
    }
  end
end
