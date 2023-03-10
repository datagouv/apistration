class APIEntreprise::V3AndMore::DGFIP::ChiffresAffairesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::DGFIP::ChiffresAffaires, cache: true)

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
      siret: params[:siret],
      user_id: current_user.id
    }
  end

  def serializer_module
    ::APIEntreprise::DGFIP::ChiffresAffairesCollectionSerializer
  end
end
