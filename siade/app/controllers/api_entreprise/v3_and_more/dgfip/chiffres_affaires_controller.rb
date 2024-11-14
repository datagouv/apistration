class APIEntreprise::V3AndMore::DGFIP::ChiffresAffairesController < APIEntreprise::V3AndMore::BaseController
  include APIEntreprise::CommonDGFIPOrganizerParams

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
    common_dgfip_organizer_params.merge(
      siret: params[:siret]
    )
  end

  def serializer_module
    ::APIEntreprise::DGFIP::ChiffresAffairesCollectionSerializer
  end
end
