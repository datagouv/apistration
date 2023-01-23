class APIEntreprise::V3AndMore::MI::DocumentsAssociationsController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::MI::Associations::Documents)

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
      id: params.require(:siret_or_rna)
    }
  end

  def serializer_module
    ::APIEntreprise::MI::DocumentAssociationSerializer
  end
end
