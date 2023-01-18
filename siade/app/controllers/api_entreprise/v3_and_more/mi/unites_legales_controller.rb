class APIEntreprise::V3AndMore::MI::UnitesLegalesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = ::MI::UniteLegale.call(params: organizer_params)

    if organizer.success?
      render json:   serializer_class.new(organizer.bundled_data).serializable_hash,
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
