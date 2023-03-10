class APIEntreprise::V3AndMore::DGFIP::LiassesFiscalesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::DGFIP::LiassesFiscales, cache: true)

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
      siren: params[:siren],
      year: params[:year],
      user_id: current_user.id
    }
  end

  def serializer_module
    ::APIEntreprise::DGFIP::LiassesFiscalesSerializer
  end
end
