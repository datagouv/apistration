class APIParticulier::V2::PoleEmploi::IndemnitesController < APIParticulier::V2::BaseController
  def show
    organizer = retrieve_payload_data(::FranceTravail::Indemnites)

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
      identifiant: params[:identifiant],
      user_id: current_user.id
    }
  end
end
