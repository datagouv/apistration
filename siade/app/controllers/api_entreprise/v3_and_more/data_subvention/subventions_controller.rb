class APIEntreprise::V3AndMore::DataSubvention::SubventionsController < APIEntreprise::V3AndMore::BaseController
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
      siren_or_siret_or_rna: params.require(:siren_or_siret_or_rna)
    }
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DataSubvention::Subventions)
  end

  def serializer_module
    ::APIEntreprise::DataSubvention::SubventionsSerializer
  end
end
