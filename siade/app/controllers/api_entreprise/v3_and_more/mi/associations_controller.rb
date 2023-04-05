class APIEntreprise::V3AndMore::MI::AssociationsController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::MI::Associations, cache: true, expires_in: 1.hour)

    if organizer.success?
      render json:   serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      id: params.require(:siret_or_rna)
    }
  end

  def serializer_module
    ::APIEntreprise::MI::AssociationSerializer
  end
end
