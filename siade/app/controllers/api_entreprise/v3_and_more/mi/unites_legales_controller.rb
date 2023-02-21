class APIEntreprise::V3AndMore::MI::UnitesLegalesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::DJEPVA::UniteLegale)

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
      id: params.require(:siren_or_rna)
    }
  end

  def serializer_module
    ::APIEntreprise::MI::UniteLegaleSerializer
  end
end
