class APIParticulier::V2::PoleEmploi::StatutController < APIParticulierController
  def show
    authorize :pole_emploi_identite, :pole_emploi_adresse, :pole_emploi_contact, :pole_emploi_inscription

    organizer = ::PoleEmploi::Statut.call(params: organizer_params)

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
