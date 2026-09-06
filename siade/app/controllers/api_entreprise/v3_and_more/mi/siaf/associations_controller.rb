class APIEntreprise::V3AndMore::MI::SIAF::AssociationsController < APIEntreprise::V3AndMore::BaseController
  def show
    if organizer.success?
      render json: organizer[:payload],
        status: organizer[:status]
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

  def serializer_module
    ::APIEntreprise::MI::SIAF::AssociationsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::MI::SIAF::Associations)
  end
end
