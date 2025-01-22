class APIEntreprise::V3AndMore::MI::DocumentsAssociationsController < APIEntreprise::V3AndMore::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors
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

  def organizer
    @organizer ||= retrieve_payload_data(::MI::Associations::Documents, cache: true, expires_in: 1.hour)
  end
end
