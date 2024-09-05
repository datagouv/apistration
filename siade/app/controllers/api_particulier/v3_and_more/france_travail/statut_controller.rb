class APIParticulier::V3AndMore::FranceTravail::StatutController < APIParticulier::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::FranceTravail::Statut)

    if organizer.success?
      render json: serialize_data(organizer), status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      identifiant_pole_emploi: params[:identifiant],
      user_id: current_user.id
    }
  end

  def serializer_module
    ::APIParticulier::FranceTravail::StatutSerializer
  end
end
