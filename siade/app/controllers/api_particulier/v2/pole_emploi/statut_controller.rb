class APIParticulier::V2::PoleEmploi::StatutController < APIParticulier::V2::BaseController
  def show
    organizer = retrieve_payload_data(::FranceTravail::Statut)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def cache_key
    "#{request.path}:#{params[:identifiant]}"
  end

  def organizer_params
    {
      identifiant: params[:identifiant],
      user_id: current_user.id
    }
  end

  def format_not_found_error(error)
    {
      error: 'not_found',
      reason: 'Situation not found',
      message: error.detail
    }
  end
end
