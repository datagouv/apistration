class APIEntreprise::V3AndMore::INSEE::SiegesDiffusablesUnitesLegalesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = ::INSEE::SiegeDiffusableUniteLegale.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::EtablissementSerializer
  end
end
